resource "aws_security_group" "sg" {
  name_prefix = "${var.project}-${var.environment}-${var.name}"
  description = "Security group for the ${var.project} Neo4j cluster"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge("${var.tags}",
    map("Name", "${var.project}-${var.environment}-${var.name}",
      "Environment", "${var.environment}",
      "Project", "${var.project}"))
  }"
}

# Causal clustering SG rules

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

# Client driver SG rules

resource "aws_security_group_rule" "ingress_neo4j_bolt" {
  count                    = "${var.bolt_enabled ? length(var.client_sg_ids) : 0}"
  security_group_id        = "${aws_security_group.sg.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "${var.bolt_port}"
  to_port                  = "${var.bolt_port}"
  source_security_group_id = "${var.client_sg_ids[count.index]}"
}

resource "aws_security_group_rule" "egress_neo4j_bolt" {
  count                    = "${var.bolt_enabled ? length(var.client_sg_ids) : 0}"
  security_group_id        = "${var.client_sg_ids[count.index]}"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "${var.bolt_port}"
  to_port                  = "${var.bolt_port}"
  source_security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "ingress_neo4j_http" {
  count                    = "${var.http_enabled ? length(var.client_sg_ids) : 0}"
  security_group_id        = "${aws_security_group.sg.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "${var.http_port}"
  to_port                  = "${var.http_port}"
  source_security_group_id = "${var.client_sg_ids[count.index]}"
}

resource "aws_security_group_rule" "egress_neo4j_http" {
  count                    = "${var.http_enabled ? length(var.client_sg_ids) : 0}"
  security_group_id        = "${var.client_sg_ids[count.index]}"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "${var.http_port}"
  to_port                  = "${var.http_port}"
  source_security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "ingress_neo4j_https" {
  count                    = "${var.https_enabled ? length(var.client_sg_ids) : 0}"
  security_group_id        = "${aws_security_group.sg.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "${var.https_port}"
  to_port                  = "${var.https_port}"
  source_security_group_id = "${var.client_sg_ids[count.index]}"
}

resource "aws_security_group_rule" "egress_neo4j_https" {
  count                    = "${var.https_enabled ? length(var.client_sg_ids) : 0}"
  security_group_id        = "${var.client_sg_ids[count.index]}"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "${var.https_port}"
  to_port                  = "${var.https_port}"
  source_security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "ingress_neo4j_backup" {
  count                    = "${var.backup_enabled ? length(var.backup_sg_ids) : 0}"
  security_group_id        = "${aws_security_group.sg.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "${var.backup_port}"
  to_port                  = "${var.backup_port}"
  source_security_group_id = "${var.backup_sg_ids[count.index]}"
}

resource "aws_security_group_rule" "egress_neo4j_backup" {
  count                    = "${var.backup_enabled ? length(var.backup_sg_ids) : 0}"
  security_group_id        = "${var.backup_sg_ids[count.index]}"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "${var.backup_port}"
  to_port                  = "${var.backup_port}"
  source_security_group_id = "${aws_security_group.sg.id}"
}
