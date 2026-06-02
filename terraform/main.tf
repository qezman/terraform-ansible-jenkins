# Networking
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true # every EC2 in this subnet gets a public IP automatically
  tags = {
    Name    = "${var.project_name}-public-subnet"
    Project = var.project_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name    = "${var.project_name}-public-route-table"
    Project = var.project_name
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

# Security Groups
# Security group for the Jenkins server
resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Allow SSH access from my IP & HTTP on 8080 from anywhere"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound - allow all outgoing traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-jenkins-sg"
    Project = var.project_name
  }
}

# Security group for the app server
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Allow SSH access from my IP & HTTP on port 80"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP for the app"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound - allow all
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-jenkins-sg"
    Project = var.project_name
  }
}

# Key Pair
resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = file("C:/Users/USER/.ssh/id_ed25519.pub")
}

# EC2 Instances
resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_jenkins
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.jenkins.id]

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name    = "${var.project_name}-jenkins"
    Project = var.project_name
    Role    = "Jenkins"
  }
}

# App server
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_jenkins
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.app.id]

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name    = "${var.project_name}-app"
    Project = var.project_name
    Role    = "app"
  }
}
