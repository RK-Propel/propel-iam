# Propel IAM

A flexible Terraform module for creating AWS IAM roles with service-specific permissions and intelligent policy management.

## Features

- **5 Role Types**: admin, lead, developer, readonly, support
- **14 AWS Services**: Comprehensive coverage of major AWS services
- **Smart Policy Splitting**: Automatically handles AWS policy size and attachment limits
- **Flexible Service Selection**: Choose specific services or use "all"
- **AWS Compliant**: Respects 10 policy limit and 6,144 character policy size limit

## Quick Start

```hcl
module "my_role" {
  source = "path/to/propel-iam"
  
  role_name = "MyDeveloperRole"
  role_type = "developer"
  services  = ["s3", "lambda", "dynamodb"]
}
```

## Role Types

### Admin
- **Permissions**: Full access (`service:*`) to selected services
- **Use Case**: System administrators, DevOps leads
- **Example**: Complete control over infrastructure

### Lead
- **Permissions**: Management-level access (create, delete, configure resources)
- **Use Case**: Team leads, senior developers
- **Example**: Can create/delete resources, manage configurations

### Developer
- **Permissions**: Operational access (basic CRUD, limited create permissions)
- **Use Case**: Application developers, junior team members
- **Example**: Can deploy code, manage application data

### Readonly
- **Permissions**: AWS `ReadOnlyAccess` managed policy
- **Use Case**: Auditors, monitoring systems, junior staff
- **Example**: View all resources across AWS services

### Support
- **Permissions**: AWS `ReadOnlyAccess` + `AWSSupportAccess` managed policies
- **Use Case**: Support teams, help desk
- **Example**: Troubleshoot issues and create support cases

## Supported Services

| Service | Admin | Lead | Developer | Description |
|---------|-------|------|-----------|-------------|
| s3 | Full S3 access | Bucket management + policies | Object operations + list |  Object storage |
| ec2 | Full EC2 access | Instance + volume management | Basic instance operations | Compute instances |
| sqs | Full SQS access | Queue management | Message operations | Message queuing |
| sns | Full SNS access | Topic management | Publish + subscribe | Notifications |
| lambda | Full Lambda access | Function management | Function operations | Serverless compute |
| ssm | Full SSM access | Parameter management | Get/put parameters | Systems Manager |
| secretsmanager | Full access | Secret management | Get secret values | Secrets management |
| rds | Full RDS access | Database management | Start/stop instances | Relational databases |
| dynamodb | Full DynamoDB access | Table management | Data operations | NoSQL database |
| vpc | Full VPC access | Security group management | Describe only | Virtual networking |
| tgw | Full TGW access | Attachment management | Describe only | Transit Gateway |
| route53 | Full Route53 access | Zone + record management | Describe only | DNS service |
| kms | Full KMS access | Key management | Encrypt/decrypt | Key management |
| cloudfront | Full CloudFront access | Distribution management | Invalidations only | Content delivery |

## Usage Examples

### All Services
```hcl
module "admin_all_services" {
  source = "./propel-iam"
  
  role_name = "AdminRole"
  role_type = "admin"
  services  = ["all"]  # Includes all 14 services
}
```

### Specific Services
```hcl
module "web_developer" {
  source = "./propel-iam"
  
  role_name = "WebDeveloperRole"
  role_type = "developer"
  services  = ["s3", "cloudfront", "lambda", "dynamodb"]
}
```

### Infrastructure Lead
```hcl
module "infra_lead" {
  source = "./propel-iam"
  
  role_name = "InfraLeadRole"
  role_type = "lead"
  services  = ["ec2", "vpc", "rds", "kms"]
}
```

### Readonly Access
```hcl
module "auditor" {
  source = "./propel-iam"
  
  role_name = "AuditorRole"
  role_type = "readonly"
  # No services needed - gets ReadOnlyAccess to everything
}
```

## Policy Splitting Logic

### AWS Limitations
- **Policy Attachment Limit**: 10 policies per role
- **Policy Size Limit**: 6,144 characters per policy (excluding whitespace)

### How Propel IAM Handles This

#### Conservative Service-Based Chunking
The module uses a conservative approach, splitting services into chunks of 7 services each to ensure policies stay under the 6,144 character limit:

