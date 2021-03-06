output "public_ip" {
  value = "${aws_instance.jmeter-master-instance.*.public_ip}"
}

output "ssh_cmd" {
  value = "${formatlist("ssh ec2-user@%s", aws_instance.jmeter-master-instance.*.public_ip)}"
}

output "ssm_send_cmd_json" {
  value = "${data.template_file.ssm_doc_run.rendered}"
}
