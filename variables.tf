locals {
  enableInlinePolicy = length(var.scopedConfig["actions"]) > 0 || length(var.scopedConfig["actions"]) > 0 || length(var.denyConfig["actions"]) > 0 ? true : false
}
variable "assumeConfig" {
  type = object({
    actions     = list(any)
    type        = string
    identifiers = list(any)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(any)
    })))
  })
  description = "assumeConfig (map): Map of configuration items to pass to the assume role policy generation."
  default = {
    actions     = ["sts:AssumeRole"]
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }
}

variable "scopedConfig" {
  type = object({
    actions   = list(any)
    resources = list(any)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(any)
    })))
  })
  description = "scopedConfig (map): Map of configuration items to pass to the role policy that's scoped to specific resources."
  default = {
    actions   = []
    resources = []
  }
}

variable "unscopedConfig" {
  type = object({
    actions = list(any)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(any)
    })))
  })
  description = "unscopedConfig (map): Map of configuration items to pass to the role policy that's unscoped and targeting '*'."
  default = {
    actions = []
  }
}

variable "denyConfig" {
  type = object({
    actions   = list(any)
    resources = list(any)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(any)
    })))
  })
  description = "denyConfig (map): Map of configuration items to pass to the role policy that's unscoped and targeting '*'."
  default = {
    actions   = []
    resources = []
  }
}

variable "roleName" {
  type        = string
  description = "roleName (str): Identification name of the generated IAM Role."
  default     = ""
}

variable "roleNamePrefix" {
  type        = string
  description = "roleNamePrefix (str): Prefix of a friendly generated name for the IAM Role."
  default     = ""
}

variable "rolePath" {
  type        = string
  description = "rolePath (str): Logical path that the IAM Role will be stored in. (ex: '/system/')"
  default     = ""
}

variable "maxSessionDuration" {
  type        = number
  description = "maxSessionDuration (number): Number in seconds of max session duration."
  default     = 3600
}

variable "managedPolicies" {
  type        = list(any)
  description = "managedPolicies (list): List of ARNs tied to externally (AWS or Custom) managed policies to attach to the generated role."
  default     = []
}
