output "aws_eip_primary_public_ip" {
  value       = aws_eip.primary.public_ip
  description = "The primary Elastic IP address."
  sensitive   = false
}

output "aws_eip_secondary_public_ip" {
  value       = aws_eip.secondary.public_ip
  description = "The secondary Elastic IP address."
  sensitive   = false
}
