provider "aws" {
  profile = "admin"
  region  = "ap-northeast-1"
}

provider "aws" {
  profile = "admin"
  alias   = "virginia"
  region  = "us-east-1"
}
