terraform {
  backend "s3" {
    bucket  = "tf-20250309"
    key     = "tfstate/terraform.tfstate"
    profile = "admin"
    region  = "ap-northeast-1"
  }
}
