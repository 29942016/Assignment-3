#!/bin/bash
# grep -Pzo "(DSC\d{5})" ./file
# https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152
# https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC01601.jpg
# DSC01607

urlSpecificImage="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/"
urlImages="https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152"
images=($(wget -q $urlImages -O /dev/stdout | grep -Po "(DSC\d{5})" | sort --unique))
localDirectory="./fetched"

# Initial setup required for the application to
# run. Builds the storage directory for images.
function setup {
    if ! test -d "${localDirectory}";
    then
        mkdir -p ${localDirectory}
    fi
}

# Checks if the id provided exists 
# as a image on the disk.
function doesImageExistOnDisk {
    localPath="./$1.jpg"

    if test -f "${localDirectory}/${localPath}";
    then
        return 0
    fi

    return 1
}

# Given an image id, it will attempt to
# pull the images properties using curl
# and finally return the size of the image
# in kilobytes.
function getImageSize {
    url="${urlSpecificImage}/${id}.jpg"
    result=$(curl -sI $url | grep -i "Content-Length" | grep -Po "(\d)+")
    formatted=$(expr $result / 1024)
    echo "${formatted}kb"
}

# Given an id it will attempt to download
# it using wget, after wget finishes it then
# checks on disk to see if the image has 
# succesfully downloaded.
function downloadImage {
    url="${urlSpecificImage}/$1.jpg"
    outputFile="$1.jpg"
    imageSize=$(getImageSize $1)

    echo "Downloading \"$1\" with the file name ${outputFile}, with a file size of ${imageSize}"
    result=$(wget -q ${url} -O ${localDirectory}/${outputFile})

    if doesImageExistOnDisk $1;
    then
        echo "[OK] Download completed!"
    else
        echo "[ERR] Download failed to complete."
    fi
}

# Checks if the data from the webserver 
# contains a specific image id.
function doesImageExist {
    if [[ " ${images[@]} " =~ "${id}" ]];
    then
        return 0
    else 
        echo "[ERR] Couldn't find the specified '${id}' in the list of available images."
        return 1
    fi

}

# Attempts to download a specific image 
# via an id provided by the user
function GetSpecific {
    echo "GetSpecific()"

    read -p "Enter image url: " id

    if doesImageExist ${id}
    then
        downloadImage ${id}
    fi
}

# Attempts to download all images
function GetAll {
    count="${#images[@]}"
    # echo "[${images[$id]}/${count}]"
    echo "Downloading ${count} image(s)."
    for id in "${!images[@]}"
    do
        item="${images[$id]}"
        echo "[${id}/$count] - ${item}"

        if ! doesImageExistOnDisk ${item};
        then
            downloadImage ${item}
        else
            echo "Image already exists, skipping."
        fi
    done
}

function GetInRange {
    echo "GetInRange()"
}

function GetRandomAmount {
    echo "GetRandomAmount()"
}


setup
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
