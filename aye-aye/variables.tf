//this main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secert access key"
}

variable "region"     {
  description = "AWS region"
  default     = "us-east-1"
}

variable "availability_zone"     {
  description = "availability zone used for the demo"
  default     = "us-east-1d"
}

/* Ubuntu 14.04 amis by region */
variable "amis" {
  description = "Base AMI to launch the instances with"
  default = {
    us-east-1 = "ami-c16422a4"
  }
}

variable "key_name" {
  description = "Key Pair Name used to login to the box"
  default = "demo-key" //this is a PEM key for key pairs
}


// all variables related to VPC
variable "vpc_name" {
  description = "VPC for the cluster system"
  default     = "demoVPC"
}

variable "vpc_cidr_block" {
  description = "Uber IP addressing block for the VPC"
  default     = "108.108.0.0/16"
}

variable "public_subnet_cidr_block_0" {
  description = "Public .0 block for externally accesible subnet"
  default     = "108.108.0.0/24"
}

variable "private_subnet_cidr_block_10" {
  description = "Private .10 block for container instances"
  default     = "10.128.10.0/24"
}

