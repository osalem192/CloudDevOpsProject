terraform {
  backend "s3" {
    bucket       = "terraformbucketivolve1234"
    key          = "terraform/state"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
