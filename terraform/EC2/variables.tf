variable "ami_id" {
  default     = "ami-08bac620dc84221eb"
  description = "AMI ID for EC2 instances"
}

variable "instance_size" {
  default     = "t2.micro"
  description = "Instance type for EC2 instances"
}

variable "ssh_key" {
  default = ""
  description = "Name of thhe key pair to be used for SSH"
}

variable "name" {
  default = ""
}

variable "security_group_ids" {
  default = []
  type = list
}

variable "subnet_id" {
  default = ""
}
