# Configuración de la instancia EC2
resource "aws_instance" "SaulHL08_server_terr" {
  ami           = "ami-0c02fb55956c7d316"  # Ubuntu 22.04 LTS
  instance_type = "t3.micro"

  tags = {
    Name        = "SaulHL08ServerTerraform"
    Environment = "Learning"
    CreatedBy   = "SaulHL08"
  }
}

# Output para mostrar información de la instancia
output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.SaulHL08_server_terr.id
}

output "instance_public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.SaulHL08_server_terr.public_ip
}
