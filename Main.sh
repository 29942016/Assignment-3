#!/bin/bash
# grep -Pzo "(DSC\d{5})" ./file
# https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152
# https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC01601.jpg
# DSC01607

urlSpecificImage="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/"
urlImages="https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152"
images=$(wget -q $urlImages -O /dev/stdout | grep -Po "(DSC\d{5})" | sort --unique)

function getImageSize {
    url="${urlSpecificImage}/${id}.jpg"
    result=$(curl -sI $url | grep -i "Content-Length" | grep -Po "(\d)+")
    formatted=$(expr $result / 1024)
    echo "${formatted}kb"
}

function GetSpecific {
    echo "GetSpecific()"

    read -p "Enter image url: " id

    if [[ " ${images[@]} " =~ "${id}" ]];
    then
        echo "[OK] ${id}"
        imageSize=$(getImageSize ${id})
        echo "Downloading ${id} with the file name ${id}.jpg, with a file size of ${imageSize}..."
    else 
        echo "[ERR] Couldn't find the specified '${id}'."
    fi
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