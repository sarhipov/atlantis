# /// Subnets
# resource "aws_subnet" "subnet" {
#   for_each = var.vpc_config.subnets
#
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = each.value.cidr
#   availability_zone       = each.value.availability_zone
#   map_public_ip_on_launch = each.value.public
#
#   tags = merge(
#     tomap(
#       {
#         Name                                        = "${var.vpc_name}-vpc-${each.key}-${each.value.availability_zone}-subnet"
#         Description                                 = each.value.description
#         "kubernetes.io/role/elb"                    = "1"
#         "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#       }
#     ),
#     local.common_tags
#   )
# }
#
# resource "aws_route_table" "routetable" {
#   for_each = var.vpc_config.subnets
#   vpc_id   = aws_vpc.vpc.id
#
#   tags = merge(
#     tomap(
#       {
#         Name = "${var.vpc_name}-vpc-${each.key}-${each.value.availability_zone}-routetable"
#       }
#     ),
#     local.common_tags
#   )
# }
#
# resource "aws_route_table_association" "public" {
#   for_each = var.vpc_config.subnets
#
#   subnet_id      = aws_subnet.subnet[each.key].id
#   route_table_id = aws_route_table.routetable[each.key].id
# }
#
# resource "aws_route" "internet_access" {
#
#   for_each = var.vpc_config.subnets
#
#   route_table_id         = aws_route_table.routetable[each.key].id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.main.id
# }