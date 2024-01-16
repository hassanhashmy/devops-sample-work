variable "ecr_repository_names" {
  description = "A list of ECR repository names"
  type        = list(string)
  default     = []
}

variable "force_delete" {
  description = "Specifies if ECR repositories will be force destroyed or not."
  type        = bool
  default     = false 
}
