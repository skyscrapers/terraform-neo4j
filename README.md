# terraform-neo4j

Terraform module to setup all resources needed for setting up a Neo4j cluster (enterprise).

## neo4j

### Available variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami | String(optional, "ami-1b791862"): AMI to be used for the Neo4j nodes | string | `"ami-1b791862"` | no |
| backup\_enabled | Int(optional, false): Whether to allow client connections for taking backups | string | `"false"` | no |
| backup\_port | Int(optional, 6362): Backup client port | string | `"6362"` | no |
| backup\_sg\_ids | List(optional, []): Security group IDs for the backup client(s) | list | `<list>` | no |
| bolt\_enabled | Int(optional, true): Whether to allow client connections via Bolt | string | `"true"` | no |
| bolt\_port | Int(optional, 9000): Bolt client port | string | `"9000"` | no |
| client\_sg\_ids | List(optional, []): Security group IDs for client access to the cluster, via Bolt and/or HTTP(S) | list | `<list>` | no |
| cloudwatch\_logs\_enabled | Bool(optional, false): Whether to enable Cloudwatch Logs | string | `"false"` | no |
| core\_count | Int(optional, 1): Size of the Core Neo4j cluster | string | `"3"` | no |
| core\_type | String(optional, t2.small): Instance type to use for the Core instances | string | `"t2.small"` | no |
| customer | String(optional): Customer name | string | `""` | no |
| discovery\_port | Int(optional, 5000): Causal clustering discovery port | string | `"5000"` | no |
| environment | String(required): Environment name | string | n/a | yes |
| http\_enabled | Int(optional, true): Whether to allow client connections via HTTP | string | `"true"` | no |
| http\_port | Int(optional, 7474): HTTP client port | string | `"7474"` | no |
| https\_enabled | Int(optional, false): Whether to allow client connections via HTTPS | string | `"false"` | no |
| https\_port | Int(optional, 7473): HTTPS client port | string | `"7473"` | no |
| key\_name | String(required): ID of the SSH key to use for the Neo4j nodes | string | n/a | yes |
| name | String(optional, "neo4j"): Name to use for the Neo4j cluster | string | `"neo4j"` | no |
| project | String(required): Project name | string | n/a | yes |
| r53\_domain | String(optional, ""): R53 master name to use for setting neo4j DNS records. No records are created when not set | string | `""` | no |
| raft\_port | Int(optional, 7000): Causal clustering raft port | string | `"7000"` | no |
| security\_group\_ids | List(optional, []): Extra security group IDs to attach to the cluster. Note: a default SG is already created and exposed via outputs | list | `<list>` | no |
| subnet\_ids | List(required): Subnet IDs where to deploy the cluster | list | `<list>` | no |
| tags | Map(optional, {}): Optional tags | map | `<map>` | no |
| termination\_protection | Bool(optional, true): Whether to enable termination protection on the Ne04j nodes | string | `"true"` | no |
| transaction\_port | Int(optional, 6000): Causal clustering transaction port | string | `"6000"` | no |
| volume\_encryption\_enabled | Bool(optional, false): Whether to enables EBS encryption | string | `"false"` | no |
| volume\_iops | Int(required if volume_type="io1"): Amount of provisioned IOPS for the EBS volume | string | `"0"` | no |
| volume\_path | String(optional, "/var/lib/neo4j/data"): Mount path of the EBS volume | string | `"/var/lib/neo4j/data"` | no |
| volume\_size | Int(required): EBS volume size (in GB) to use | string | n/a | yes |
| volume\_type | String(optional, "gp2"): EBS volume type to use | string | `"gp2"` | no |
| vpc\_id | String(required): VPC ID where to deploy the cluster | string | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| instance\_ids | List: IDs of the EC2 instances |
| instance\_private\_dns | List: The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC |
| instance\_private\_ips | List: The private IP address assigned to the instances |
| instance\_public\_dns | List: The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC |
| instance\_public\_ips | List: The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use public_ip, as this field will change after the EIP is attached. |
| instances\_role\_id | IAM role ID used by the EC2 instances |
| instances\_role\_name | IAM role name used by the EC2 instances |
| sg\_id | ID of the Neo4j security group |

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
