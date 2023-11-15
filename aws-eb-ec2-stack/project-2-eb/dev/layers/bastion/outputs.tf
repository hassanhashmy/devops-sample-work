output "bastion_host_eip_address" {
  value = try(aws_eip.BastionElasticIp[0].public_ip, null)
}
/*
output "bastion_host_ip_address" {
  value = try(module.ec2_instance[0].public_ip, null)
}
*/