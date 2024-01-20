module "ec2-bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"


  name = "bastion-host"

  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  monitoring             = true
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = file("${path.module}/scripts/jumpbox-install.sh")
}


resource "aws_eip" "bastion_eip" {
  depends_on = [module.ec2-bastion, module.vpc]
  domain     = "vpc"
  instance   = module.ec2-bastion.id
}

# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2-bastion]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("terraform-key.pem")
  }

  ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "terraform-key.pem"
    destination = "terraform-key.pem"
  }
  ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 terraform-key.pem"
    ]
  }



}
