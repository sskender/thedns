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
