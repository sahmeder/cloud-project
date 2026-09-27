# PART A: the role, locked to your repo
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
          "token.actions.githubusercontent.com:sub" = "repo:sahmeder@55019347/cloud-project@1391113861:*"
        }
      }
    }]
  })
}

# PART B: what the role can do
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
        "dynamodb:*",
        "iam:*"
      ]
      Resource = "*"
    }]
  })
}

output "github_deploy_role_arn" {
  value = aws_iam_role.github_deploy.arn
}
