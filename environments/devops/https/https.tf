resource "aws_acm_certificate" "atlantis" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "atlantis-certificate"
  }
}

resource "aws_route53_zone" "topia_engineering" {
  name = var.domain_name

  depends_on = [
    aws_acm_certificate.atlantis
  ]
}

resource "aws_route53_record" "atlantis_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.atlantis.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.topia_engineering.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]

  allow_overwrite = true
}

resource "aws_route53_record" "atlantis_dns" {

  zone_id = aws_route53_zone.topia_engineering.zone_id
  name    = "atlantis.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_lb.atlantis.dns_name]

  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "atlantis" {
  certificate_arn         = aws_acm_certificate.atlantis.arn
  validation_record_fqdns = [for record in aws_route53_record.atlantis_cert_validation : record.fqdn]
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "aws_lb_listener" "atlantis" {
  load_balancer_arn = data.aws_lb.atlantis.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.atlantis.arn

  default_action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.atlantis.arn
  }

  depends_on = [
    null_resource.delay
  ]
}