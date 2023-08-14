#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status.

user=`id -u`
group=`id -g`

docker run -i -v $PWD:$PWD -w $PWD -u $user:$group hashicorp/terraform:1.5 fmt -recursive
