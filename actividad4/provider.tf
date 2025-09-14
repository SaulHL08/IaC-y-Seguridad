terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

# Configurar el proveedor AWS
provider "aws" {
  region = var.aws_region
}

# Variable para la región
variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}
