output "sg_id" {
  description = "ID of the Neo4j security group"
  value       = "${aws_security_group.sg.id}"
}
