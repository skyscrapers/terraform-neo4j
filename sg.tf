resource "aws_security_group" "sg" {
  name        = "${var.project}-${var.environment}-${var.name}"
  description = "Security group for the ${var.project} Neo4j cluster"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name}",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}

resource "aws_security_group_rule" "ingress_discovery" {
  security_group_id = "${aws_security_group.sg.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "${var.discovery_port}"
  to_port           = "${var.discovery_port}"
  self              = true
}

resource "aws_security_group_rule" "egress_discovery" {
  security_group_id = "${aws_security_group.sg.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = "${var.discovery_port}"
  to_port           = "${var.discovery_port}"
  self              = true
}

resource "aws_security_group_rule" "ingress_transaction" {
  security_group_id = "${aws_security_group.sg.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "${var.transaction_port}"
  to_port           = "${var.transaction_port}"
  self              = true
}

resource "aws_security_group_rule" "egress_transaction" {
  security_group_id = "${aws_security_group.sg.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = "${var.transaction_port}"
  to_port           = "${var.transaction_port}"
  self              = true
}

resource "aws_security_group_rule" "ingress_raft" {
  security_group_id = "${aws_security_group.sg.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "${var.raft_port}"
  to_port           = "${var.raft_port}"
  self              = true
}

resource "aws_security_group_rule" "egress_raft" {
  security_group_id = "${aws_security_group.sg.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = "${var.raft_port}"
  to_port           = "${var.raft_port}"
  self              = true
}
