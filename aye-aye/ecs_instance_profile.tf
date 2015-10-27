resource "aws_iam_instance_profile" "shippable_aye_aye_ecs_ip" {
  name = "shippable_aye_aye_ecs_ip"
  roles = ["${aws_iam_role.shippable_aye_aye_ecs_role.name}"]
}



resource "aws_iam_policy" "shippable_aye_aye_ecs_policy" {
  name = "shippable_aye_aye_ecs_policy"
  path = "/"
  description = "shippable_aye_aye_ecs_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": "ecs:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "shippable_aye_aye_ecs_role" {
  name = "shippable_aye_aye_ecs_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_policy_attachment" "shippable_aye_aye_ecs_attach" {
  name = "shippable_aye_aye_ecs_attach"
  roles = ["${aws_iam_role.shippable_aye_aye_ecs_role.name}"]
  policy_arn = "${aws_iam_policy.shippable_aye_aye_ecs_policy.arn}"
}
