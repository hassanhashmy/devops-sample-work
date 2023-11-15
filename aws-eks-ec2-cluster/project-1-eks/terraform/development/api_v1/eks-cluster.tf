module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.1.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.22"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "development"
    ClusterEnv = "DEVELOPMENT"
    GithubOrg   = "hassanhashmy"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp3"
  }

  

  worker_groups = [
  {
    name                          = "${local.cluster_name}-worker-group-1"
    instance_type                 = "t3.2xlarge"
    additional_userdata           = "env=development"
    asg_desired_capacity          = 3
    asg_max_size                  = 3
    asg_min_size                  = 3
    additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]

  },
    {
    name                          = "${local.cluster_name}-worker-group-spot-1"
    instance_type                 = "t3.xlarge"
    additional_userdata           = "env=development"
    capacity_type                 = "SPOT"
    asg_desired_capacity          = 0
    asg_max_size                  = 5
    asg_min_size                  = 0
    additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]

  },
]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
