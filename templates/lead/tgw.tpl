{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeTransitGateways",
        "ec2:DescribeTransitGatewayAttachments",
        "ec2:DescribeTransitGatewayRouteTables",
        "ec2:CreateTransitGatewayVpcAttachment",
        "ec2:DeleteTransitGatewayVpcAttachment"
      ],
      "Resource": "*"
    }
  ]
}
