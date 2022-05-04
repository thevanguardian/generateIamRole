# Overview
Dynamically generates IAM policies based on input variables, and generates an IAM Role with those policies inline.

# Details
Handles the creation of an IAM role in a standard fashion. It uses data sources to generate IAM policy documents for both scoped (actions limited to specific resources) and unscoped (actions assigned to '*' resources), and attaches them to the IAM role as an in-line policy. It is possible to assign previously created and/or AWS managed IAM policies as well.

## Available Inputs
- source (required, string): Expects a string identifying the modules location and release_tag to pull in.
- roleName (required, string): Name to be assigned to the IAM Role. Conflicts with roleNamePrefix.
- roleNamePrefix (required, string): Prefix for friendly generated name of the IAM Role. Conflicts with roleName.
- rolePath (required, string): IAM Role path assignment, used to logical grouping of IAM roles.
- managedPolicies (optional, list): AWS / Customer managed IAM policies to attach to the role.
- maxSessionDuration (optional, number): Maximum session duration for IAM role assumption.
- assumeIdentifiers (required, list): AWS entities that are allowed to use the generated IAM role.
- scopedActions (optional, list): Specific IAM actions that are assigned to scopedResources.
- scopedResources (optional, list): Specific resources that are tied to scopedActions.
- unscopedActions (optional, list): Specific actions that have blanket access to all resources.

# Example Usage
```hcl
module "this" {
  source = "github.com/thevanguardian/generateIamRole?ref=<release_tag>" 
  roleName = "AccessEKSMacGuffin" # Required
  rolePath = "/k8s/users/" # Required
  maxSessionDuration = 7200 # Optional

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
