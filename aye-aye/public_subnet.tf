/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "shippable_aye_aye_ig" {
  vpc_id = "${aws_vpc.default.id}"
  tags { 
    Name = "shippable_aye_aye_ig" 
  }
}

/* Public subnet */
resource "aws_subnet" "shippable_aye_aye_pub_sn" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "${var.availability_zone}"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.shippable_aye_aye_ig"]
  tags { 
    Name = "shippable_aye_aye_pub_sn" 
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "shippable_aye_aye_rt" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.shippable_aye_aye_ig.id}"
  }
  tags { 
    Name = "shippable_aye_aye_rt" 
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.shippable_aye_aye_pub_sn.id}"
  route_table_id = "${aws_route_table.shippable_aye_aye_rt.id}"
}
