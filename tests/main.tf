module "ManagedPolicies" {
  source          = "../"
  roleNamePrefix  = "ManagedPoliciesBuild"
  managedPolicies = ["arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess"]
}
module "BasicScoped" {
  source   = "../"
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
      "arn:aws:s3:::${deploy_bucket_name}/*",
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"
    ]
  }
}

module "Conditional" {
  source             = "../"
  roleName           = "AccessEKSMacGuffin" # Required
  rolePath           = "/system/"           # Required
  maxSessionDuration = 7200                 # Optional
  managedPolicies    = ["arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess"]
  assumeConfig = {
    actions     = ["sts:AssumeRole"]
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }
  assumeConditionConfig = [{
    test     = "StringEquals"
    variable = "SAML:aud"
    values   = ["https://signin.aws.amazon.com/saml"]
  }]
  unscopedConditions = [
    { test = "StringLike", variable = "s3:prefix", values = ["test", "meow"] },
    { test = "StringNotLike", variable = "s3:prefix", values = ["hme/"] }
  ]
  scopedActions = [ # Optional
    "sns:Publish",
    "dms:StartTask"
  ]
  scopedResources = [ # Optional
    "arn:aws:ecr:::repository/trill-of-joy"
  ]
  unscopedActions = [ # Optional
    "s3:GetBuckets"
  ]
}
