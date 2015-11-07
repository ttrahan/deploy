resource "aws_iam_policy" "demoECSPolicy" {
  name = "demoECSPolicy"
  description = "ECS Policy for the Demo"
  path = "/"
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

resource "aws_iam_role" "demoECSRole" {
  name = "demoECSRole"
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

resource "aws_iam_instance_profile" "demoECSInstProf" {
  name = "demoECSInstProf"
  roles = ["${aws_iam_role.demoECSRole.name}"]
}

resource "aws_iam_policy_attachment" "demoRolePolicyAttacH" {
  name = "demoRolePolicyAttacH"
  roles = ["${aws_iam_role.demoECSRole.name}"]
  policy_arn = "${aws_iam_policy.demoECSPolicy.arn}"
}
