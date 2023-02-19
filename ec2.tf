data "aws_ami" "my_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_key_pair" "deployer" {
  key_name  = "deployer-key"
  public_key ="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2hzdW5y3tj7XX2CTrl+BQWqhzzO1BXwjU1WRtia3PM+w/neLL7mxfDT0C1r2J6axKpaASe6FmkPGKyKP0nSKTc1BRADmjQ3R27Ef4kEooPdUr1ONt+Aqw1kcw9k3b+iCwMC9mMivRlS8EKZvi/e09y+TdYxBwlRsHYh8NKR+r7+I0dI1qErbBG49rFmlz6GIeK/lCecdrwkAjKPXPdiKX2PV64dIhldceFacENld9JYcHWJ4/3Y4lFToT3TFtFvLRx2aW2L9gGnB+XhTbA6GezzmUdCuqzFAYTJC9mIxerbGSQuK9GO53t2RYzFfItGKYrGTJfb0uJeu873ItDR39sQbfHWu+Dg8uzUeb4a4v7ME8WBI6qF5am37HVmbJKQLc3lED23hC+A7Y6wT9FnqvlLvVolJBxN8VkqfdPmk797lloTUw3rhYsbZq3wZ4a7iToXkURdtXLoOiUb2d02jycf2MhAW/I07O646HuIDhrucQo3/6eqgA90tYp9vrUdE= ubuntu@ip-172-31-178-254"
}
resource "aws_instance" "my_ins" {
  ami = data.aws_ami.my_ubuntu.id
  instance_type = "t2.nano"
  key_name = aws_key_pair.deployer.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow.id]
  subnet_id                   = aws_subnet.public1.id

}

output "EC2" {
 value =aws_instance.my_ins.public_ip
}
