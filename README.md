# DevOps Project 1

This project demonstrates an end-to-end deployment of a containerized application using Terraform, GitHub Actions, Ansible, and Kubernetes.

## Project Structure

- **.github/workflows**: Contains GitHub Actions workflows for CI/CD, infrastructure provisioning, and configuration management.
- **ansible**: Contains Ansible playbooks and roles for configuring Kubernetes nodes.
- **k8s**: Contains Kubernetes deployment and service configurations.
- **terraform**: Contains Terraform configuration for provisioning AWS infrastructure.
- **app**: Contains the application code and Dockerfile.

## Prerequisites

- AWS account with IAM permissions
- GitHub repository with appropriate secrets set up
- Docker Hub account
- Node.js and npm

## Setup

1. **Provision Infrastructure**:
   - Ensure Terraform is installed.
   - Navigate to the `terraform` directory and run:
     ```sh
     terraform init
     terraform apply
     ```

2. **Configure Kubernetes**:
   - Ensure Ansible is installed.
   - Run the Ansible playbook from the root directory:
     ```sh
     ansible-playbook -i ansible/inventories/hosts ansible/playbook.yml
     ```

3. **Deploy Application**:
   - GitHub Actions will automatically build, push the Docker image, and deploy the application to Kubernetes on every push to the `main` branch.

## Usage

- Access the deployed application via the service URL provided by your cloud provider.

## Clean Up

- To destroy the infrastructure, run:
  ```sh
  terraform destroy
