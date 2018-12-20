#!/usr/bin/env bash

# TODO -> update this if there are changes to the arguments passed
printf "USAGE: \n* 'bash $0 dir_arg'\n* 'bash $0 percentage_arg dir_arg'\n* 'bash $0 width_arg height_arg dir_arg'\nAnything else will not work properly.\n"

execute_script() {
    while [[ $prefix = "" ]];
    do
        printf "\nEnter chosen prefix: "
        read prefix
    done

    # downloads/combined was the placeholder
    printf "Target directory: $dir\n"
    cd "$dir"

    readonly LOG="chronicle.log"

    now=$(date '+%d/%m/%Y | %r')
    echo "-> New renaming started:" >> $LOG

    # declaring an array variable
    declare -a files=(`ls`)
    echo "Files here: ${files[@]}"

    printf "Loader: \n"
    echo "*"

    # for loading the renaming and/or size conversion
    loader=1
    sp="/-\|"
    echo -n ' '

    id=0
    for file in *.*
    do
        if [[ "$file" =~ \.(jpeg|png|jpg)$ ]]; then
            id=$((id+1))
            echo -ne "\b${sp:loader++%${#sp}:1}"
            mv "$file" "$prefix-$id".jpg

            if [[ "$percentage" != "" ]]; then
                convert "$prefix-$id".jpg -resize "$percentage"% "$prefix-$id".jpg
            fi

            if [[ "$width" != "" && "$height" != "" ]]; then
                convert "$prefix-$id".jpg -resize "$width"x"$height" "$prefix-$id".jpg
            fi

            echo "$prefix-$id.jpg was $file" >> $LOG
        fi
    done

    printf "\n*"

    if [[ "$id" -ne 0 ]]; then
        echo "-> Renaming files date: $now" >> $LOG
        printf "\nRenaming complete. Check your renamed images in this file: $LOG\n"
    else
        printf "\nNo .jpeg, .png or .jpg files present in this dir.\n"
        echo "ABORTED" >> $LOG
    fi
}

# echo "Arguments count: $#"
# arguments passed
if [[ "$#" -eq 1 ]]; then
    dir="$1"
    execute_script
elif [[ "$#" -eq 2 ]]; then
    percentage="$1"
    dir="$2"
    execute_script
elif [[ "$#" -eq 3 ]]; then
    width="$1"
    height="$2"
    dir="$3"
    execute_script
else
    printf "Invalid argument size.\n"
fi
