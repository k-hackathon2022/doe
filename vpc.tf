# ----- VPC -----
resource "aws_vpc" "vpc_main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "elon-kiosk-vpc-main"
  }
}

# ----- Public Subnet -----
resource "aws_subnet" "vpc_main_pub_subnet" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = "172.16.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "elon-kiosk-public-subnet"
  }
}

resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "elon-kiosk-igw"
  }
}

resource "aws_route_table" "vpc_main_pub_rtb" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "elon-kiosk-public-rtb"
  }
}

resource "aws_route_table_association" "vpc_main_pub_rtb_assoc" {
  subnet_id      = aws_subnet.vpc_main_pub_subnet.id
  route_table_id = aws_route_table.vpc_main_pub_rtb.id
}

resource "aws_route" "pub_rtb_default" {
  route_table_id         = aws_route_table.vpc_main_pub_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_main.id
}

# ----- Private Subnet (API Layer) -----
resource "aws_subnet" "vpc_main_priv_subnet_api" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = "172.16.2.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "elon-kiosk-private-subnet-api"
  }
}

resource "aws_route_table" "vpc_main_priv_rtb_api" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "elon-kiosk-private-rtb-api"
  }
}

resource "aws_route_table_association" "vpc_main_priv_rtb_api_assoc" {
  subnet_id      = aws_subnet.vpc_main_priv_subnet_api.id
  route_table_id = aws_route_table.vpc_main_priv_rtb_api.id
}

resource "aws_route" "priv_rtb_api_default" {
  route_table_id         = aws_route_table.vpc_main_priv_rtb_api.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_ec2_api.primary_network_interface_id
}

# ----- Private Subnet (DB Layer) -----
resource "aws_subnet" "vpc_main_priv_subnet_db" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = "172.16.3.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "elon-kiosk-private-subnet-db"
  }
}

resource "aws_route_table" "vpc_main_priv_rtb_db" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "elon-kiosk-private-rtb-db"
  }
}

resource "aws_route_table_association" "vpc_main_priv_rtb_db_assoc" {
  subnet_id      = aws_subnet.vpc_main_priv_subnet_db.id
  route_table_id = aws_route_table.vpc_main_priv_rtb_db.id
}

resource "aws_route" "priv_rtb_db_default" {
  route_table_id         = aws_route_table.vpc_main_priv_rtb_db.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_ec2_db.primary_network_interface_id
}
