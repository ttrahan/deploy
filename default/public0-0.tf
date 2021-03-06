# ========================ECS Instances=======================
# ECS Instance Security group
resource "aws_security_group" "demoInstSG" {
  name = "demoInstSG"
  description = "ECS instance security group"
  vpc_id = "${aws_vpc.demoVPC.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [
      "${var.public0-0CIDR}"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "demoInstSG"
  }
}

# Container instances for ECS
resource "aws_instance" "demoECSIns" {
  count = 2

  # ami = "${var.ecsAmi}"
  ami = "${lookup(var.ecsAmi, var.region)}"
  availability_zone = "${lookup(var.availability_zone, var.region)}"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.demoPubSN0-0.id}"
  iam_instance_profile = "${aws_iam_instance_profile.demoECSInstProf.name}"
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "#!/bin/bash \n echo ECS_CLUSTER=demo-shippable-ecs >> /etc/ecs/ecs.config"

  security_groups = [
    "${aws_security_group.demoInstSG.id}"]

  tags = {
    Name = "demoECSIns${count.index}"
  }
}

# Container instances for ECS
resource "aws_instance" "demoECSIns-test" {
  count = 2

  # ami = "${var.ecsAmi}"
  ami = "${lookup(var.ecsAmi, var.region)}"
  availability_zone = "${lookup(var.availability_zone, var.region)}"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.demoPubSN0-0.id}"
  iam_instance_profile = "${aws_iam_instance_profile.demoECSInstProf.name}"
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "#!/bin/bash \n echo ECS_CLUSTER=demo-shippable-ecs-test >> /etc/ecs/ecs.config"

  security_groups = [
    "${aws_security_group.demoInstSG.id}"]

  tags = {
    Name = "demoECSIns-test${count.index}"
  }
}

# ========================Load Balancers=======================
# Web Security group
resource "aws_security_group" "demoWebSG" {
  name = "demoWebSG"
  description = "Web traffic security group"
  vpc_id = "${aws_vpc.demoVPC.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "${var.public0-0CIDR}"]
  }
  tags {
    Name = "demoWebSG"
  }
}

# WWW Load balancer
resource "aws_elb" "demoWWWLb" {

  name = "demoWWWLb"
  subnets = [
    "${aws_subnet.demoPubSN0-0.id}"]
  security_groups = [
    "${aws_security_group.demoWebSG.id}"]

  listener {
    instance_port = 50000
    instance_protocol = "http"
    lb_port = 50000
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }
}

# API Load balancer
resource "aws_elb" "demoAPILb" {

  name = "demoAPILb"
  subnets = [
    "${aws_subnet.demoPubSN0-0.id}"]
  security_groups = [
    "${aws_security_group.demoWebSG.id}"]

  #run time a lot of things change here. So ignore
//  lifecycle {
//    ignore_changes = [
//      "listener",
//      "instances",
//      "health_check"
//    ]
//  }

  listener {
    instance_port = 50000
    instance_protocol = "http"
    lb_port = 50000
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }
}

# WWW Load balancer
resource "aws_elb" "demoWWWLb-test" {

  name = "demoWWWLb-test"
  subnets = [
    "${aws_subnet.demoPubSN0-0.id}"]
  security_groups = [
    "${aws_security_group.demoWebSG.id}"]

  listener {
    instance_port = 50000
    instance_protocol = "http"
    lb_port = 50000
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }
}

# API-Test Load balancer
resource "aws_elb" "demoAPILb-test" {

  name = "demoAPILb-test"
  subnets = [
    "${aws_subnet.demoPubSN0-0.id}"]
  security_groups = [
    "${aws_security_group.demoWebSG.id}"]

  #run time a lot of things change here. So ignore
//  lifecycle {
//    ignore_changes = [
//      "listener",
//      "instances",
//      "health_check"
//    ]
//  }

  listener {
    instance_port = 50000
    instance_protocol = "http"
    lb_port = 50000
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }
}

/*# DV Load balancer
resource "aws_elb" "demoDVLb" {

  name = "demoDVLb"
  subnets = [
    "${aws_subnet.demoPubSN0-0.id}"]
  security_groups = [
    "${aws_security_group.demoWebSG.id}"]

  #run time a lot of things change here. So ignore
//  lifecycle {
//    ignore_changes = [
//      "listener",
//      "instances",
//      "health_check"
//    ]
//  }

  listener {
    instance_port = 50000
    instance_protocol = "http"
    lb_port = 50000
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }
}

# DV Load balancer
resource "aws_elb" "demoBOXLb" {

  name = "demoBOXLb"
  subnets = [
    "${aws_subnet.demoPubSN0-0.id}"]
  security_groups = [
    "${aws_security_group.demoWebSG.id}"]

  #run time a lot of things change here. So ignore
//  lifecycle {
//    ignore_changes = [
//      "listener",
//      "instances",
//      "health_check"
//    ]
//  }

  listener {
    instance_port = 50000
    instance_protocol = "http"
    lb_port = 50000
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }
}*/
