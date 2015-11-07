//========================== VPC  =============================

/* Define a vpc */
resource "aws_vpc" "demoVPC" {
  cidr_block = "${var.vpc_cidr_block}"
  //enable_dns_hostnames = true
  tags {
    Name = "${var.vpc_name}"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "demoIG" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  tags {
    Name = "demoIG"
  }
}

//========================== .0 Subnet =============================

/* Public subnet */
resource "aws_subnet" "demoPubSN0" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  cidr_block = "${var.public_subnet_cidr_block_0}"
  availability_zone = "${var.availability_zone}"
  map_public_ip_on_launch = true
  tags {
    Name = "demoPubSN0"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "demoPubSN0RT" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demoIG.id}"
  }
  tags {
    Name = "demoPubSN0RT"
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "demoPubSN0RTAssn" {
  subnet_id = "${aws_subnet.demoPubSN0.id}"
  route_table_id = "${aws_route_table.demoPubSN0RT.id}"
}

/* Public SubNet security group */
resource "aws_security_group" "demoPubSG" {
  name = "demoPubSG"
  description = "Public Subnet security group"
  vpc_id = "${aws_vpc.demoVPC.id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "${var.vpc_cidr_block}"]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "demoPubSG"
  }
}

/* Load Balancer Security group */
resource "aws_security_group" "demoWebSG" {
  name = "demoWebSG"
  description = "Load Balancer security group"
  vpc_id = "${aws_vpc.demoVPC.id}"

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "demoWebSG"
  }
}

//========================== NAT =============================

/* NAT Server */
resource "aws_instance" "demoNAT" {
  count = 1
  ami = "ami-4f9fee26"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.demoPubSN0.id}"
  security_groups = [
    "${aws_security_group.demoWebSG.id}"]
  key_name = "${var.key_name}"
  tags = {
    Name = "demoNAT${count.index}"
  }
}

//========================== .10 subnet ======================

/* Private 10 subnet */
resource "aws_subnet" "demoPrivSN10" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  cidr_block = "${var.private_subnet_cidr_block_10}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "demoPrivSN10"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "demoPrivSN10RT" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_instance.demoNAT.id}"
  }
  tags {
    Name = "demoPrivSN10RT"
  }
}

/* Associate the routing table to private subnet */
resource "aws_route_table_association" "demoPubSN0RTAssn" {
  subnet_id = "${aws_subnet.demoPrivSN10.id}"
  route_table_id = "${aws_route_table.demoPrivSN10RT.id}"
}
