data "aws_route53_zone" "domain" {
  count = "${var.r53_domain == "" ? 0 : 1}"
  name  = "${var.r53_domain}"
}

resource "aws_route53_record" "core_record" {
  count   = "${var.r53_domain == "" ? 0 : var.core_count}"
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${var.project}-${var.name}-core${format("%02d", count.index + 1)}.${data.aws_route53_zone.domain.name}"
  type    = "A"
  ttl     = "60"
  records = ["${module.core.instance_private_ip[count.index]}"]
}

resource "aws_route53_record" "cluster_record" {
  count   = "${var.r53_domain == "" ? 0 : 1}"
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${var.project}-${var.name}.${data.aws_route53_zone.domain.name}"
  type    = "A"
  ttl     = "60"
  records = ["${module.core.instance_private_ip}"]
}
