output "vpc_id" {
  value = try(module.vpc[0].vpc_id, null)
}

output "PublicSubnet1_id" {
  value = try(module.vpc[0].public_subnets[0], null)
}

output "PublicSubnet2_id" {
  value = try(module.vpc[0].public_subnets[1], null)
}

output "PublicSubnet3_id" {
  value = try(module.vpc[0].public_subnets[2], null)
}

output "PrivateSubnet1_id" {
  value = try(module.vpc[0].private_subnets[0], null)
}

output "PrivateSubnet2_id" {
  value = try(module.vpc[0].private_subnets[1], null)
}

output "PrivateSubnet3_id" {
  value = try(module.vpc[0].private_subnets[2], null)
}