# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "availability_zone" {
  description = "availability zone used for the demo"
  default = {
    us-east-1 = "us-east-1a"
    us-west-1 = "us-west-1a"
    us-west-2 = "us-west-2a"
    eu-west-1 = "eu-west-1a"
    eu-central-1 = "eu-central-1a"
    ap-northeast-1 = "ap-northeast-1a"
    ap-southeast-1 = "ap-southeast-1a"
    ap-southeast-2 = "ap-southeast-2a"
  }
}

# AMIs optimized for use with ECS Container Service
# Note: changes occur regularly to the list of recommended AMIs.  Verify at
# http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
variable "ecsAmi" {
  description = "default ECS AMI for us-east-1"
  default = {
    us-east-1 = "ami-cb2305a1"
    us-west-1 = "ami-bdafdbdd"
    us-west-2 = "ami-ec75908c"
    eu-west-1 = "ami-13f84d60"
    eu-central-1 = "ami-c3253caf"
    ap-northeast-1 = "ami-e9724c87"
    ap-southeast-1 = "ami-5f31fd3c"
    ap-southeast-2 = "ami-83af8ae0"
  }
}

# this is a keyName for key pairs
variable "aws_key_name" {
  description = "Key Pair Name used to login to the box"
  default = "demo-key"
}

# this is a PEM key for key pairs
variable "aws_key_filename" {
  description = "Key Pair FileName used to login to the box"
  default = "demo-key.pem"
}

variable "cluster_name" {
  description = "cluster name to register instances to"
  default = "default"
}

# all variables related to VPC
variable "vpc_name" {
  description = "VPC for the cluster system"
  default = "demoVPC"
}

variable "networkCIDR" {
  description = "Uber IP addressing for the Network"
  default = "200.0.0.0/16"
}

variable "public0-0CIDR" {
  description = "Public 0.0 CIDR for externally accesible subnet"
  default = "200.0.0.0/24"
}

variable "dockerAuthType" {
  description = "type of authentication for ECS pull"
  default = "dockercfg"
}

variable "dockerAuthData" {
  description = "actual Auth to use to login"
  default = "enter Key Here"
}
