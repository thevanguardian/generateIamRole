locals {
  enableUnscopedActions = length(var.unscopedActions) > 0 ? [1] : []
  enableScopedActions   = length(var.scopedActions) > 0 ? [1] : []
  enableDenyActions     = length(var.denyActions) > 0 ? [1] : []
}
variable "scopedActions" {
  type        = list(any)
  description = "scopedActions (list): List of actions to pass to the IAM policy generation"
  default     = []
}

variable "scopedConditions" {
  type        = any
  description = "scopedConditions (list): List of of maps setting test, variable, and value."
  default     = []
}

variable "scopedResources" {
  type        = list(any)
  description = "scopedResources (list): List of resources that have the actions assigned during IAM policy generation"
  default     = []
}

variable "denyActions" {
  type        = list(any)
  description = "denyActions (list): List of actions to pass to the IAM policy generation"
  default     = []
}

variable "denyConditions" {
  type        = any
  description = "denyConditions (list): List of of maps setting test, variable, and value."
  default     = []
}

variable "denyResources" {
  type        = list(any)
  description = "denyResources (list): List of resources that have the actions assigned during IAM policy generation"
  default     = []
}

variable "unscopedActions" {
  type        = list(any)
  description = "unscopedActions (list): List of actions that are unscoped and have access to '*'."
  default     = []
}
variable "unscopedConditions" {
  type        = any
  description = "unscopedConditions (list): List of of maps setting test, variable, and value."
  default     = []
}

variable "assumeConfig" {
  type        = any
  description = "assumeConfig (map): Map for type and list of identifiers."
  default = {
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }
}

variable "assumeConditionConfig" {
  type        = any
  description = "assumeConditionConfig (list): List of maps setting conditional IAM rules for assume role generation. Supports test (string), variable (string), values (string)."
  default     = []
}

variable "policyConditionConfig" {
  type        = list(any)
  description = "policyConditionConfig (list): List of maps setting conditional IAM rules for policy generation. Supports test (string), variable (string), values (string)."
  default     = []
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
