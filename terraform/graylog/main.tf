#Create Graylog EC2 instance
resource "aws_instance" "graylog" {
  ami                    = var.ami_id
  instance_type          = var.instance
  key_name               = var.key_name
  subnet_id              = var.graylog_subnets[0]
  security_groups        = var.graylog_service_security_groups
  ebs_optimized          = false
  associate_public_ip_address = true

  root_block_device {
   delete_on_termination = true
   volume_size           = 80
   volume_type           = "gp2"
  }

  ebs_block_device {
   device_name           = "/dev/sda1"
   delete_on_termination = true
   volume_size           = 80
   volume_type           = "gp2"
  }
  
  tags = {
   Name        = var.name
  }
}
