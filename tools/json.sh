#!/bin/bash
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

findPayloadOffset() {
    build=$1
    info=$(zipdetails "$build")
    foundBin=0
    while IFS= read -r line; do
        if [[ $foundBin == 1 ]]; then
            echo "$line" | grep -q "PAYLOAD"
            res=$?
            if [[ $res == 0 ]]; then
                hexNum=$(echo "$line" | cut -d ' ' -f1)
                echo $(( 16#$hexNum ))
                break
            fi
            continue
        fi
        echo "$line" | grep -q "payload.bin"
        res=$?
        [[ $res == 0 ]] && foundBin=1
    done <<< "$info"
}

if [ "$1" ]; then
    echo "Generating json file"
    file_path=$1
    output_file_name=${2:-"default.json"} # Default output file name if not provided
    optional_expected_filename=$3
    file_dir=$(dirname "$file_path")
    file_name=$(basename "$file_path")
    md5sum=$(md5sum "$file_path" | cut -d' ' -f1)
    device_code=$(echo $file_name | cut -d'-' -f4)
    url="https://sourceforge.net/projects/stagos-14/files/${device_code}/${file_name}/download"
    if [ ! -z "$optional_expected_filename" ]; then
        url="https://sourceforge.net/projects/stagos-14/files/${device_code}/incremental/${filename}/download"
    fi

    if [ -f $file_path ]; then
        if [[ $file_name == *"BETA"* ]] || [[ $file_name == *"OFFICIAL"* ]] || [[ $file_name == *"incremental"* ]] || [[ $FORCE_JSON == 1 ]]; then
            if [[ $FORCE_JSON == 1 ]]; then
                echo -e "${GREEN}Forced generation of json${NC}"
            fi
            offset=$(findPayloadOffset "$file_path")
            [ -f payload_properties.txt ] && rm payload_properties.txt
            unzip "$file_path" payload_properties.txt
            keyPairs=$(cat payload_properties.txt | sed "s/=/\": \"/" | sed 's/^/          \"/' | sed 's/$/\"\,/')
            keyPairs=${keyPairs%?}
            datetime=$(date +%s)
            {
                echo "{"
                echo "  \"response\": ["
                echo "    {"
                echo "      \"datetime\": ${datetime},"
                echo "      \"filename\": \"${file_name}\","
                echo "      \"url\": \"${url}\","
                echo "      \"md5\": \"${md5sum}\","
                echo "      \"payload\": ["
                echo "        {"
                echo "          \"offset\": ${offset},"
                echo "${keyPairs}"
                echo "        }"
                echo "      ]"
                if [ ! -z "$optional_expected_filename" ]; then
                    echo "          ,\"expected_filename\": \"${optional_expected_filename}\""
                fi
                echo "    }"
                echo "  ]"
                echo "}"
            } > "${output_file_name}"
            mv "${output_file_name}" "${file_dir}/${output_file_name}"
            echo -e "${GREEN}Done generating ${YELLOW}${output_file_name}.json${NC}"
        else
            echo -e "${YELLOW}Skipped generating json for a non-official build${NC}"
        fi
    fi
fi
