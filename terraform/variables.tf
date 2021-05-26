variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}

variable "jenkinsVM_instance_size" {
  default     = "t2.large"
  description = "Instance type for jenkinsVM EC2 instance"
}

variable "rds_username" {
  default = ""
}

variable "rds_password" {
  default   = ""
  sensitive = true
}
