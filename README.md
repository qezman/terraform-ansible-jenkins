# Automated Infrastructure Provisioning
### Terraform + Ansible + Jenkins on AWS

## What this project does
- **Terraform** provisions AWS infrastructure (VPC, EC2, security groups)
- **Ansible** configures the servers (installs Docker, deploys the app)
- **Jenkins** orchestrates the pipeline (triggers Terraform + Ansible on code push)

<!-- ## Repo structure
terraform/        # All infrastructure-as-code lives here
ansible/          # Playbooks and roles for server configuration
ansible/roles/    # Reusable Ansible roles (docker, app)
ansible/group_vars/ # Variables scoped to host groups
jenkins/          # Jenkinsfile defining the CI/CD pipeline
app/              # The containerised application -->
