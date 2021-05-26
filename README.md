# help-queue-devops

all DevOps related code for Help Queue Application

Full Deployment Demo Steps:

(from setupVM)

```bash
# Deploy terraform
cd terraform
terraform init
terraform apply -var-file secrets.tfvars

# Wait for JenkinsVM EC2 instance to get created
cd -

# Run ansible to configure JenkinsVM
cd ansible

# Update inventory with the JenkinsVM new IP
vim inventory

# Run Ansible Playbook
ansible-playbook -i inventory playbook.yaml

# Take the initial Jenkins Admin Password and configure Jenkins
# 1) Setup Admin Account
# 2) Install nodeJS Plugin & Docker Pipeline Plugin
# 3) Install node14.1.0 manually
# 4) Add git Credentials
# 5) Add Docker Credentials
# 6) Restart Jenkins
# 7) Setup frontendPipeline
#       - Configure webhook
# 8) Setup backendPipeline
#       - Configure webhook
# 9) Trigger builds to demonstrate the pipelines

# Run Kubernetes setup.sh script
cd ../kubernetes
./setup.sh -u <db_username> -p <db_password> -h <db_hostname> -n <eks_cluster_name>

# Run Postman collection to populate initial data
# Demo application

# Demo new deployment
# Trigger pipeline by webhook
# kubectl rollout restart deployment/

```
