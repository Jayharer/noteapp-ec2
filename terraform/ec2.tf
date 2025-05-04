# # create ec2 instance 
# resource "aws_instance" "first-instance" {
#   ami                         = "ami-0f88e80871fd81e91"
#   instance_type               = "t2.micro"
#   key_name                    = aws_key_pair.ec2-key-pair.key_name
#   vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
#   iam_instance_profile        = aws_iam_instance_profile.ec2-instance-profile.name
#   subnet_id                   = aws_subnet.public_subet_a.id
#   associate_public_ip_address = true
#   user_data                   = file("install.sh")
#   root_block_device {
#     delete_on_termination = true
#     volume_size           = 16
#     volume_type           = "gp2"
#   }

#   tags = {
#     Name = "first-instance"
#   }

#   depends_on = [aws_iam_role.ec2-role]
# }
