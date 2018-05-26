#!/bin/bash

desk="a81 b8 c81 d8 e81 f8 g81 h8 
a7 b71 c7 d71 e7 f71 g7 h71 
a61 b6 c61 d6 e61 f6 g61 h6 
a5 b5 c5 d5 e5 f5 g5 h5 
a4 b4 c4 d4 e4 f4 g4 h4 
a3 b30 c3 d30 e3 f30 g3 h30 
a20 b2 c20 d2 e20 f2 g20 h2 
a1 b10 c1 d10 e1 f10 g1 h10 
Input: "

esc=`printf "\033[0m"`
blackwhite=`printf "\033[40;1m"`
black=`printf "\033[40m"`
white=`printf "\033[47m"`
blackblack=`printf "\033[40;30;1m"`

draw() {
    echo "$desk" | sed "
     1s/\([aceg]8 \)/${black}\1${esc}/g
     3s/\([aceg]6 \)/${black}\1${esc}/g
     5s/\([aceg]4 \)/${black}\1${esc}/g
     7s/\([aceg]2 \)/${black}\1${esc}/g
     1s/\([bdfh]8 \)/${white}\1${esc}/g
     3s/\([bdfh]6 \)/${white}\1${esc}/g
     5s/\([bdfh]4 \)/${white}\1${esc}/g
     7s/\([bdfh]2 \)/${white}\1${esc}/g
     2s/\([bdfh]7 \)/${black}\1${esc}/g
     4s/\([bdfh]5 \)/${black}\1${esc}/g
     6s/\([bdfh]3 \)/${black}\1${esc}/g
     8s/\([bdfh]1 \)/${black}\1${esc}/g
     2s/\([aceg]7 \)/${white}\1${esc}/g
     4s/\([aceg]5 \)/${white}\1${esc}/g
     6s/\([aceg]3 \)/${white}\1${esc}/g
     8s/\([aceg]1 \)/${white}\1${esc}/g
     s/[a-h][1-8]1 /${blackblack}• ${esc}/g
     s/[a-h][1-8]0 /${blackwhite}• ${esc}/g
     s/[a-z][1-8] /  /g"
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
            echo "$column_from $column_to" > out.txt
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
