# PART A: the role, locked to your repo — "who may wear this costume"
resource "aws_iam_role" "github_deploy" {
  name = "github-actions-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:sahmeder/cloud-project:*"
        }
      }
    }]
  })
}

# PART B: what the costume can do — narrow permissions (note: no EC2)
resource "aws_iam_role_policy" "github_deploy_permissions" {
  name = "deploy-permissions"
  role = aws_iam_role.github_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:*",
        "cloudfront:*",
        "dynamodb:*"
      ]
      Resource = "*"
    }]
  })
}

# Print the role's identifier — needed for the GitHub pipeline in Phase 4
output "github_deploy_role_arn" {
  value = aws_iam_role.github_deploy.arn
}
