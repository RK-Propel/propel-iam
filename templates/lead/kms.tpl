{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
        "kms:ListKeys",
        "kms:CreateKey",
        "kms:CreateAlias",
        "kms:DeleteAlias"
      ],
      "Resource": "*"
    }
  ]
}
