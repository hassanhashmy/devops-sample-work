variable "aws_region" {
  description = "Aws region"
  type        = string
  default     = "eu-west-2"
}

variable "name" {
  description = "Project name, also name of the EKS cluster"
  type        = string
  default     = "sample"
}

################################################################################
# ECR
################################################################################

variable "ecr_image_tag" {
  description = "Specifies image tag for deployments"
  type        = string
}

variable "ecr_repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
  default     = []
}

variable "create_ecr" {
  description = "Specifies if creating ECR repositories or not. This requires ecr_repository_names must be set accordingly."
  type        = bool
  default     = false
} 

variable "ecr_force_delete" {
  description = "Specifies if all ECR repositories will be destroyed upton the environment termination."
  type        = bool
  default     = true
}

################################################################################
# Application
################################################################################

# An example of services
#  where each key specifies a type, with value contains list of applications
#
# services = {
#   api = ["blue", "orange"]
# }

variable "services" {
  description = "Service types and their associated applications"
  type        = any
  default     = {}
}
