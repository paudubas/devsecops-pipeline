resource "aws_s3_bucket" "devsecops_bucket" {
  bucket = "devsecops-pipeline-demo"
  acl    = "private"
}

resource "aws_instance" "flask_app" {
  ami           = "ami-12345678"  # Replace with the latest Amazon Linux AMI
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable python3.8
              yum install -y python3 pip
              pip3 install flask
              echo "from flask import Flask
              app = Flask(__name__)
              @app.route('/')
              def home():
                  return '<h1>Welcome to the DevSecOps Secure App</h1>'
              app.run(host='0.0.0.0', port=80, debug=True)" > /home/ec2-user/app.py
              python3 /home/ec2-user/app.py
              EOF

  tags = {
    Name = "DevSecOps-FlaskApp"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
