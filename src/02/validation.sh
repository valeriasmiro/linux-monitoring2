#!/bin/bash


function validate() {
    error=0
    re='^[a-z]{1,7}$'
    if [[ ! $folders_pattern =~ $re ]]; then
        echo "Incorrect pattent for folders name"
        error=1
    fi

    re='^[a-z]{1,7}\.[a-z]{1,3}$'
    if [[ ! $files_pattern =~ $re ]]; then
        echo "Incorrect pattern for files name"
        error=1
    fi
    re='^[0-9]{1,2}Mb$'
    if [[ ! $file_size =~ $re ]]; then
        echo "Enter file size in kb but less than 100 Mb"
        error=1
    else
        file_size=${file_size::-2}
    fi

    return $error
}
