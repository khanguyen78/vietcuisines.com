resource "aws_route53_zone" "zone" {
  name = local.project
  tags = merge(local.common_tags,{
    Name = local.project
    Environment = local.environment
  })
}

##### Outputs #####

output "route53_nameservers" {
  value       = aws_route53_zone.zone.name_servers
  description = "The list of name servers for the hosted zone"
}

output "route53_hosted_zone_id" {
  value = aws_route53_zone.zone.zone_id
  description = "The Hosted Zone ID"
}
