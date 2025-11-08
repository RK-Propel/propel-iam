{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:DescribeTable",
        "dynamodb:ListTables",
        "dynamodb:CreateTable",
        "dynamodb:DeleteTable",
        "dynamodb:UpdateTable"
      ],
      "Resource": "*"
    }
  ]
}
