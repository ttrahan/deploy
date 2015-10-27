/* App servers */
resource "aws_instance" "app" {
  count = 2
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.shippable_aye_aye_pub_sn.id}"
  security_groups = ["${aws_security_group.shippable_aye_aye_sg.id}"]
  key_name = "${var.key_name}"
  source_dest_check = false
  user_data = "#!/bin/bash \n echo ECS_CLUSTER=${aws_ecs_cluster.shippable_aye_aye_cluster.name} >> /etc/ecs/ecs.config"
  iam_instance_profile = "${aws_iam_instance_profile.shippable_aye_aye_ecs_ip.name}"
  tags = {
    Name = "rag-terra-instance-${count.index}"
  }
}
