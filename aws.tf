

resource "aws_iam_role" "role" {
  name="role_for_grafana"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
           "Effect": "Allow",
           "Principal": {
                "Service": "grafana.amazonaws.com"
            },
            "Action": "sts:AssumeRole",

        }
    ]
})
}

resource "aws_iam_policy" "policy" {
  name="policy_for_grafana"
  policy = jsonencode({
   "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:DescribeAlarmHistory",
               "cloudwatch:DescribeAlarms",
               "cloudwatch:ListMetrics",
               "cloudwatch:GetMetricStatistics",
               "cloudwatch:GetMetricData",
                "cloudwatch:GetInsightRuleReport"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:GetLogGroupFields",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:GetQueryResults",
                "logs:GetLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": "*"
        }

    ]
}
  )
}

resource "aws_iam_role_policy_attachment" "attach" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}

resource "aws_grafana_workspace" "workspace" {
  name                     = "test-grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "CUSTOMER_MANAGED"
  data_sources             = ["CLOUDWATCH"]
  role_arn                 = aws_iam_role.role.arn
}

resource "aws_grafana_role_association" "rol" {
  role         = "ADMIN"
  user_ids = ["a94ea458-a0f1-7033-0058-47a96ced94c2"]
  workspace_id = aws_grafana_workspace.workspace.id
}

resource "aws_grafana_workspace_api_key" "key" {
  key_name        = "key"
  key_role        = "ADMIN"
  seconds_to_live =  2592000
  workspace_id    = aws_grafana_workspace.workspace.id
}



variable "region" {
  default = "ap-southeast-2"
}

