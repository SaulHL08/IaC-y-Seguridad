# Configuración del bucket S3
resource "aws_s3_bucket" "SaulHL08_bucket" {
  bucket = "saulhl08-terraform-bucket-2025"
  
  tags = {
    Name        = "SaulHL08 Terraform Bucket"
    Environment = "Learning"
    CreatedBy   = "SaulHL08"
  }
}

# Configuración de versionado del bucket
resource "aws_s3_bucket_versioning" "SaulHL08_bucket_versioning" {
  bucket = aws_s3_bucket.SaulHL08_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configuración de cifrado del bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "SaulHL08_bucket_encryption" {
  bucket = aws_s3_bucket.SaulHL08_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloquear acceso público
resource "aws_s3_bucket_public_access_block" "SaulHL08_bucket_pab" {
  bucket = aws_s3_bucket.SaulHL08_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
