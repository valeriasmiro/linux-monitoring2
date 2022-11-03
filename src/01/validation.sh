#!/bin/bash


function validate {
    error=0
    if ! [ -d $path ]; then 
        echo "Directory doesn't exist"
        error=1
    fi

    re='^[0-9]+$'
    if [[ ! $folders_num =~ $re ]]; then
        echo "Incorrect number of folders"
        error=1
    fi

    if [[ ! $files_num =~ $re ]]; then
        echo "Incorrect number of files"
        error=1
    fi

    re='^[a-z]{1,7}$'
    if [[ ! $folder_pattern =~ $re ]]; then
        echo "Incorrect pattent for folders name"
        error=1
    fi

    re='^[a-z]{1,7}\.[a-z]{1,3}$'
    if [[ ! $file_pattern =~ $re ]]; then
        echo "Incorrect pattern for files name"
        error=1
    fi

    file_size=${file_size::-2}

    if [[ $file_size > 100 ]]; then
        echo "Enter file size in kb but less than 100 kb"
        error=1
    fi

    return $error
}
