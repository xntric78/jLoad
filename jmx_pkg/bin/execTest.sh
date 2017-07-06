#!/bin/bash
#
export JVM_ARGS="-Xms2G -Xmx3G"
cd /home/ec2-user
/opt/jmeter/bin/jmeter -n -t dev_package.jmx -l results/dev_package.jtl -j logs/dev_package.log > logs/jmeter.log

/home/ec2-user/bin/wrapUp.sh
