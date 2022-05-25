- [Overview](#overview)
  - [Details](#details)
    - [Input Formats](#input-formats)
  - [Example Usage](#example-usage)
# Overview

Dynamically generates IAM policies based on input variables, and generates an IAM Role with those policies inline.

## Details

Handles the creation of an IAM role in a standard fashion. It uses data sources to generate IAM policy documents for both scoped (actions limited to specific resources) and unscoped (actions assigned to '*' resources), and attaches them to the IAM role as an in-line policy. It is possible to assign previously created and/or AWS managed IAM policies as well.

Conditional blocks are also supported as part of the Config variables.

### Input Formats

These are the formats for the available variables. Config variables do not require conditions to be set, but they're available for use.

- roleName: "string", conflicts with roleNamePrefix.
- roleNamePrefix: "string", conflicts with roleName.
- rolePath: "/string/", must begin and end with forward slashes.
- maxSessionDuration: number
- managedPolicies: [list of ARN]
- assumeConfig: map{actions=[list of IAM Actions], type="string", identifiers=[list of IAM identifiers], conditions=[{test="string", variable="string", values=[list]}]}
- scopedConfig: map{actions=[list of IAM Actions], resources=[list of IAM resources], conditions=[{test="string", variable="string", values=[list]}]}
- unscopedConfig: map{actions=[list of IAM Actions], conditions=[{test="string", variable="string", values=[list]}]}
- denyConfig: map{actions=[list of IAM Actions], resources=[list of IAM resources], conditions=[{test="string", variable="string", values=[list]}]}

## Example Usage

```hcl
# Simple Usage
module "simplethis" {
  source         = "thevanguardian/generateIamRole/aws"
  roleName = "SimpleAccessMacGuffin"
  scopedConfig = {
    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:Describe*",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "s3:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:dynamodb:*:*:table/prod-*",
      "arn:aws:s3:::${deploy_bucket_name}",
      "arn:aws:s3:::${deploy_bucket_name}/*",
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"
    ]
  }
}
```
```hcl
# More Advanced Usage
module "this" {
  source = "thevanguardian/generateIamRole/aws"
  version = "2.0.0"
  roleName = "AccessEKSMacGuffin" # Required
  rolePath = "/k8s/users/" # Required
  maxSessionDuration = 7200 # Optional
  assumeConfig = {
    actions     = ["sts:AssumeRoleWithSAML"]
    type        = "Federated"
    identifiers = ["ec2.amazonaws.com"]
    conditions = [{
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = "https://signin.aws.amazon.com/saml"
    }]
  }
  scopedConfig = {
    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:Describe*",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "s3:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:dynamodb:*:*:table/prod-*",
      "arn:aws:s3:::${deploy_bucket_name}",
      "arn:aws:s3:::${deploy_bucket_name}/*",
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"
    ]
  }
  unscopedConfig = {
    actions = [
      "sns:Publish",
      "dms:StartTask"
    ]
    conditions = [
      { test = "StringLike", variable = "s3:prefix", values = ["test", "meow"] },
      { test = "StringNotLike", variable = "s3:prefix", values = ["hme/"] }
    ]
  }
}
```