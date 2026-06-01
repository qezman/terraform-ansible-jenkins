output "jenkins_public_ip" {
  description = "Public IP of the Jenkins serverE"
  value       = aws_instance.jenkins.public_ip
}

output "app_public_ip" {
  description = "Public IP of the app server"
  value       = aws_instance.app.public_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}
