
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  count   = var.create ? 1 : 0
  name    = "${var.EnvName}-vpc"
  cidr    = var.VPCBlock

  azs             = [var.VPCZone1, var.VPCZone2, var.VPCZone3]
  private_subnets = [var.SubnetPrivate1, var.SubnetPrivate2, var.SubnetPrivate3]
  public_subnets  = [var.SubnetPublic1, var.SubnetPublic2, var.SubnetPublic3]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_network_acl    = true
  private_dedicated_network_acl = true
  private_inbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  private_outbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]


  tags = {
    Environment = var.EnvName
  }
}














