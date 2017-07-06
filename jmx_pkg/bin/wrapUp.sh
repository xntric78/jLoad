#!/bin/bash
TODAY=$(date +"%Y-%m-%d_%H%M")

aws s3 sync . s3://jload/results/$Client/$Test/$TODAY/$HostID_$HostCount
