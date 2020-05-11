resource "aws_iam_policy" "server" {
  name        = local.name
  path        = "/"
  description = "Policy for ${local.name}"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecs:RegisterTaskDefinition",
                "ecs:ListClusters",
                "ecs:DescribeContainerInstances",
                "ecs:ListTaskDefinitions",
                "ecs:ListTasks",
                "ecs:DescribeTaskDefinition",
                "ecs:DescribeClusters",
                "ecs:RunTask",
                "ecs:StopTask",
                "ecs:ListContainerInstances",
                "ecs:DescribeTasks",
                "cloudwatch:GetMetricStatistics"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOT
}

resource "aws_iam_user" "server" {
  name = local.name
}

resource "aws_iam_user_policy_attachment" "server" {
  policy_arn = aws_iam_policy.server.arn
  user       = aws_iam_user.server.name
}

resource "aws_iam_access_key" "server" {
  user = aws_iam_user.server.name
}
