output "public_ip" {
  value = "${aws_instance.jmeter-master-instance.public_ip}"
}

output "ssh_cmd" {
  value = "ssh ec2-user@${aws_instance.jmeter-master-instance.public_ip}"
}
