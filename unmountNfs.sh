#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/workdir"

if mount | grep $dir > /dev/null; then
    echo "Unmounting: $dir"
	sudo umount $dir
else
    echo "$dir not mounted."
fi
