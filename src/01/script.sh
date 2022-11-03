#!/bin/bash

declare -a folders
declare -a files
declare -a folder_array_pattern
declare -a file_array_pattern

function generate_folders_name {
    local ptr=0
    local dub=0
    local folder_pattern_length=${#folder_pattern}

    # generate folder pattern array
    for (( i = 0; i < folder_pattern_length; i++ ))
    do
        folder_array_pattern[i]=${folder_pattern:i:1}
    done

    # algorithm for generating folders names and add them to folders array
    for (( i = 0; i < folders_num; i++ ))
    do
        ptr=$((i%$folder_pattern_length))
        dub=$((2+i/$folder_pattern_length))
        current_folder_name=""

        for (( j = 0; j < folder_pattern_length; j++ ))
        do
            if [[ j -eq $ptr ]]; then
                dub=$(($dub-1))
            fi

            for (( k = 0; k < dub; k++ ))
            do
                current_folder_name+=${folder_array_pattern[j]}
            done
        done

        current_folder_name=$path$current_folder_name$(date +"_%d%m%y/")
        folders[i]=$current_folder_name
    done
}

function generate_files_name {
    local ptr=0
    local dub=0

    #divide name and extension
    file_name_pattern=${file_pattern%"."*}
    local file_pattern_length=${#file_name_pattern}
    file_extention=${file_pattern##*"."}

    #file name pattern to array 
    for (( i = 0; i < file_pattern_length; i++ ))
    do
        file_array_pattern[i]=${file_name_pattern:i:1}
    done
    #algorithm for generating files names
    for (( i = 0; i < files_num; i++ ))
    do
        ptr=$((i%$file_pattern_length))
        dub=$((2+i/$file_pattern_length))
        current_file_name=""

        for (( j = 0; j < file_pattern_length; j++ ))
        do
            if [[ j -eq $ptr ]]; then
                dub=$(($dub-1))
            fi
            for (( k = 0; k < dub; k++ ))
            do
                current_file_name+=${file_array_pattern[j]}
            done
        done
        current_file_name=$current_file_name.$file_extention$(date +"_%d%m%y")
        files[i]=$current_file_name
    done
}

function file_generation {
    for (( i = 0; i < folders_num; i++ ))
    do
        current_folder=${folders[i]}
        if [[ ! -d $current_folder ]]; then
            mkdir $current_folder
            echo $current_folder >> file_gen.log
        else
            echo $current_folder generated folder already exists! >> file_gen.log
        fi
        
        for (( j = 0; j < files_num; j++ ))
        do
            free_memory=$(df -h | grep /dev/sda2 | awk '{print $4}')
            current_file=${folders[i]}${files[j]}
            if [[ $free_memory > 1 ]]; then
                if [[ ! -e $current_file ]]; then
                    fallocate -l ${file_size}K $current_file
                    to_log=$current_file$(date +" %d-%m-%Y %H:%M:%S ")$file_size'kb'
                    echo $to_log >> file_gen.log
                else
                    echo $current_file generated file already exists! >> file_gen.log
                fi
            else
                echo "The script stopped working because there was 1 Gb of free memory left" > file_gen.log
                break 2
            fi
        done
        echo '' >> file_gen.log
    done
}
