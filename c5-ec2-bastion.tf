module "ec2-bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"


  name = "bastion-host"

  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  monitoring             = true
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
}


resource "aws_eip" "bastion_eip" {
  depends_on = [ module.ec2-bastion, module.vpc ]
  domain = "vpc"
  instance = module.ec2-bastion.id
}
