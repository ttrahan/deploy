resource "aws_ecs_cluster" "demoCL" {
  name = "demoCL"
}

/* App servers */
resource "aws_instance" "demo" {
  count = 2
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.demoPubSN0.id}"
  security_groups = [
    "${aws_security_group.demoPubSG.id}"]
  key_name = "${var.key_name}"
  user_data = "#!/bin/bash \n echo ECS_CLUSTER=${aws_ecs_cluster.demoCL.name} >> /etc/ecs/ecs.config"
  iam_instance_profile = "${aws_iam_instance_profile.demoECSInstProf.name}"
  tags = {
    Name = "demoECSIns${count.index}"
  }
}

/* WWW Load balancer */
resource "aws_elb" "demoWWWLb" {

  name = "demoWWWLb"

  subnets = [
    "${aws_subnet.demoPubSN0.id}"]

  security_groups = [
    "${aws_security_group.demoPubSG.id}",
    "${aws_security_group.demoWebSG.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }

  instances = [
    "${aws_instance.demo.*.id}"]
}

/* API Load balancer */
resource "aws_elb" "demoAAPILb" {

  name = "demoAAPILb"

  subnets = [
    "${aws_subnet.demoPubSN0.id}"]

  security_groups = [
    "${aws_security_group.demoPubSG.id}",
    "${aws_security_group.demoWebSG.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }

  instances = [
    "${aws_instance.demo.*.id}"]
}
