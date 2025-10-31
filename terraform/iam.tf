resource "aws_iam_user" "user" {
  name = "${local.user}-github-user"
  path = "/"

  tags = merge(local.common_tags, {
    Name = local.user
  })
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}

output "aws_access_key_id" {
  value     = aws_iam_access_key.key.id
  sensitive = true
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.key.secret
  sensitive = true
}


resource "aws_iam_policy" "policy" {
  name        = "${local.user}-github-policy"
  path        = "/"
  description = "Policy for loca.user github account"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:List*",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::*",
            "Sid": "1"
        },
        {
            "Action": [
                "s3:list*",
                "s3:Put*",
                "s3:Get*",
                "s3:Delete*"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::www.vietcuisines.com/*",
                "arn:aws:s3:::www.vietcuisines.com/"
            ]
        },
        {
            "Action": "cloudfront:CreateInvalidation",
            "Effect": "Allow",
            "Resource": "arn:aws:cloudfront::321753513532:distribution/*"
        }
    ]
}
EOF
}


resource "aws_iam_user_policy_attachment" "policy_attachmen" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}
