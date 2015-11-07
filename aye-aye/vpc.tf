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

/* Public subnet */
resource "aws_subnet" "demoPubSN0" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  cidr_block = "${var.public_subnet_cidr_block_0}"
  availability_zone = "${var.availability_zone}"
  map_public_ip_on_launch = true
  tags {
    Name = "shippable_aye_aye_pub_sn"
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


/* Default security group */
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
      "${var.public_subnet_cidr_block_0}"]
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

/* Security group for the web */
resource "aws_security_group" "demoLBSG" {
  name = "demoLBSG"
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
    Name = "demoLBSG"
  }
}

