# create key pair 
resource "aws_key_pair" "ec2-key-pair" {
  key_name   = var.ssh_key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQOOOgbQ6R8bA/nEfthG5oUH6qyj+jdXI1003okjHgmD/L9uWvPp5DDg+t3cqLNL5tAVoGBXInJpblbGivgnhjxFqHvALOvMLEip4wOZ6FhiEScU2y3tAlBaWWiUxsMwqs5H9yK2fbcwXhs3cHcJo6ohghlT7CKB/sVqHk+JAG296RCW8F7Hh7o8XfOg0CzoL2kTsFVnU6bi4WpSbIiF1jmgfjHpbLczVsmAXj+7EXfPsI7DFc5HoGc3OwgZpkvoTpSU0hTJ3k67SDEasZUuvXcmn2/giJ+bPKm96LwbUFH4JW1NBififCkccPsRrirHEYads1EIun8sxhJ5FVhl8R smart@DESKTOP-3E1QE7F"
}

# ec2 iam role
resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2-instance-profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2-role.name
}

# ec2 iam role policy
resource "aws_iam_role_policy" "ec2-role-policy" {
  name = "ec2-role-policy"
  role = aws_iam_role.ec2-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

}

# create ec2 instance 
resource "aws_instance" "first-instance" {
  ami                         = "ami-0f88e80871fd81e91"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ec2-key-pair.key_name
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2-instance-profile.name
  subnet_id                   = aws_subnet.public_subet_a.id
  associate_public_ip_address = true
  user_data                   = file("install.sh")

  root_block_device {
    delete_on_termination = true
    volume_size           = 16
    volume_type           = "gp2"
  }

  tags = {
    Name = "first-instance"
  }

  depends_on = [aws_iam_role.ec2-role]
}
