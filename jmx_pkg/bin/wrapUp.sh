#!/bin/bash
TODAY=$(date +"%Y-%m-%d_%H%M")
HOST=$(hostname)

cd /home/ec2-user
aws s3 sync . "s3://jload/results/$Client/$TestName/$TODAY/$HOST"
