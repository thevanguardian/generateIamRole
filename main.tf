resource "aws_iam_role" "generatedRole" {
  name                 = var.roleName != "" ? var.roleName : null
  name_prefix          = var.roleNamePrefix != "" ? var.roleNamePrefix : null
  path                 = var.rolePath != "" ? var.rolePath : null
  max_session_duration = var.maxSessionDuration
  assume_role_policy   = data.aws_iam_policy_document.generatedAssumePolicy.json
  managed_policy_arns  = length(var.managedPolicies) > 0 ? var.managedPolicies : null
  dynamic "inline_policy" {
    for_each = local.enableInlinePolicy ? toset([1]) : []
    content {
      name   = "GeneratedPolicy"
      policy = data.aws_iam_policy_document.generatedPolicy.json
    }
  }
}
