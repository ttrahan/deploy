/* App servers */
resource "aws_instance" "demo" {
  count = 2
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.demoPubSN0.id}"
  security_groups = [
    "${aws_security_group.demoPubSG.id}"]
  key_name = "${var.key_name}"
  source_dest_check = false
  user_data = "#!/bin/bash \n echo ECS_CLUSTER=${aws_ecs_cluster.demoCL.name} >> /etc/ecs/ecs.config"
  iam_instance_profile = "${aws_iam_instance_profile.demoECSInstProf.name}"
  tags = {
    Name = "demo-${count.index}"
  }
}
