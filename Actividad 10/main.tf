provider "aws" {
  region = "us-east-1"
}

variable "key_name" {
  description = "Nombre de la key pair en AWS"
  default     = "ansible-docker-key"
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible-docker-sg"
  description = "Security group for Ansible Docker activity"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-docker-sg"
  }
}

resource "aws_instance" "docker_nodes" {
  count         = 3
  ami           = "ami-0360c520857e3138f"
  instance_type = "t3.micro"
  key_name      = var.key_name
  
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags = {
    Name = "docker-node-${count.index + 1}"
  }
}

output "instance_ips" {
  value = aws_instance.docker_nodes[*].public_ip
}
