output "elastic_search_endpoint" {
  value = try(aws_elasticsearch_domain.elasticsearch[0].endpoint, null)
}