#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 [<directory>]"
    exit 1
fi

for dir in "$@"; do
    if [ ! -d "$dir" ]; then
        echo "$dir is not a directory"
        continue
    fi

    echo "Counting files in $dir:"
    find "$dir" -type f | wc -l
done
