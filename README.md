# Deploy an IAM Role.
Dynamically generates IAM policies based on input variables, and generates an IAM Role with those policies inline.

# Example Usage
```hcl
module "this" {
  source = "git::git@github.com:wiley/do-infrastructure-modules.git//cloud/aws/wes-generateIAMRole?ref=<module-version-here>" 
  roleName = "AccessEKSMacGuffin" # Required
  rolePath = "/k8s/users/" # Required
  maxSessionDuration = "7200" # Optional

  assumeIdentifiers = ["ec2.amazonaws.com"] # Required
  scopedActions = [ # Optional
      "sns:Publish",
      "dms:StartTask"
  ]
  scopedResources = [ # Optional
      aws_sns_topic.macguffin.arn
  ]
  unscopedActions = [ # Optional
      "s3:GetBuckets"
  ]
}
```
