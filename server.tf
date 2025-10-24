resource "aws_iam_role" "server" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "server_ssm_attachment" {
  role       = aws_iam_role.server.name
  policy_arn = data.aws_iam_policy.ssm_core.arn
}

resource "aws_iam_instance_profile" "server" {
  role = aws_iam_role.server.name
}

resource "aws_security_group" "server" {
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_egress_rule" "server_allow_all" {
  security_group_id = aws_security_group.server.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "server_allow_dns_tcp" {
  security_group_id = aws_security_group.server.id
  from_port         = 53
  to_port           = 53
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "server_allow_dns_udp" {
  security_group_id = aws_security_group.server.id
  from_port         = 53
  to_port           = 53
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "server_allow_dns_tls" {
  security_group_id = aws_security_group.server.id
  from_port         = 853
  to_port           = 853
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "server_allow_https" {
  security_group_id = aws_security_group.server.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_network_interface" "primary" {
  private_ips     = ["10.0.0.4"]
  subnet_id       = aws_subnet.primary.id
  security_groups = [aws_security_group.server.id]

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip_association" "primary" {
  allocation_id        = aws_eip.primary.id
  network_interface_id = aws_network_interface.primary.id
  allow_reassociation  = false
}

resource "aws_instance" "server_primary" {
  ami                                  = "ami-0444794b421ec32e4"
  disable_api_termination              = true
  disable_api_stop                     = true
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3a.small"
  monitoring                           = false
  iam_instance_profile                 = aws_iam_instance_profile.server.name

  primary_network_interface {
    network_interface_id = aws_network_interface.primary.id
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }
}

resource "aws_ec2_instance_state" "server_primary" {
  instance_id = aws_instance.server_primary.id
  state       = "running"
}
