resource "aws_iam_user" "user" {
  name = local.iam_user
  path = "/"

  tags = merge(local.common_tags, {
    Name = local.project
  })
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "document" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "test"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.document.json
  lifecycle {
    prevent_destroy = true
  }
}


output "access_key_id" {
  value       = aws_iam_access_key.key.id
  description = "Access key ID."
}

output "secret_key_id" {
  value       = aws_iam_access_key.key.secret
  description = "Secret access key."
  sensitive   = true
}

output "create_date" {
  value       = aws_iam_access_key.key.create_date
  description = "Date and time in RFC3339 format that the access key was created."
}

#######################################################


resource "aws_iam_user_policy" "github_policy" {
  name   = "github-${local.project}"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.github.json
  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "github" {
  statement {
    effect = "Allow"
    actions = ["s3:List*",
      "s3:Get*",
      "s3:Head*",
      "s3:Put*"
    ]
    resources = ["arn:aws:s3:::*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:list*",
      "s3:Put*",
      "s3:Get*",
      "s3:Delete*"
    ]
    resources = [
      "arn:aws:s3:::${local.cname}/*",
      "arn:aws:s3:::${local.cname}/"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["arn:aws:cloudfront::321753513532:distribution/*"]
  }
  statement {
    effect = "Allow"
    actions = ["route53:Get*",
      "route53:List*"
    ]
    resources = [aws_route53_zone.zone.arn]
  }
  statement {
    effect = "Allow"
    actions = ["acm:DescribeCertificate",
      "acm:ListTagsForCertificate"
    ]
    resources = [aws_acm_certificate.cert.arn]
  }
  statement {
    effect = "Allow"
    actions = ["cloudfront:Get*",
      "cloudfront:List*"
    ]
    resources = [aws_cloudfront_origin_access_control.default.arn,
      aws_cloudfront_distribution.s3_distribution.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = ["iam:Get*",
      "iam:List*"
    ]
    resources = [aws_iam_user.user.arn]
  }
}
