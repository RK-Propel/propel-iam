{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:SetQueueAttributes",
        "sqs:ListQueues",
        "sqs:CreateQueue",
        "sqs:DeleteQueue",
        "sqs:PurgeQueue"
      ],
      "Resource": "*"
    }
  ]
}
