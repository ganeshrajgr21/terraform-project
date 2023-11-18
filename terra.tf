resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production_server"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
  Name = "igw-1" }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "prod-subnet1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "prod-subnet2"
  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"
}

#route table:
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "route_Table"
  }
}

#attaching internet gateway to route table:
resource "aws_route" "routing" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "route-1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_instance" "ec2_instance_1" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet-1.id
  associate_public_ip_address = true
  tags = {
    Name = "FirstEC2Instnace"
  }
}

resource "aws_instance" "ec2_instance-2" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet-2.id
  associate_public_ip_address = true
  tags = {
    Name = "SecondEC2Instnace"
  }
}
