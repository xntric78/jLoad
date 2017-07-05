#!/bin/bash
#
export JVM_ARGS="-Xms2G -Xmx4G"
jmeter -n -t dev_package.jmx -l results/dev_package.jtl -j logs/dev_package.log
