resource "aws_s3_bucket" "bucket_01" {
  bucket = "limoncloud-101-static"

  tags = {
    Name      = "limoncloud-101-static"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_01" {
  bucket = aws_s3_bucket.bucket_01.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "bucket_01_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_01]

  bucket = aws_s3_bucket.bucket_01.id
  acl    = "private"
}
