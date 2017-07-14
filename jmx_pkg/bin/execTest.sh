#!/bin/bash
set -e

public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

exec_test() {
    export JVM_ARGS="-Xms2G -Xmx3G"

    cd /home/ec2-user
    /opt/jmeter/bin/jmeter -n -t dev_package.jmx -l results/dev_package.jtl -j logs/dev_package.log
}

exec_wrap_up() {
    cd /home/ec2-user
    aws s3 sync /home/ec2-user "s3://jload/results/$Client/$TestName/$TEST_ID/$HOST"
}

capture_identity_doc() {
    curl 'http://169.254.169.254/latest/dynamic/instance-identity/document' | jq ".public_ipv4 = \"$public_ip\"" > /home/ec2-user/logs/identity_doc.json

}

[[ ! -z "$TEST_ID" ]] || export TEST_ID=$(date +"%Y%m%d_%H%M")
HOST=$(hostname)

source /home/ec2-user/bin/test_vars.sh
exec_test
exec_wrap_up
