terraform {
  experiments = [module_variable_optional_attrs]
}

data "aws_iam_policy_document" "generatedAssumePolicy" {
  statement {
    sid     = "AssumeRole"
    actions = var.assumeConfig["actions"]
    principals {
      type        = var.assumeConfig["type"]
      identifiers = var.assumeConfig["identifiers"]
    }
    dynamic "condition" {
      for_each = var.assumeConfig["conditions"] != null ? var.assumeConfig["conditions"] : []
      content {
        test     = condition.value["test"]
        variable = condition.value["variable"]
        values   = tolist(condition.value["values"])
      }
    }
  }
}

data "aws_iam_policy_document" "generatedScopedPolicy" {
  dynamic "statement" {
    for_each = length(var.scopedConfig["actions"]) > 0 ? [1] : []
    content {
      sid       = "ScopedActions"
      actions   = var.scopedConfig["actions"]
      resources = var.scopedConfig["resources"]
      dynamic "condition" {
        for_each = var.scopedConfig["conditions"] != null ? var.scopedConfig["conditions"] : []
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = tolist(condition.value["values"])
        }
      }
    }
  }
}

data "aws_iam_policy_document" "generatedUnscopedPolicy" {
  dynamic "statement" {
    for_each = length(var.unscopedConfig["actions"]) > 0 ? [1] : []
    content {
      sid       = "UnscopedActions"
      actions   = var.unscopedConfig["actions"]
      resources = ["*"]
      dynamic "condition" {
        for_each = var.unscopedConfig["conditions"] != null ? var.unscopedConfig["conditions"] : []
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = tolist(condition.value["values"])
        }
      }
    }
  }
}

data "aws_iam_policy_document" "generatedDenyPolicy" {
  dynamic "statement" {
    for_each = length(var.denyConfig["actions"]) > 0 ? [1] : []
    content {
      sid       = "Denials"
      effect    = "Deny"
      actions   = var.denyConfig["actions"]
      resources = var.denyConfig["resources"]
      dynamic "condition" {
        for_each = var.denyConfig["conditions"] != null ? var.denyConfig["conditions"] : []
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = tolist(condition.value["values"])
        }
      }
    }
  }
}

data "aws_iam_policy_document" "generatedPolicy" {
  source_policy_documents = flatten([
    data.aws_iam_policy_document.generatedScopedPolicy[*].json,
    data.aws_iam_policy_document.generatedUnscopedPolicy[*].json,
    data.aws_iam_policy_document.generatedDenyPolicy[*].json
  ])
}
