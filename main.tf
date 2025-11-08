variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "role_type" {
  description = "Type of role: admin, lead, developer, readonly, support"
  type        = string
  validation {
    condition     = contains(["admin", "lead", "developer", "readonly", "support"], var.role_type)
    error_message = "Role type must be admin, lead, developer, readonly, or support."
  }
}

variable "services" {
  description = "List of AWS services to include or 'all' for all services"
  type        = list(string)
  default     = []
}

variable "trusted_entities" {
  description = "Trusted entities for assume role policy"
  type        = list(string)
  default     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
}

locals {
  all_services = ["s3", "ec2", "sqs", "sns", "lambda", "ssm", "secretsmanager", "rds", "dynamodb", "vpc", "tgw", "route53", "kms", "cloudfront"]
  
  selected_services = contains(var.services, "all") ? local.all_services : var.services
  
  # Split services into chunks of 7 to stay under 6144 character limit
  # This is a conservative approach - 7 services typically stay under the limit
  policy_chunks = contains(["admin", "lead", "developer"], var.role_type) && length(local.selected_services) > 0 ? 
    chunklist(local.selected_services, 7) : []
}
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_entities
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "chunked_policies" {
  for_each = { for i, chunk in local.policy_chunks : i => chunk }
  
  name = "${var.role_name}-policy-${each.key + 1}"
  role = aws_iam_role.this.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = flatten([
      for service in each.value : 
      jsondecode(templatefile("${path.module}/templates/${var.role_type}/${service}.tpl", {
        account_id = data.aws_caller_identity.current.account_id
      })).Statement
    ])
  })
}

resource "aws_iam_role_policy_attachment" "readonly_policy" {
  count = var.role_type == "readonly" ? 1 : 0
  
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "support_policies" {
  for_each = var.role_type == "support" ? toset([
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AWSSupportAccess"
  ]) : []
  
  role       = aws_iam_role.this.name
  policy_arn = each.key
}
