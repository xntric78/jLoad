#!/bin/bash
cat <<EOF >> /etc/profile

export Client="${Client}"
export TestName="${TestName}"
export HostID="${HostID}"
export HostCount="${HostCount}"
EOF

cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
