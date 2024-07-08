resource "aws_security_group" "security-group" {
  for_each    = var.security_groups
  name        = each.key
  description = each.value.description
  vpc_id      = var.vpc_id
  tags        = merge(
    tomap(
      {
        "Name" = each.key
      }
    ),
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each = {
    for rule in flatten([
      for sg_key, sg_value in var.security_groups : [
        for rule_key, rule_value in sg_value.ingress : {
          key                = "${sg_key}.ingress.${rule_key}"
          security_group_id  = aws_security_group.security-group[sg_key].id
          cidr_ipv4          = rule_value.cidr_ipv4
          from_port          = rule_value.from_port
          ip_protocol        = rule_value.ip_protocol
          to_port            = rule_value.to_port
          description        = rule_value.description
        }
      ]
    ]) : rule.key => rule
  }

  security_group_id = each.value.security_group_id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
  description       = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  for_each = {
    for rule in flatten([
      for sg_key, sg_value in var.security_groups : [
        for rule_key, rule_value in sg_value.egress : {
          key                = "${sg_key}.egress.${rule_key}"
          security_group_id  = aws_security_group.security-group[sg_key].id
          cidr_ipv4          = rule_value.cidr_ipv4
          from_port          = rule_value.from_port
          ip_protocol        = rule_value.ip_protocol
          to_port            = rule_value.to_port
          description        = rule_value.description
        }
      ]
    ]) : rule.key => rule
  }

  security_group_id = each.value.security_group_id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
  description       = each.value.description
}