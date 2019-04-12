output "sg_id" {
  description = "ID of the Neo4j security group"
  value       = "${aws_security_group.sg.id}"
}

output "instance_ids" {
  description = "List: IDs of the EC2 instances"
  value       = "${module.core.instance_ids}"
}

output "instances_role_id" {
  description = "IAM role ID used by the EC2 instances"
  value       = "${module.core.role_id}"
}

output "instance_public_dns" {
  description = "List: The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = "${module.core.instance_public_dns}"
}

output "instance_public_ips" {
  description = "List: The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use public_ip, as this field will change after the EIP is attached."
  value       = "${module.core.instance_public_ips}"
}

output "instance_private_dns" {
  description = "List: The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = "${module.core.instance_private_dns}"
}

output "instance_private_ips" {
  description = "List: The private IP address assigned to the instances"
  value       = "${module.core.instance_private_ip}"
}
