resource "aws_instance" "automation_server" {
    ami = "ami-04581fbf744a7d11f"
    count = "1"
    instance_type = "t2.micro"
    vpc_security_group_ids   =   [aws_security_group.sgroup.id]

    provisioner "remote-exec" {
           inline   =   [
               "sudo yum update -y",
               "sudo amazon-linux-extras install java-openjdk11 -y",
               "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
               "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
               "sudo yum install jenkins -y",
               "sudo systemctl start jenkins",
               "sudo yum update -y ",
               "sudo amazon-linux-extras install ansible2 -y",
               "sudo amazon-linux-extras install python3.8 -y",
           ] 
    }

    connection {
        type    =   "ssh"
        host    =   self.public_ip
        user    =   "ec2-user"
        private_key = "${file("/Users/sravankumar/.ssh/terrakey.pem")}"
    }

    tags = {
        name    =   "Automation_Server"
    }
}
# Creating a security group.
resource "aws_security_group" "sgroup" {
    name        =   "sgroup"
    description =   "Allow inbound traffic"
    
    ingress {
        from_port   =   22
        to_port     =   22
        protocol    =   "tcp"
        cidr_blocks =   ["0.0.0.0/0"]
    }
    
    ingress {
        from_port   =   0
        to_port     =   0
        protocol    =   "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }
    
    egress  {
        from_port   =   0
        to_port     =   0
        protocol    =   "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }
    
    tags = {
        name    = "Simplilearn Project 2"
        owner   = "Sravan Kumar"
    }
}