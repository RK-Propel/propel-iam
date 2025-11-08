{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDB*",
        "rds:StartDBInstance",
        "rds:StopDBInstance",
        "rds:RebootDBInstance"
      ],
      "Resource": "*"
    }
  ]
}
