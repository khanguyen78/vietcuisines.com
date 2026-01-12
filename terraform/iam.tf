resource "aws_iam_user" "user" {
  name = local.iam_user
  path = "/"

  tags = merge(local.common_tags,{
    Name = local.project
  })
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
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
}


output "access_key_id" {
  value       = aws_iam_access_key.key.id
  description = "Access key ID."
}

output "secret_key_id" {
  value       = aws_iam_access_key.key.secret
  description = "Secret access key."
  sensitive = true
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
}

data "aws_iam_policy_document" "github" {
  statement {
    effect    = "Allow"
    actions   = ["s3:List*", 
                  "s3:Get*",
                  "s3:Head*",
                  "s3:Put*"
                ]
    resources = ["arn:aws:s3:::*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
                  "s3:list*",
                  "s3:Put*",
                  "s3:Get*",
                  "s3:Delete*"
                ]
    resources = [                
                  "arn:aws:s3:::www.vietcuisines.com/*",
                  "arn:aws:s3:::www.vietcuisines.com/"
                ]
  }
  statement {
    effect = "Allow"
    actions = [ "cloudfront:CreateInvalidation" ] 
    resources =  [ "arn:aws:cloudfront::321753513532:distribution/*" ]
  }
  statement {
    effect = "Allow"
    actions = [ "route53:Get*",
                "route53:List*"
              ]
    resources =  [ "arn:aws:route53:::hostedzone/${aws_route53_zone.zone.zone_id}"]
  }
  statement {
    effect = "Allow"
    actions = [ "acm:DescribeCertificate",
                "acm:ListTagsForCertificate"
              ]
    resources =  [ "arn:aws:acm:us-east-1:321753513532:certificate/c428cba8-86e7-4338-859b-68a948e665cf"]
  }
  statement {
    effect = "Allow"
    actions = [ "cloudfront:Get*",
                "cloudfront:List*"
              ]
    resources =  [ "arn:aws:cloudfront::321753513532:origin-access-control/${aws_cloudfront_origin_access_control.default.id}",
                   "arn:aws:cloudfront::321753513532:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                 ]
  }
  statement {
    effect = "Allow"
    actions = [ "iam:Get*",
                "iam:List*"
              ]
    resources =  [ "arn:aws:iam::321753513532:user/${local.iam_user}"]
  }
}
