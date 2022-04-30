resource "aws_iam_role" "generatedRole" {
  name                 = var.roleName
  path                 = var.rolePath != "" ? var.rolePath : null
  max_session_duration = var.maxSessionDuration
  assume_role_policy   = data.aws_iam_policy_document.generatedAssumePolicy.json
  managed_policy_arns  = length(var.managedPolicies) > 0 ? var.managedPolicies : null
  inline_policy {
    name   = "GeneratedPolicy"
    policy = data.aws_iam_policy_document.generatedPolicy.json
  }
}
