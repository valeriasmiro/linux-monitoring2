#!/bin/bash
if [[ -d /home/student/linux-monitoring2/trash ]]; then
    rm -rf /home/student/linux-monitoring2/trash
fi
if [[ -f file_gen.log ]]; then
    rm file_gen.log
fi