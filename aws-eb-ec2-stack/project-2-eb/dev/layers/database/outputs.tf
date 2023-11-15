output "aws_db_instance_endpoint" {
  value = try(module.rds[0].db_instance_endpoint, null)
}
output "aws_db_instance_replica_endpoint" {
  value = try(aws_db_instance.replica_master[0].endpoint, null)
}