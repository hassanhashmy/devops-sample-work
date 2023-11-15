
module "Bastionhost_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"
  count   = var.create ? 1 : 0
  name    = "${var.EnvName}-${var.ec2_sg}"
  vpc_id  = var.vpc_id

  ingress_cidr_blocks = var.cidr_blocks_sg
  ingress_with_cidr_blocks = [
    {
      from_port = 22
      protocol  = "tcp"
      to_port   = 22
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    }

  ]

}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"
  count   = var.create ? 1 : 0
  name    = "${var.EnvName}-${var.ec2_instance_name}"

  ami                    = data.aws_ami.instance_ami.id
  instance_type          = var.instancetype
  key_name               = var.keypair
  monitoring             = false
  vpc_security_group_ids = [module.Bastionhost_sg[0].security_group_id]
  subnet_id              = var.Publicsubnet_id

  tags = {
    Environment = "${var.EnvName}-${var.ec2_instance_name}"
  }
}

resource "aws_eip" "BastionElasticIp" {
  count    = var.create ? 1 : 0
  instance = module.ec2_instance[0].id
  tags = {
    Name = "${var.EnvName}-${var.ec2_instance_name}-eip"
  }
}













