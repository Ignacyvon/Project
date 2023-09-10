provider "aws" {
  region = "" # Change this to your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "" # Change this to your desired AMI ID
  instance_type = ""            # Change this to your desired instance type
  key_name      = ""  # Change this to your EC2 key pair name

  user_data = <<-EOF
              #!/bin/bash
              # Update the system
              sudo yum update -y

              # Install Docker
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -aG docker ec2-user

              # Install Kubernetes components
              sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              sudo chmod +x kubectl
              sudo mv kubectl /usr/local/bin/

              # Disable SELinux (required for Kubernetes)
              sudo setenforce 0
              sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

              # Enable and start Docker and Kubernetes services
              sudo systemctl enable docker
              sudo systemctl enable kubelet
              sudo systemctl start docker
              sudo systemctl start kubelet
              EOF

  tags = {
    Name = "Albertina"
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
#terraform init
#terraform apply
#terraform destroy