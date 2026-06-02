variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "tf-ansible-jenkins"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type_jenkins" {
  description = "The instance type for the Jenkins server"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_app" {
  description = "The instance type for the application server"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI for us-east-1. "
  type        = string
  default     = "ami-0261755bbcb8c4a84"
}

variable "key_pair_name" {
  description = "The name of the key pair to use for the servers"
  type        = string
  default     = "tf-ansible-jenkins-key"
}

variable "my_ip" {
  description = "SSH access CIDR - open to all during development"
  type        = string
  default     = "0.0.0.0/0"
}
