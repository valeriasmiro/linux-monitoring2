#!/bin/bash

path="/home/student/linux-monitoring2/trash/"
if ! [ -d $path ]; then
    mkdir $path
fi
declare -a files
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

function files_names_generation() {
    ptr_fi=0
    dub_fi=0

    for (( i = 0; i < 100; i++ ))
    do
        ptr_fi=$((i%${#files_name_pattern}))
        dub_fi=$((2+i/${#files_name_pattern}))
        name=""

        for (( j = 0; j < ${#files_name_pattern}; j++ ))
        do
            if [[ j -eq $ptr_fi ]]; then
                dub_fi=$(($dub_fi-1))
            fi
            for (( k = 0; k < dub_fi; k++ ))
            do
                name+=${files_pattern_list[j]}
            done
        done
        current_file_name=$name.$files_extention$(date +"_%d%m%y")
        files[i]=$current_file_name
    done
}

function folder_name_generation() {
    ptr_fo=0
    dub_fo=0
    folders_pattern_length=${#folders_pattern}

    ptr_fo=$((i%$folders_pattern_length))
    dub_fo=$((2+i/$folders_pattern_length))
    name=""
    for (( j = 0; j < folders_pattern_length; j++ ))
    do
        if [[ j -eq $ptr_fo ]]; then
        let "dub_fo -= 1"
        fi
        for (( k = 0; k < dub_fo; k++ ))
        do
            name+=${folders_pattern_list[j]}
        done
    done
    current_folder_name=$path$name$(date +"_%d%m%y/")
}

function main_func() {
    delimeter="."
    files_name_pattern=${files_pattern%$delimeter*}
    files_extention=${files_pattern##*$delimeter}

    echo "This might take a little bit of time"
    echo "be prepared that 1GB of free memory will remain on the disk"

    files_pattern_to_list
    folders_pattern_to_list
    files_names_generation

    re='M$'
    for (( i = 0; i < 100; i++ ))
    do
        folder_name_generation
        if ! [[ -d $current_folder_name ]]; then
            mkdir $current_folder_name
            echo $current_folder_name >> file_gen.log
        else
            echo $current_folder_name generated folder already exists! >> file_gen.log
        fi

        files_num_generation
        files_num=$?

        for (( j = 0; j < files_num; j++))
        do
        free_memory=$(df -h | grep /dev/sda2 | awk '{print $4}')
        if ! [[ $free_memory =~ $re ]]; then 
            current_file_name=$current_folder_name${files[j]}
            if ! [[ -f $current_file_name ]]; then
                fallocate -l ${file_size}M $current_file_name
                to_log=$current_file_name$(date +" %d-%m-%Y %H:%M:%S ")$file_size"Mb"
                echo $to_log >> file_gen.log
            else
                echo $current_file_name generated file already exists! >> file_gen.log
            fi
        else
            break
            echo 'fuck you shit'
        fi
        done
    done
}
