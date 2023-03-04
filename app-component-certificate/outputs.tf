output "certificate_id" {
  depends_on = [aws_acm_certificate_validation.component_domain_certificate]
  value      = aws_acm_certificate.component_domain_certificate.id
}

output "certificate_arn" {
  depends_on = [aws_acm_certificate_validation.component_domain_certificate]
  value      = aws_acm_certificate.component_domain_certificate.arn
}
