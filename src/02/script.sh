#!/bin/bash

path="/home/student/second_task/"
declare -a files
declare -a folders
declare -a files_pattern_list
declare -a folders_pattern_list

function files_pattern_to_list() {
    for (( i=0; i < ${#files_name_pattern}; i++ ))
    do
        files_pattern_list[i]=${files_name_pattern:i:1}
    done
}

function folders_pattern_to_list() {
    for (( i=0; i < ${#folders_pattern}; i++ ))
    do
        folders_pattern_list[i]=${folders_pattern:i:1}
    done
}

function files_num_generation() {
    RANGE=100
    files_num=$RANDOM
    let "files_num %= $RANGE"
    return $files_num
}

#we generate 100 files name and put it to array
function files_names_generation() {
    #pointer and duplication parameters used for algoritm
    ptr=0
    dub=0

    for (( i = 0; i < 100; i++ ))
    do
        ptr=$((i%${#files_name_pattern}))
        dub=$((2+i/${#files_name_pattern}))
        name=""

        for (( j = 0; j < ${#files_name_pattern}; j++ ))
        do
            if [[ j -eq $ptr ]]; then
                dub=$(($dub-1))
            fi
            for (( k = 0; k < dub; k++ ))
            do
                name+=${files_pattern_list[j]}
            done
        done
        current_file_name=$name.$files_extention$(date +"_%d%m%y")
        files[i]=$current_file_name
    done
}

function folders_name_generation() {
    ptr=0
    dub=0
    folders_pattern_length=${#folders_pattern}

    for (( i = 0; i < 100; i++ ))
    do
        ptr=$((i%$folders_pattern_length))
        dub=$((2+i/$folders_pattern_length))
        name=""

        for (( j = 0; j < folders_pattern_length; j++ ))
        do
            if [[ j -eq $ptr ]]; then
            let "dub -= 1"
            fi
            for (( k = 0; k < dub; k++ ))
            do
                name+=${folders_pattern_list[j]}
            done
        done
        current_folder_name=$path$name$(date +"_%d%m%y/")
        folders[i]=$current_folder_name
    done
}

function main_func() {
    delimeter="."
    files_name_pattern=${files_pattern%$delimeter*}
    files_extention=${files_pattern##*$delimeter}
    echo $files_name_pattern

    files_pattern_to_list
    folders_pattern_to_list
    files_names_generation
    folders_name_generation

    re='^[0]{1}\.[0-9]G$'
    for (( i = 0; i < 100; i++ ))
    do
        current_folder_name=${folders[i]}
        if [[ ! -d current_folder_name ]]; then
            #mkdir $current_folder_name
            echo $current_folder_name >> file_gen.log
        else
            echo $current_folder_name generated folder already exists! >> file_gen.log
        fi

        files_num_generation
        files_num=$?

        for (( j = 0; j < files_num; j++))
        do
        free_memory=$(df -h | grep /dev/sda2 | awk '{print $4}')
        if [[ ! $free_memory =~ $re ]]; then 
            current_file_name=$current_folder_name${files[j]}
            if [[ ! -f $current_file_name ]]; then
            #fallocate -l ${file_size}M $current_file_name
            to_log=$current_file_name$(date +" %d-%m-%Y %H:%M:%S ")$file_size"Mb"
            echo $to_log >> file_gen.log
            else
            echo $current_file_name generated file already exists! >> file_gen.log
            fi
        else
            break
        fi
        done
    done
}
