/* WWW Load balancer */
resource "aws_elb" "demoWWWLb" {

  name = "demoWWWLb"

  subnets = [
    "${aws_subnet.demoPubSN0.id}"]

  security_groups = [
    "${aws_security_group.demoPubSG.id}",
    "${aws_security_group.demoLBSG.id}"]

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
    "${aws_security_group.demoLBSG.id}"]

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
