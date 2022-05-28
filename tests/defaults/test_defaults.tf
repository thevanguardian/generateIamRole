terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
module "ManagedPolicies" {
  source          = "../.."
  roleNamePrefix  = "ManagedPoliciesBuild"
  managedPolicies = ["arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess"]
}
module "BasicScoped" {
  source   = "../.."
  roleName = "BasicScoped"
  assumeConfig = {
    actions     = ["sts:AssumeRole"]
    type        = "Service"
    identifiers = ["lambda.amazonaws.com"]
  }
  scopedConfig = {
    actions = [
      "dynamodb:UpdateItem",
      "s3:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:s3:::s3-bucket-name/*",
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"
    ]
  }
}

module "Conditional" {
  source             = "../.."
  roleName           = "AccessEKSMacGuffin" # Required
  rolePath           = "/system/"           # Required
  maxSessionDuration = 7200                 # Optional
  managedPolicies    = ["arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess"]
  assumeConfig = {
    actions     = ["sts:AssumeRole"]
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
    conditions = [
      { test = "StringEquals", variable = "SAML:aud", values = ["https://signin.aws.amazon.com/saml"] }
    ]
  }
  scopedConfig = {
    actions = [
      "dynamodb:UpdateItem",
      "s3:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:s3:::s3-bucket-name/*",
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"
    ]
  }
  unscopedConfig = {
    actions = [
      "s3:*"
    ]
  }
}
