variable "project" {
  description = "String(required): Project name"
}

variable "environment" {
  description = "String(required): Environment name"
}

variable "customer" {
  description = "String(optional): Customer name"
  default = ""
}

variable "name" {
  description = "String(optional, \"neo4j\"): Name to use for the Neo4j cluster"
  default     = "neo4j"
}

variable "ami" {
  description = "String(optional, \"ami-1b791862\"): AMI to be used for the Neo4j nodes"
  default     = "ami-1b791862"
}

variable "key_name" {
  description = "String(required): ID of the SSH key to use for the Neo4j nodes"
}

variable "core_count" {
  description = "Int(optional, 1): Size of the Core Neo4j cluster"
  default     = 3
}

variable "core_type" {
  description = "String(optional, t2.small): Instance type to use for the Core instances"
  default     = "t2.small"
}

variable "volume_type" {
  description = "String(optional, \"gp2\"): EBS volume type to use"
  default     = "gp2"
}

variable "volume_size" {
  description = "Int(required): EBS volume size (in GB) to use"
}

variable "volume_iops" {
  description = "Int(required if volume_type=\"io1\"): Amount of provisioned IOPS for the EBS volume"
  default     = 0
}

variable "volume_encryption_enabled" {
  description = "Bool(optional, false): Whether to enables EBS encryption"
  default     = false
}

variable "volume_path" {
  description = "String(optional, \"/var/lib/neo4j/data\"): Mount path of the EBS volume"
  default     = "/var/lib/neo4j/data"
}

variable "vpc_id" {
  description = "String(required): VPC ID where to deploy the cluster"
}

variable "subnet_ids" {
  description = "List(required): Subnet IDs where to deploy the cluster"
  type        = "list"
  default     = []
}

variable "security_group_ids" {
  description = "List(optional, []): Extra security group IDs to attach to the cluster. Note: a default SG is already created and exposed via outputs"
  type        = "list"
  default     = []
}

variable "client_sg_ids" {
  description = "List(optional, []): Security group IDs for client access to the cluster, via Bolt and/or HTTP(S)"
  type        = "list"
  default     = []
}

variable "backup_sg_ids" {
  description = "List(optional, []): Security group IDs for the backup client(s)"
  type        = "list"
  default     = []
}

variable "discovery_port" {
  description = "Int(optional, 5000): Causal clustering discovery port"
  default     = 5000
}

variable "raft_port" {
  description = "Int(optional, 7000): Causal clustering raft port"
  default     = 7000
}

variable "transaction_port" {
  description = "Int(optional, 6000): Causal clustering transaction port"
  default     = 6000
}

variable "bolt_enabled" {
  description = "Int(optional, true): Whether to allow client connections via Bolt"
  default     = true
}

variable "bolt_port" {
  description = "Int(optional, 9000): Bolt client port"
  default     = 9000
}

variable "http_enabled" {
  description = "Int(optional, true): Whether to allow client connections via HTTP"
  default     = true
}

variable "http_port" {
  description = "Int(optional, 7474): HTTP client port"
  default     = 7474
}

variable "https_enabled" {
  description = "Int(optional, false): Whether to allow client connections via HTTPS"
  default     = false
}

variable "https_port" {
  description = "Int(optional, 7473): HTTPS client port"
  default     = 7473
}

variable "backup_enabled" {
  description = "Int(optional, false): Whether to allow client connections for taking backups"
  default     = false
}

variable "backup_port" {
  description = "Int(optional, 6362): Backup client port"
  default     = 6362
}

variable "termination_protection" {
  description = "Bool(optional, true): Whether to enable termination protection on the Ne04j nodes"
  default     = true
}

variable "cloudwatch_logs_enabled" {
  description = "Bool(optional, false): Whether to enable Cloudwatch Logs"
  default     = false
}

variable "r53_domain" {
  description = "String(optional, \"\"): R53 master name to use for setting neo4j DNS records. No records are created when not set"
  default     = ""
}

variable "tags" {
  description = "Map(optional, {}): Optional tags"
  type        = "map"
  default     = {}
}
