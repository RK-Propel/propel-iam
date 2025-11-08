{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*Instance*",
        "ec2:*Image*",
        "ec2:*KeyPair*",
        "ec2:*SecurityGroup*",
        "ec2:*Subnet*",
        "ec2:*Vpc*",
        "ec2:*Volume*",
        "ec2:*Snapshot*",
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ],
      "Resource": "*"
    }
  ]
}
