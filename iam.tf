data "aws_iam_policy_document" "instances" {
  statement {
    effect    = "Allow",
    resources = ["*"],
    actions   = [
      "ec2:DescribeInstances",
      "ec2:DescribeVolume*",
    ],
  }
}

resource "aws_iam_policy" "instances" {
  name   = "${var.project}-${var.environment}-${var.name}"
  policy = "${data.aws_iam_policy_document.instances.json}"
}

resource "aws_iam_role_policy_attachment" "instances_core" {
  role       = "${module.core.role_id}"
  policy_arn = "${aws_iam_policy.instances.arn}"
}

data "aws_iam_policy_document" "cwlogs" {
  statement {
    effect    = "Allow",
    resources = ["*"],
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ],
  }
}

resource "aws_iam_policy" "cwlogs" {
  count  = "${var.cloudwatch_logs_enabled ? 1 : 0}"
  name   = "${var.project}-${var.environment}-${var.name}-cwlogs"
  policy = "${data.aws_iam_policy_document.cwlogs.json}"
}

resource "aws_iam_role_policy_attachment" "cwlogs_core" {
  count      = "${var.cloudwatch_logs_enabled ? 1 : 0}"
  role       = "${module.core.role_id}"
  policy_arn = "${aws_iam_policy.cwlogs.arn}"
}
