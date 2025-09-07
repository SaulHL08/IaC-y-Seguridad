resource "aws_instance" "SaulHL08_server_terr" {
  ami           = "ami-0bbdd8c17ed981ef9"
  instance_type = "t3.micro"

  tags = {
    Name = "SaulHL08ServerTerraform"
  }
}
