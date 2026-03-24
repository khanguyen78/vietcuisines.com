resource "aws_route53_zone" "zone" {
  name = local.project
  tags = merge(local.common_tags, {
    Name        = local.project
    Environment = local.environment
  })
}

##### Outputs #####

output "route53_nameservers" {
  value       = aws_route53_zone.zone.name_servers
  description = "The list of name servers for the hosted zone"
}
