# terraform-neo4j

Terraform module to setup all resources needed for setting up a Neo4j cluster (enterprise).

## neo4j

### Available variables

* [`project`]: String(required): Project name
* [`environment`]: String(required): Environment name
* [`customer`]: String(optional): Customer name
* [`name`]: String(optional, \"neo4j\"): Name to use for the Neo4j cluster
* [`ami`]: String(optional, \"\"): AMI to be used for the Neo4j nodes
* [`key_name`]: String(required): ID of the SSH key to use for the Neo4j nodes
* [`core_count`]: Int(optional, 3): Size of the Core Neo4j cluster
* [`core_type`]: String(optional, t2.small): Instance type to use for the Core instances
* [`volume_type`]: String(optional, \"gp2\"): EBS volume type to use
* [`volume_size`]: Int(required): EBS volume size (in GB) to use
* [`volume_iops`]: Int(required if volume_type=\"io1\"): Amount of provisioned IOPS for the EBS volume
* [`volume_encryption_enabled`]: Bool(optional, false): Whether to enables EBS encryption
* [`volume_path`]: String(optional, \"/var/lib/neo4j/data\"): Mount path of the EBS volume
* [`vpc_id`]: String(required): VPC ID where to deploy the cluster
* [`subnet_ids`]: List(required): Subnet IDs where to deploy the cluster
* [`security_group_ids`]: List(optional, []): Extra security group IDs to attach to the cluster. Note: a default SG is already created and exposed via outputs
* [`discovery_port`]: Int(optional, 5000): Causal clustering discovery port
* [`raft_port`]: Int(optional, 7000): Causal clustering raft port
* [`transaction_port`]: Int(optional, 6000): Causal clustering transaction port
* [`termination_protection`]: Bool(optional, true): Whether to enable termination protection on the Ne04j nodes
* [`cloudwatch_logs_enabled`]: Bool(optional, false): WHether to enable Cloudwatch Logs
* [`tags`]: Map(optional, {}): Optional tags

### Outputs

* [`sg_id`]: ID of the Neo4j security group

### Example

#### Setting up a cluster

```terraform
module "neo4j" {
  source             = "github.com/skyscrapers/terraform-neo4j?ref=0.1"
  project            = "${var.project}"
  environment        = "${terraform.workspace}"
  name               = "neo4j"
  key_name           = "key"
  volume_size        = 50
  vpc_id             = "${module.vpc.vpc_id}"
  subnet_ids         = "${module.vpc.private_db_subnets}"
  security_group_ids = ["${module.sg_all.sg_id}"]
}
```

#### Allowing access to the cluster

```terraform
resource "aws_security_group_rule" "ingress_neo4j_bolt" {
  security_group_id        = "${module.neo4j.sg_id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "7687"
  from_port                = "7687"
  source_security_group_id = "neo4j_clients_sg"
}

resource "aws_security_group_rule" "ingress_neo4j_http" {
  security_group_id        = "${module.neo4j.sg_id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "7474"
  from_port                = "7474"
  source_security_group_id = "neo4j_clients_sg"
}

resource "aws_security_group_rule" "ingress_neo4j_https" {
  security_group_id        = "${module.neo4j.sg_id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "7473"
  from_port                = "7473"
  source_security_group_id = "neo4j_clients_sg"
}

resource "aws_security_group_rule" "ingress_neo4j_backup" {
  security_group_id        = "${module.neo4j.sg_id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "6362"
  from_port                = "6362"
  source_security_group_id = "bastion_sg"
}
```

## Backups

<!-- TODO -->

## Logging

<!-- TODO -->
