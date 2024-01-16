locals {
  # returns a map of ecr repository names
  ecr_repository_names = { for _, e in var.ecr_repository_names : e => e }
}

resource "aws_ecr_repository" "this" {
  for_each = local.ecr_repository_names

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = var.force_delete
}
