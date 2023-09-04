provider "aws" {
region  = "us-west-2"
}

resource "aws_instance" "demo-server" {
    ami = "ami-002829755fa238bfa"
    instance_type = "t2.micro"
    key_name = "devops"
    security_groups = [ "demo-sg" ]


tags = {
    Name = "demo-server"  # This tags the instance with the key "Name" and value "MyEC2Instance"
    Environment = "testing"  # You can add additional tags as needed
  }
}
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow traffic for demo-sg"

  // Ingress (Inbound) Rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere (example for a web server)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from a specific IP range
  }

  // Egress (Outbound) Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
    Name = "demo-sg"
}

}


//create vpc

resource "aws_vpc" "dpp-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpp-vpc"

  }
  
}

//create subnet

resource "aws_subnet" "dpp-public_subent_01" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "dpp-public_subnet_01"

    }

}

resource "aws_subnet" "dpp-public_subent_02" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
      Name = "dpp-public_subnet_02"

    }

}

//creating internet gateway˳

resource "aws_internet_gateway" "dpp-igw" {
  vpc_id = aws_vpc.dpp-vpc.id
  tags = {
    Name = "dpp-igw"
  }
  
}

//create route table

resource "aws_route_table" "dpp-public-rt" {
  vpc_id = aws_vpc.dpp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpp-igw.id
  }  
  tags = {
    Name = "dpp-public-rt"
  }
}

//association subnet with route table

resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
  subnet_id = aws_subnet.dpp-public_subent_01.id
  route_table_id = aws_route_table.dpp-public-rt.id  
}

resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
  subnet_id = aws_subnet.dpp-public_subent_02.id
  route_table_id = aws_route_table.dpp-public-rt.id  
}