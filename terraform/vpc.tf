#resource "aws_vpc" "vpc" {
#  cidr_block =  local.cidr_block
#  tags = merge(local.common_tags,{
#    Name = local.project
#  })
#}
