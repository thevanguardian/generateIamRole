locals {
  enableUnscopedActions = length(var.unscopedActions) > 0 ? [1] : []
  enableScopedActions   = length(var.scopedActions) > 0 ? [1] : []
}

variable "scopedActions" {
  type        = list(any)
  description = "scopedActions (list): List of actions to pass to the IAM policy generation"
  default     = []
}

variable "scopedResources" {
  type        = list(any)
  description = "scopedResources (list): List of resources that have the actions assigned during IAM policy generation"
  default     = []
}

variable "unscopedActions" {
  type        = list(any)
  description = "unscopedActions (list): List of actions that are unscoped and have access to '*'."
  default     = []
}

variable "assumeIdentifiers" {
  type        = list(any)
  description = "assumeIdentifiers (list): List of identifiers that are allowed to assume the generated role."
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
