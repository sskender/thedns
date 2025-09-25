resource "aws_vpc" "main" {
  cidr_block                           = "10.0.0.0/26"
  instance_tenancy                     = "default"
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = false
}

resource "aws_subnet" "primary" {
  vpc_id                                         = aws_vpc.main.id
  cidr_block                                     = "10.0.0.0/28"
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = data.aws_availability_zones.available.names[0]
  assign_ipv6_address_on_creation                = false
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = true
}

resource "aws_subnet" "secondary" {
  vpc_id                                         = aws_vpc.main.id
  cidr_block                                     = "10.0.0.16/28"
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = data.aws_availability_zones.available.names[1]
  assign_ipv6_address_on_creation                = false
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "r" {
  route_table_id         = aws_route_table.rtb.id
  gateway_id             = aws_internet_gateway.gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_main_route_table_association" "rtb_main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtb_primary" {
  route_table_id = aws_route_table.rtb.id
  subnet_id      = aws_subnet.primary.id
}

resource "aws_route_table_association" "rtb_secondary" {
  route_table_id = aws_route_table.rtb.id
  subnet_id      = aws_subnet.secondary.id
}
