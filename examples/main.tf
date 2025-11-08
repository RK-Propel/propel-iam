module "admin_role" {
  source = "../"
  
  role_name = "MyAdminRole"
  role_type = "admin"
  services  = ["all"]  # Includes all available services
}

module "lead_role" {
  source = "../"
  
  role_name = "MyLeadRole"
  role_type = "lead"
  services  = ["all"]  # Includes all available services
}

module "developer_role" {
  source = "../"
  
  role_name = "MyDeveloperRole"
  role_type = "developer"
  services  = ["s3", "lambda", "dynamodb"]  # Specific services only
}

module "readonly_role" {
  source = "../"
  
  role_name = "MyReadOnlyRole"
  role_type = "readonly"
  # services parameter ignored - uses ReadOnlyAccess managed policy for all services
}

module "support_role" {
  source = "../"
  
  role_name = "MySupportRole"
  role_type = "support"
  # services parameter ignored - uses ReadOnlyAccess + AWSSupportAccess managed policies
}
