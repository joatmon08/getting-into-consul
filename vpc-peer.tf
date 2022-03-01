resource "aws_vpc_peering_connection" "database" {
  peer_vpc_id = aws_vpc.database.id
  vpc_id = aws_vpc.consul.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(
    { "Name" = "${var.main_project_tag}-vpc-peering-connection"},
    { "Project" = var.main_project_tag },
    var.vpc_tags
  )
}

## Peering Connection Routes for the Database Route Table
resource "aws_route" "requester_peering_route" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = aws_vpc.database.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.database.id
}

## Research why? Why is the main route table needed?
resource "aws_route" "requester_peering_route_private" {
  route_table_id = aws_vpc.consul.main_route_table_id
  destination_cidr_block = aws_vpc.database.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.database.id
}

## Peering Connection Routes for the External VPC Route Tables to allow Consul Traffic
## Note: this associates it to the database VPC's main route table.
resource "aws_route" "accepter_peering_route" {
  route_table_id = aws_vpc.database.main_route_table_id
  destination_cidr_block = aws_vpc.consul.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.database.id
}