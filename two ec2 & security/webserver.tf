provider "aws" {
  #access_key = ""
  #secret_key = ""
  region     = "eu-central-1"
}

resource "aws_instance" "geniusee_ubuntu" {
  #count         = 1
  ami                    = "ami-089b5384aac360007"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.genesis_webserver.id]
  subnet_id              = "subnet-725c1318"
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>Hello, Welcome To Yurii Krynytskiy Webpage</h1></html>" > index.html
EOF
  #myip=`curl httpd://169.254.169.254/latest/meta-data/local-ipv4`
  #echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" >/var/www/html/index.html
  #sudo service httpd start
  #chkconfig httpd on
  tags = {
    Name    = "AmazonLinux"
    Owner   = "Yurii Krynytskiy"
    Project = "Geniusee"
  }
}
resource "aws_instance" "geniusee_ubuntu_two" {
  #count         = 1
  ami                    = "ami-089b5384aac360007"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.genesis_webserver.id]
  subnet_id              = "subnet-c175fc8d"
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>Hello, Welcome To Yurii Krynytskiy Webpage</h1></html>" > index.html
EOF
  #myip=`curl httpd://169.254.169.254/latest/meta-data/local-ipv4`
  #echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" >/var/www/html/index.html
  #sudo service httpd start
  #chkconfig httpd on
  tags = {
    Name    = "AmazonLinux"
    Owner   = "Yurii Krynytskiy"
    Project = "Geniusee"
  }
}

resource "aws_security_group" "geniusee_webserver" {
  name        = "Apache Webserver Security Group"
  description = "Open port 80, all inbound traffic"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description = "tcp(80)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "ssh(22)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "https(443)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "WebServerSecurityGroup"
  }
}
resource "aws_lb" "geniusee_lb" {
  name               = "geniusee_lb"
  load_balancer_type = "network" #network/application
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.genesis_webserver.id]
}
