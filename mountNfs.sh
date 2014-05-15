#!/bin/bash

if [ ! -d "workdir" ]; then
	mkdir workdir
fi
sudo mount -orw -oresvport  -t nfs 192.168.66.60:/home/sites workdir