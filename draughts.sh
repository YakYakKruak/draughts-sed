#!/bin/bash

desk="a81 b8 c81 d8 e81 f8 g81 h8 
a7 b71 c7 d71 e7 f71 g7 h71 
a61 b6 c61 d6 e61 f6 g61 h6 
a5 b5 c5 d5 e5 f5 g5 h5 
a4 b4 c4 d4 e4 f4 g4 h4 
a3 b30 c3 d30 e3 f30 g3 h30 
a20 b2 c20 d2 e20 f2 g20 h2 
a1 b10 c1 d10 e1 f10 g1 h10 
Input command: "

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
        s/[a-z][1-8] /  /g" | sed "/Input/!=" |
        sed "N; s/\n/ /"  | sed "8s/^8/1/; 7s/^7/2/; 6s/^6/3/; 5s/^5/4/; 4s/^4/5/; 3s/^3/6/; 2s/^2/7/; 1s/^1/8/" | 
        sed "/Input/i\  a b c d e f g h"
}

check_end() {
    echo "$desk" | sed "
        s/[a-h][1-8]0/\n0\n/ 
        s/[a-h][1-8]1/\n1\n/" | sed "/[^01]/d; /^$/d;" | sort | uniq | wc -l
}

move() {
    if [[ $1 =~ ^[a-h][1-8]$ && $2 =~ ^[a-h][1-8]$ ]]
    then
        row_from=${1:1:1}
        row_to=${2:1:1}
        column_from=`printf %d "'${1:0:1}"`
        column_to=`printf %d "'${2:0:1}"`
        column_from=`expr $column_from - 97`
        column_to=`expr $column_to - 97`
        row_from=`expr 9 - $row_from`
        row_to=`expr 9 - $row_to`

        if [[ `expr $row_from - $row_to | tr -d -` = 2 && `expr $column_from - $column_to | tr -d -` = 2 ]]
        then
            flag=2
        elif [[ `expr $row_from - $row_to | tr -d -` = 1 && `expr $column_from - $column_to | tr -d -` = 1 ]]
        then
            flag=1
        else
            echo "error"
            return
        fi

        if [ $current = "White" ]
        then
            if [ $flag = 1 ]
            then
                echo "$desk" | sed "
                    $row_from {
                        s/\(\([a-h][1-8][01]\? \)\{${column_from}\}\)\([a-h][1-8]\)0/\1\3/
                        t ok
                        s/.*/error/
                        q;
                    }
                    $row_to {
                        s/\(\([a-h][1-8][01]\? \)\{${column_to}\}\)\([a-h][1-8]\) /\1\30 /
                        t ok
                        s/.*/error/
                        q;
                    }
                    :ok"
            else
                column_middle=`expr $column_from + $column_to`
                row_middle=`expr $row_from + $row_to` 
                column_middle=`expr $column_middle / 2`
                row_middle=`expr $row_middle / 2` 
                echo "$desk" | sed "
                    $row_from {
                        s/\(\([a-h][1-8][01]\? \)\{${column_from}\}\)\([a-h][1-8]\)0/\1\3/
                        t ok
                        s/.*/error/
                        q;
                    }
                    $row_middle {
                        s/\(\([a-h][1-8][01]\? \)\{${column_middle}\}\)\([a-h][1-8]\)1/\1\3/
                        t ok
                        s/.*/error/
                        q;
                    }
                    $row_to {
                        s/\(\([a-h][1-8][01]\? \)\{${column_to}\}\)\([a-h][1-8]\) /\1\30 /
                        t ok
                        s/.*/error/
                        q;
                    }
                    :ok"
            fi
        else
            if [ $flag = 1 ]
            then
                echo "$desk" | sed "
                    $row_from {
                        s/\(\([a-h][1-8][01]\? \)\{${column_from}\}\)\([a-h][1-8]\)1/\1\3/
                        t ok
                        s/.*/error/
                        q;
                    }
                    $row_to {
                        s/\(\([a-h][1-8][01]\? \)\{${column_to}\}\)\([a-h][1-8]\) /\1\31 /
                        t ok
                        s/.*/error/
                        q;
                    }
                    :ok"
            else
                column_middle=`expr $column_from + $column_to`
                row_middle=`expr $row_from + $row_to` 
                column_middle=`expr $column_middle / 2`
                row_middle=`expr $row_middle / 2` 
                echo "$desk" | sed "
                    $row_from {
                        s/\(\([a-h][1-8][01]\? \)\{${column_from}\}\)\([a-h][1-8]\)1/\1\3/
                        t ok
                        s/.*/error/
                        q;
                    }
                    $row_middle {
                        s/\(\([a-h][1-8][01]\? \)\{${column_middle}\}\)\([a-h][1-8]\)0/\1\3/
                        t ok
                        s/.*/error/
                        q;
                    }
                    $row_to {
                        s/\(\([a-h][1-8][01]\? \)\{${column_to}\}\)\([a-h][1-8]\) /\1\31 /
                        t ok
                        s/.*/error/
                        q;
                    }
                    :ok"
            fi
        fi
    else
        echo "error"
    fi
}

current="White"
while [ 1 ]
do
    tput clear
    result=`check_end`

    if [ "$result" = 1 ]
    then
        if [ $current = "White" ]
        then
            echo "Black's is winners!"
        else
            echo "White's is winners!"
        fi
        exit
    fi

    printf "%s\n" "$current's move"
    out=`draw`
    printf "%s" "$out"
    read from to

    if [ "$from" = "bye" ]
    then
        exit
    fi

    result=`move $from $to`

    if ! [[ "$result" =~ "error" ]]
    then
        desk=$result
        if [ $current = "White" ]
        then
            current="Black"
        else
            current="White"
        fi
    else
        echo "Wrong move!"
    fi

    sleep .5
done
