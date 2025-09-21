# Generador de ID aleatorio para nombre único
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Bucket S3 creado por Terraform
resource "aws_s3_bucket" "saulhl08_terraform_bucket" {
  bucket = "saulhl08-terraform-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "SaulHL08 Terraform Managed Bucket"
    Environment = "Learning"
    CreatedBy   = "Terraform"
    Project     = "Actividad5"
  }
}

# Configuración de versionado
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.saulhl08_terraform_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configuración de cifrado
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.saulhl08_terraform_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloquear acceso público
resource "aws_s3_bucket_public_access_block" "bucket_pab" {
  bucket = aws_s3_bucket.saulhl08_terraform_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output del nombre del bucket
output "bucket_name" {
  description = "Nombre del bucket creado por Terraform"
  value       = aws_s3_bucket.saulhl08_terraform_bucket.bucket
}

output "bucket_arn" {
  description = "ARN del bucket"
  value       = aws_s3_bucket.saulhl08_terraform_bucket.arn
}
