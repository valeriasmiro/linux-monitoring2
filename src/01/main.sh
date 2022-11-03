#!/bin/bash

source validation.sh
source script.sh

par=$#
path=$1
folders_num=$2
folder_pattern=$3
files_num=$4
file_pattern=$5
file_size=$6
error=0

if [[ $# -eq 6 ]]; then
    validate
    if [[ $error -eq 0 ]]; then
        generate_folders_name
        file_name_generation
        file_generation
    fi
else
    echo "Incorrect number of parametrs. Sorry( Try again"
fi
