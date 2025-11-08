{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDB*",
        "rds:CreateDBInstance",
        "rds:DeleteDBInstance",
        "rds:ModifyDBInstance",
        "rds:StartDBInstance",
        "rds:StopDBInstance",
        "rds:RebootDBInstance",
        "rds:CreateDBSnapshot",
        "rds:DeleteDBSnapshot"
      ],
      "Resource": "*"
    }
  ]
}
