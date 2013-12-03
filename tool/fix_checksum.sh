#!/bin/sh

if [ $# != 1 ]; then
	echo "Usage: $0 <path to new firmware>"
	exit 1
fi

if [ ! -f $1 ]; then
    echo "$1 is not a file"
    exit 1
fi

# check if the sum of new firmware's first 8 word(4 bytes) is zero
od -N 32 -t u4 -v -w32 "$1" > /tmp/lpc1xxx
read addr u1 u2 u3 u4 u5 u6 u7 u8 < /tmp/lpc1xxx
sum=$(($u1 + $u2 + $u3 + $u4 + $u5 + $u6 + $u7))
cks=$(((~$sum + 1) & 0xFFFFFFFF))
if [ $u8 != $cks ]; then
    echo "Fix the firmware"
    # for big endian
    # printf "0: %0.8X" $cks | xxd -r -g0 > /tmp/lpc1xxx
    # for little endian
    printf "0: %.8X" $cks | sed -E 's/0: (..)(..)(..)(..)/0: \4\3\2\1/' | xxd -r -g0 > /tmp/lpc1xxx
    dd bs=4 count=1 seek=7 conv=notrunc if=/tmp/lpc1xxx of="$1"
else
    echo "The firmware is OK"
fi

# remove tmp file
rm -f /tmp/lpc1xxx

