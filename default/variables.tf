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
  description = "availability zone used for the demo, based on region"
  default = {
    us-east-1 = "us-east-1b"
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
  description = "optimized ECS AMIs"
  default = {
    us-east-1 = "ami-3d55272a"
    us-west-1 = "ami-444d0224"
    us-west-2 = "ami-1ccd1f7c"
    eu-west-1 = "ami-b6760fc5"
    eu-central-1 = "ami-f562909a"
    ap-northeast-1 = "ami-096cba68"
    ap-southeast-1 = "ami-7934ee1a"
    ap-southeast-2 = "ami-22a49541"
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
