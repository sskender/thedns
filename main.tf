provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Author    = "sskender"
      Project   = "thedns"
      Git       = "https://github.com/sskender/thedns"
      ManagedBy = "Terraform"
    }
  }
}
