#!/bin/bash

source validation.sh
source script.sh

folders_pattern=$1
files_pattern=$2
file_size=$3
error=0

if [[ $# -eq 3 ]]; then
    validate
    if [[ $error -eq 0 ]]; then
        main_func
    fi
else
    echo "Incorrect number of parametrs. Sorry( Try again"
fi
