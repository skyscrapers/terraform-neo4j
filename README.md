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
* [`client_sg_ids`]: List(optional, []): Security group IDs for client access to the cluster, via Bolt and/or HTTP(S)
* [`backup_sg_ids`]: List(optional, []): Security group IDs for the backup client(s)
* [`discovery_port`]: Int(optional, 5000): Causal clustering discovery port
* [`raft_port`]: Int(optional, 7000): Causal clustering raft port
* [`transaction_port`]: Int(optional, 6000): Causal clustering transaction port
* [`bolt_enabled`]: Bool(optional, true): Whether to allow client connections via Bolt
* [`bolt_port`]: Int(optional, 9000): Bolt client port
* [`http_enabled`]: Bool(optional, true): Whether to allow client connections via HTTP
* [`http_port`]: Int(optional, 7474): HTTP client port
* [`https_enabled`]: Bool(optional, false): Whether to allow client connections via HTTPS
* [`https_port`]: Int(optional, 7473): HTTPS client port
* [`backup_enabled`]: Bool(optional, false): Whether to allow client connections for taking backups
* [`backup_port`]: Int(optional, 6362): Backup client port
* [`termination_protection`]: Bool(optional, true): Whether to enable termination protection on the Ne04j nodes
* [`cloudwatch_logs_enabled`]: Bool(optional, false): WHether to enable Cloudwatch Logs
* [`r53_domain`]: String(optional, \"\"): R53 master name to use for setting neo4j DNS records. No records are created when not set
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
  client_sg_ids      = ["${data.aws_security_group.kubernetes.id}"]
  backup_enabled     = true
  backup_sg_ids      = ["${data.terraform_remote_state.static.jumphost_sg_id}"]
  r53_domain         = "foo.bar"
}
```

## Backups

When using Neo4j enterprise edition, it's possible to [take (and restore) online backups via the `neo4j-admin`](https://neo4j.com/docs/operations-manual/current/backup/backup-introduction/) tool. Controlling backup access is done by setting the following variables:

* [`backup_sg_ids`]
* [`backup_enabled`]
* [`backup_port`]

## Logging

<!-- TODO -->
