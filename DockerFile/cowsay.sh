#!/bin/bash
RANGE=5
LOC=/opt/Cowsay_Script/
number=$RANDOM
let "number %= $RANGE"

case $number in
    0)
        cow="lol1"
    ;;
    1)
        cow="lol2"
    ;;
    2)
        cow="lol3"
    ;;
    3)
        cow="lol4"
    ;;
    4)
        cow="lol5"
    ;;
esac

cat $LOC/$cow | /usr/local/bin/lolcat
echo -e "\n\nCreated by - Akhil Raj ❤ ❤ ❤ ❤" | /usr/local/bin/lolcat -a -d 10
echo ""