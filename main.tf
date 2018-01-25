module "core" {
  source                 = "github.com/skyscrapers/terraform-instances//instance?ref=2.0.14"
  project                = "${var.project}"
  environment            = "${var.environment}"
  name                   = "${var.name}-core"
  instance_count         = "${var.core_count}"
  instance_type          = "${var.core_type}"
  ami                    = "${var.ami}"
  termination_protection = "${var.termination_protection}"
  key_name               = "${var.key_name}"
  subnets                = "${var.subnet_ids}"
  sgs                    = ["${aws_security_group.sg.id}", "${var.security_group_ids}"]
  user_data              = "${data.template_cloudinit_config.userdata.*.rendered}"

  tags = "${merge("${var.tags}",
    map("neo4j", "core")
  )}"
}

resource "aws_ebs_volume" "core" {
  count             = "${var.core_count}"
  availability_zone = "${module.core.instance_azs[count.index]}"
  size              = "${var.volume_size}"
  type              = "${var.volume_type}"
  iops              = "${var.volume_iops}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name}-coredata${count.index + 1}",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}

resource "aws_volume_attachment" "core_attach" {
  count       = "${var.core_count}"
  device_name = "/dev/xvdf"
  volume_id   = "${aws_ebs_volume.core.*.id[count.index]}"
  instance_id = "${module.core.instance_ids[count.index]}"
}

module "puppet_userdata" {
  source              = "github.com/skyscrapers/terraform-skyscrapers//puppet-userdata?ref=1.0.2"
  amount_of_instances = "${var.core_count}"
  customer            = "${var.customer == "" ? var.project : format("%s-%s", var.customer, var.project)}"
  environment         = "${var.environment}"
  function            = "${var.name}"
}

data "template_cloudinit_config" "userdata" {
  count         = "${var.core_count}"
  gzip          = true
  base64_encode = true

  # Install the aws cli
  part {
    content_type = "text/cloud-config"

    content = <<EOF
packages:
  - awscli
EOF
  }

  # Add an fstab entry for the mounts
  part {
    content_type = "text/cloud-config"

    content = <<EOF
mounts:
  - [ "LABEL=NEO4J", ${var.volume_path}, ext4, "defaults,nofail", "0", "2" ]
EOF
  }

  # Prepare and mount the EBS volume
  part {
    content_type = "text/x-shellscript"

    content = <<EOF
#!/bin/bash

# Wait for the EBS volumes to become ready
aws --region $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//') ec2 wait volume-in-use --filters Name=attachment.instance-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) Name=attachment.device,Values=/dev/xvdf

# Create FS
if $(blkid -p /dev/xvdf &>/dev/null); then
  mkfs.ext4 /dev/xvdf -L NEO4J
fi

# Make sure the mount path exists
mkdir -p ${var.volume_path}

# Mount the drive
mount -a
EOF
  }

  # Bootstrap puppet
  part {
    content_type = "text/x-shellscript"
    content      = "${module.puppet_userdata.user_datas[count.index]}"
  }
}

data "aws_route53_zone" "domain" {
  count        = "${var.r53_domain == "" ? 0 : 1}"
  name         = "${var.environment}.${var.r53_domain}"
}

resource "aws_route53_record" "core_record" {
  count   = "${var.r53_domain == "" ? 0 : var.core_count}"
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${var.project}-${var.name}-core${format("%02d", count.index + 1)}.${data.aws_route53_zone.domain.name}"
  type    = "A"
  ttl     = "60"
  records = ["${module.core.instance_private_ip[count.index]}"]
}
