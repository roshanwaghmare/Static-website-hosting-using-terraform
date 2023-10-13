#create s3 bucket

resource "aws_s3_bucket" "web" {
  bucket = var.bucketname
  }



#aws_s3_bucket_ownership_controls

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.web.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# enabled public access 


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.web.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# Added acl for public read 

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.web.id
  acl    = "public-read"
}

#put object in s3 



resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.web.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.web.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.web.id
  key    = "profile.jpg"
  source = "profile.jpg"
  acl = "public-read"
}

# website Configration 

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.web.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.example ]
}