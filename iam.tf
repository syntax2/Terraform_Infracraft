data "aws_iam_policy_document" "instance_assume_role_policy" {
statement {
actions = ["sts:AssumeRole"]

principals {
  type        = "Service"
  identifiers = ["ec2.amazonaws.com"]
}
}
}

resource "aws_iam_role" "terra_role" {
name = "instance_role"
path = "/system/"
assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
role = aws_iam_role.terra_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
