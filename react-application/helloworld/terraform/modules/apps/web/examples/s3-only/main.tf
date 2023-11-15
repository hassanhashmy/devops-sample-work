module "app" {
  source = "../../"

  name        = "example-app"
  environment = "dev"

  force_destroy = true
}

