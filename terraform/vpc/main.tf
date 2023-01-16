# Create a VPC with the specified CIDR block, enables DNS support and hostnames, and sets tags
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-vpc-${var.environment}"
    Environment = var.environment
  }
}

# Creates an Internet Gateway and attaches it to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-igw-${var.environment}"
    Environment = var.environment
  }
}

# Create NAT Gateways, sets allocation_id and subnet_id from EIP and public subnet outputs, and sets a dependency on the Internet Gateway
resource "aws_nat_gateway" "main" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.name}-nat-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

# Create Elastic IPs, sets the number based on the number of private subnets
resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc = true

  tags = {
    Name        = "${var.name}-eip-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)

  tags = {
    Name        = "${var.name}-private-subnet-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-subnet-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

# Create database subnets
resource "aws_subnet" "database" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.database_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.database_subnets)

  tags = {
    Name        = "RDS"
    Environment = var.environment
  }
}

# Create graylog subnets
resource "aws_subnet" "graylog" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.graylog_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.graylog_subnets)
  map_public_ip_on_launch = true
 
  tags = {
    Name        = "Graylog"
    Environment = var.environment
  }
}

# Create public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-routing-table-public"
    Environment = var.environment
  }
}

# Create a public route that routes all traffic to the Internet
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Create private routing tables
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-routing-table-private-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

# Create private routes
resource "aws_route" "private" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

# Create a route table association for the private subnet
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# Creates a route table association for the public subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Creates a route table association for the graylog subnet
resource "aws_route_table_association" "public2" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.graylog.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Creates a flow log for the VPC
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc-flow-logs-role.arn
  log_destination = aws_cloudwatch_log_group.main.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

# Create a Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "main" {
  name = "gov-cloudwatch-log-group"
}

# Create a IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc-flow-logs-role" {
  name = "${var.name}-vpc-flow-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Create a IAM Role Policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc-flow-logs-policy" {
  name = "${var.name}-vpc-flow-logs-policy"
  role = aws_iam_role.vpc-flow-logs-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Output the value of the vpc id so it can be refrenced in the root module
output "id" {
  value = aws_vpc.main.id
}

# Output the value of the public subnets so it can be refrenced in the root module
output "public_subnets" {
  value = aws_subnet.public
}

# Output the value of the private subnets so it can be refrenced in the root module
output "private_subnets" {
  value = aws_subnet.private
}

# Output the value of the database subnets so it can be refrenced in the root module
output "database_subnets" {
  value = aws_subnet.database
}

# Output the value of the graylog subnets so it can be refrenced in the root module
output "graylog_subnets" {
  value = aws_subnet.graylog[*].id
}
