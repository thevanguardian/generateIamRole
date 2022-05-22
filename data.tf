data "aws_iam_policy_document" "generatedAssumePolicy" {
  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = var.assumeConfig["type"]
      identifiers = tolist(var.assumeConfig["identifiers"])
    }
    dynamic "condition" {
      for_each = toset(var.assumeConditionConfig)
      content {
        test     = condition.value["test"]
        variable = condition.value["variable"]
        values   = tolist(condition.value["values"])
      }
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
      dynamic "condition" {
        for_each = var.scopedConditions
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = tolist(condition.value["values"])
        }
      }
    }
  }
  dynamic "statement" {
    for_each = local.enableUnscopedActions
    content {
      sid       = "UnscopedActions"
      actions   = sort(var.unscopedActions)
      resources = ["*"]
      dynamic "condition" {
        for_each = var.unscopedConditions
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = tolist(condition.value["values"])
        }
      }
    }
  }
}
