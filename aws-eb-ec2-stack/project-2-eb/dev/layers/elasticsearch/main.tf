resource "aws_security_group" "Elasticsearch_sg" {
  count  = var.create ? 1 : 0
  vpc_id = var.vpc_id
  name   = "${var.EnvName}-${var.elasticsearch_sg}"
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

  }
  tags = {
    Name = "${var.EnvName}-${var.elasticsearch_sg}"
  }
}


resource "aws_elasticsearch_domain" "elasticsearch" {
  count                 = var.create ? 1 : 0
  domain_name           = "${var.EnvName}-${var.es_domain}"
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type          = var.es_instancetype
    instance_count         = 2
    dedicated_master_count = 2
    zone_awareness_enabled = true
    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  vpc_options {
    subnet_ids = var.Privatesubnets_ids
    

    security_group_ids = [aws_security_group.Elasticsearch_sg[0].id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
  tags = {
    Domain = "${var.EnvName}-${var.es_domain}"
  }

}
resource "aws_iam_service_linked_role" "es_role" {
  count            = var.create ? 1 : 0
  aws_service_name = "es.amazonaws.com"
  description      = "Allows Amazon ES to manage AWS resources for a domain on your behalf."
}