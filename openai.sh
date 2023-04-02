#!/bin/bash

OPENAI_API_KEY=""

generate_image_from_text () {
    curl https://api.openai.com/v1/images/generations \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"prompt\": \"$1\",
            \"n\": 1,
            \"size\": \"1024x1024\"
        }"
}

get_image_size () {
    size=`exiftool $1  | grep "Image Size" | tr -s " " " " | cut -d " " -f 4`
    echo $size
}

generate_image_from_image () {
    echo ${1}
    curl https://api.openai.com/v1/images/variations \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -F image="@${1}" \
        -F n=1 \
        -F size=${2}
}

if [[ $# -eq 2 ]]
then
    case $1 in
        "image-from-text")
            echo "Generating image from text..."
            generate_image_from_text "$2"
        ;;
        "image-from-image")
            echo "Generating image from text..."
            result=$(get_image_size $2)
            echo $result
            generate_image_from_image "$2" "$result"
        ;;
        *)
            echo "Incorrect option"
        ;;
    esac
fi
