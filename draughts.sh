#!/bin/bash

desk="a8b8c8d8e8f8g8h8
a7b7c7d7e7f7g7h7
a6b6c6d6e6f6g6h6
a5b5c5d5e5f5g5h5
a4b4c4d4e4f4g4h4
a3b3c3d3e3f3g3h3
a2b2c2d2e2f2g2h2
a1b1c1d1e1f1g1h1
Input: "

esc=`printf "\033[0m"`
blackwhite=`printf "\033[40;1m"`
white=`printf "\033[47m"`
blackblack=`printf "\033[40;30;1m"`

draw() {
    echo "$desk" | sed "
    1s/\([aceg]8\)/${blackblack}\1${esc}/g
    3s/\([aceg]6\)/${blackblack}\1${esc}/g
    5s/\([aceg]4\)/${blackwhite}\1${esc}/g
    7s/\([aceg]2\)/${blackwhite}\1${esc}/g
    1s/\([bdfh]8\)/${white}\1${esc}/g
    3s/\([bdfh]6\)/${white}\1${esc}/g
    5s/\([bdfh]4\)/${white}\1${esc}/g
    7s/\([bdfh]2\)/${white}\1${esc}/g
    2s/\([aceg]7\)/${white}\1${esc}/g
    4s/\([aceg]5\)/${white}\1${esc}/g
    6s/\([aceg]3\)/${white}\1${esc}/g
    8s/\([aceg]1\)/${white}\1${esc}/g
    2s/\([bdfh]7\)/${blackblack}\1${esc}/g
    4s/\([bdfh]5\)/${blackwhite}\1${esc}/g
    6s/\([bdfh]3\)/${blackwhite}\1${esc}/g
    8s/\([bdfh]1\)/${blackwhite}\1${esc}/g
    1s/\([aceg]8\)/• /g
    2s/\([bdfh]7\)/• /g
    3s/\([aceg]6\)/• /g
    6s/\([bdfh]3\)/• /g
    7s/\([aceg]2\)/• /g
    8s/\([bdfh]1\)/• /g
    s/[a-z][1-8]/  /g"
}

move() {
    if [[ $1 =~ ^[a-h][1-8]$ && $2 =~ ^[a-h][1-8]$ ]]
    then
        if [ $current = "White" ]
        then
            row_from=${1:1:1}
            row_to=${2:1:1}
            column_from=`printf %d "'${1:0:1}"`
            column_to=`printf %d "'${2:0:1}"`
            column_from=`expr $column_from - 97`
            column_to=`expr $column_to - 97`
            column_from=`expr 2 * $column_from`
            column_to=`expr 2 * $column_to`
            column_from=`expr $column_from + 1`
            column_to=`expr $column_to + 1`
            result=`echo $desk | sed "
            $row_from {
             
            } 
            "` 
        else
            sleep .1 
        fi
        echo "1"
    else
        echo "0"
    fi
}

current="White"
while [ 1 ]
do
    tput clear
    echo $current
    out=`draw`
    printf "%s" "$out"
    read from to
    result=`move $from $to`
    if [ $result = "1" ]
    then
        if [ $current = "White" ]
        then
            current="Black"
        else
            current="White"
        fi
    else
        echo "Wrong move!"
    fi
    sleep 1
done
