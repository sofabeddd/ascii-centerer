#!/bin/bash

calculate_center() {
    local term_width=$(tput cols)
    local term_height=$(tput lines)
    local ascii_width=$1
    local ascii_height=$2

    local center_x=$(( ($term_width - ascii_width) / 2 ))
    local center_y=$(( (term_height - ascii_height) / 2 ))

    echo "$center_x $center_y"
}

print_center() {
    clear
    local ascii_art=$(echo "$1" | sed 's/\\e\[\([0-9;]*\)m/\o33\[\1m/g')
    local ascii_art_clean=$(echo -e "$ascii_art" | sed -r "s/\x1B\[[0-9;]*[a-zA-Z]//g")
    local art_width=$(awk '{ print length }' <<< "$ascii_art_clean" | sort -nr | head -n1)
    local art_height=$(echo "$ascii_art_clean" | wc -l)
    local center_x
    local center_y

    read -r center_x center_y < <(calculate_center "$art_width" "$art_height")

    local padding_top=$((center_y))
    local padding_side=$((center_x))

    for (( i=1; i<=$padding_top; i++ )); do
        echo
    done

    while IFS= read -r line; do
        printf "%*s%s\n" $padding_side '' "$line" 
    done <<< "$ascii_art"

    for (( i=1; i<=$padding_top; i++ )); do
        echo
    done
}

ascii_art=$(cat <<'EOF'
\e[1;36m                  -`
                 .o+`
                `ooo/
               `+oooo:
              `+oooooo:
              -+oooooo+:
            `/:-:++oooo+:
           `/++++/+++++++:
          `/++++++++++++++:
         `/+++ooooooooooooo/`
        ./ooosssso++osssssso+`
       .oossssso-````/ossssss+`
      -osssssso.      :ssssssso.
     :osssssss/        osssso+++.
    /ossssssss/        +ssssooo/-
  `/ossssso+/:-        -:/+osssso+-
 `+sso+:-`                 `.-/+oso:
`++:.                           `-/+/
.`                                 `\e[0;37m
EOF
)

tput civis; print_center "$ascii_art"; sleep 2; clear; tput cnorm
