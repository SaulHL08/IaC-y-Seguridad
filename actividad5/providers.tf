# Configuración de Terraform y Providers
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # Backend S3 para estado remoto
  backend "s3" {
    bucket = "tf-remote-backend-6232"
    key    = "actividad5/terraform.tfstate"
    region = "us-east-1"
  }
}

# Configuración del provider AWS
provider "aws" {
  region = var.aws_region
}

# Provider random
provider "random" {}

# Variables
variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}
