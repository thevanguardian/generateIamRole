data "aws_iam_policy_document" "generatedAssumePolicy" {
  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = sort(var.assumeIdentifiers)
    }
  }
}
data "aws_iam_policy_document" "generatedPolicy" {
  dynamic "statement" {
    for_each = local.enableScopedActions
    content {
      sid       = "ScopedActions"
      actions   = sort(var.scopedActions)
      resources = sort(var.scopedResources)
    }
  }
  dynamic "statement" {
    for_each = local.enableUnscopedActions
    content {
      sid       = "UnscopedActions"
      actions   = sort(var.unscopedActions)
      resources = ["*"]
    }
  }
}
