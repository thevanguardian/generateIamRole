output "iamRoleArn" {
  description = "Generated IAM Role ARN."
  value       = aws_iam_role.generatedRole.arn
}

output "iamAssumePolicy" {
  description = "Generated Assume Role Policy."
  value       = data.aws_iam_policy_document.generatedAssumePolicy.json
}

output "iamRolePolicy" {
  description = "Generated IAM Inline policy for IAM Role."
  value       = data.aws_iam_policy_document.generatedPolicy.json
}
