#!/bin/bash
# grep -Pzo "(DSC\d{5})" ./file
# https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152

function GetSpecific {
    url="https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152"
    echo "GetSpecific()"

    data=$(wget -q $url -O /dev/stdout | grep -Po "(DSC\d{5})" | sort --unique)
    echo ${data[@]}

    #read -p "Enter image url: " id
}

function GetAll {
    echo "GetAll()"
}

function GetInRange {
    echo "GetInRange()"
}

function GetRandomAmount {
    echo "GetRandomAmount()"
}

clear
cat <<EOF
==============================
|      Image Grabber         |
==============================
| 1) Get a specific url      |
| 2) Get all images          |
| 3) Get images in range     |
| 4) Get a specified amount  |
| 5) Exit                    |
==============================
EOF

read -n1 -s
clear
case "$REPLY" in
    "1") GetSpecific ;;
    "2") GetAll ;;
    "3") GetInRange ;;
    "4") GetRandomAmount ;;
    *  ) ;;
esac

# Main