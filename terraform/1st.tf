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
    Name = "demo-sg-tag"
}

}
