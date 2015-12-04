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

  ami = "${var.ecsAmi}"
  availability_zone = "${var.availability_zone}"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.demoPubSN0-0.id}"
  iam_instance_profile = "${aws_iam_instance_profile.demoECSInstProf.name}"
  associate_public_ip_address = true
  source_dest_check = false

  security_groups = [
    "${aws_security_group.demoInstSG.id}"]

  /*
  # add \ to cp so that it will overwrite the alias in .bashrc
  provisioner "local-exec" {
    command = "\\cp ecs.config tmpEcs${count.index}.config"
  }

  provisioner "local-exec" {
    command = "sed -i '' 's/##KEY##/${var.dockerAuthData}/' tmpEcs${count.index}.config"
  }

  provisioner "local-exec" {
    command = "echo ECS_CLUSTER=${aws_ecs_cluster.demoCL.name} >> tmpEcs${count.index}.config"
  }

  provisioner "file" {
    source = "tmpEcs${count.index}.config"
    destination = "ecs.config"

    connection {
      type = "ssh"
      user = "ec2-user"
      key_file = "${var.aws_key_filename}"
      agent = true
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp ecs.config /etc/ecs/ecs.config"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      key_file = "${var.aws_key_filename}"
      agent = true
    }
  }
*/

  tags = {
    Name = "demoECSIns${count.index}"
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

//# WWW Load balancer
//resource "aws_elb" "demoWWWLb" {
//
//  name = "demoWWWLb"
//  subnets = [
//    "${aws_subnet.demoPubSN0-0.id}"]
//  security_groups = [
//    "${aws_security_group.demoWebSG.id}"]
//
//  listener {
//    instance_port = 80
//    instance_protocol = "http"
//    lb_port = 80
//    lb_protocol = "http"
//  }
//
//  health_check {
//    healthy_threshold = 2
//    unhealthy_threshold = 2
//    timeout = 3
//    target = "HTTP:80/"
//    interval = 5
//  }
//}
//
//# API Load balancer
//resource "aws_elb" "demoAAPILb" {
//
//  name = "demoAAPILb"
//  subnets = [
//    "${aws_subnet.demoPubSN0-0.id}"]
//  security_groups = [
//    "${aws_security_group.demoWebSG.id}"]
//
//  listener {
//    instance_port = 80
//    instance_protocol = "http"
//    lb_port = 80
//    lb_protocol = "http"
//  }
//
//  health_check {
//    healthy_threshold = 2
//    unhealthy_threshold = 2
//    timeout = 3
//    target = "HTTP:80/"
//    interval = 5
//  }
//}
