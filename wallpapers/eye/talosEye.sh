#!/usr/bin/env bash

frames=(./eye1.txt ./eye2.txt ./eye3.txt)
delay = 1
columns = "$(tput cols)"

while true; do
	for frame in "${frames[@]}"; do
	    clear
	    while IFS= read -r line; do
		    printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
	    done < "$frame"
	    sleep 1
	done
done