```hcl
services = ["all"]  # 14 services total
```

**Results in:**
- `RoleName-policy-1`: Services 1-7 (s3, ec2, sqs, sns, lambda, ssm, secretsmanager)
- `RoleName-policy-2`: Services 8-14 (rds, dynamodb, vpc, tgw, route53, kms, cloudfront)

#### Why Service Count Instead of Character Count?
- **Conservative**: 7 services typically stay well under 6,144 characters
- **Predictable**: Same services always create same number of policies
- **Simple**: Avoids complex character counting during Terraform planning
- **Safe**: Better to have more smaller policies than risk hitting character limit

#### Policy Naming Convention
- **Pattern**: `{role_name}-policy-{chunk_number}`
- **Examples**: 
  - `MyRole-policy-1`
  - `MyRole-policy-2`

#### Chunk Size Details
- **Services per chunk**: 7 (conservative limit for character safety)
- **Maximum chunks**: 10 (AWS policy attachment limit)
- **Maximum services**: 70 (theoretical limit with current chunking)
- **Character safety**: Each chunk typically uses 2,000-4,000 characters (well under 6,144)

### Examples by Service Count

| Services Selected | Policies Created | Policy Names |
|-------------------|------------------|--------------|
| 1-7 services | 1 policy | `RoleName-policy-1` |
| 8-14 services | 2 policies | `RoleName-policy-1`, `RoleName-policy-2` |
| 15-21 services | 3 policies | `RoleName-policy-1`, `RoleName-policy-2`, `RoleName-policy-3` |

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `role_name` | string | - | Name of the IAM role (required) |
| `role_type` | string | - | Role type: admin, lead, developer, readonly, support (required) |
| `services` | list(string) | `[]` | List of services or ["all"] for all services |
| `trusted_entities` | list(string) | `[account_root]` | Trusted entities for assume role policy |

## Outputs

| Output | Description |
|--------|-------------|
| `role_arn` | ARN of the created IAM role |
| `role_name` | Name of the created IAM role |

## Adding New Services

1. **Create template files** in `templates/{role_type}/{service}.tpl`:
   ```
   templates/
   ├── admin/{service}.tpl
   ├── lead/{service}.tpl
   └── developer/{service}.tpl
   ```

2. **Add service to locals** in `main.tf`:
   ```hcl
   locals {
     all_services = ["s3", "ec2", ..., "new_service"]
   }
   ```

3. **Use the new service**:
   ```hcl
   services = ["new_service"]
   ```

## Directory Structure

```
propel-iam/
├── main.tf                 # Main module logic
├── outputs.tf              # Module outputs  
├── README.md              # This documentation
├── examples/
│   └── main.tf            # Usage examples
└── templates/
    ├── admin/             # Admin permissions (service:*)
    │   ├── s3.tpl
    │   ├── ec2.tpl
    │   └── ...
    ├── lead/              # Management permissions
    │   ├── s3.tpl
    │   ├── ec2.tpl  
    │   └── ...
    └── developer/         # Operational permissions
        ├── s3.tpl
        ├── ec2.tpl
        └── ...
```

## Best Practices

### Service Selection
- Use `["all"]` for comprehensive roles (admin, lead)
- Select specific services for focused roles (developer)
- Consider future needs when choosing services

### Role Naming
- Use descriptive names: `WebDeveloperRole`, `DatabaseAdminRole`
- Include team/project context: `TeamA-DeveloperRole`
- Avoid generic names: `Role1`, `TestRole`

### Security Considerations
- Use least privilege principle
- Regularly review and audit role permissions
- Use readonly/support roles for non-operational access
- Consider using lead role instead of admin when possible

## Troubleshooting

### Policy Size Issues
If you encounter policy size errors:
1. The module automatically handles chunking
2. Verify template files aren't excessively large
3. Consider splitting large permission sets

### Service Not Found
If a service template is missing:
1. Check if the service exists in `templates/{role_type}/`
2. Verify the service name in the `all_services` list
3. Create the missing template file

### Role Assumption Issues
If role assumption fails:
1. Check `trusted_entities` configuration
2. Verify the assuming entity has `sts:AssumeRole` permission
3. Ensure the role ARN is correct

## License

This module is provided as-is for educational and operational use.
