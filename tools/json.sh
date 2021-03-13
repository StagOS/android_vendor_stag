#!/bin/bash
device=${TARGET_PRODUCT#*_}
OUT="$OUT_DIR/target/product/$device"
echo "{ \"response\": [ { \"datetime\": $(grep ro\.build\.date\.utc $OUT/system/build.prop | cut -d= -f2), \"filename\": \"$(basename $(ls $OUT/StagOS*.zip))\", \"id\": \"$((sha256sum $OUT/StagOS*.zip) | cut -d ' ' -f1)\", \"size\": $(stat -c%s $OUT/StagOS*.zip), \"url\": \"https://releases.stag-os.workers.dev/${device}/$(basename $(ls $OUT/StagOS*.zip))\", \"version\": \"$(grep ro\.stag\.version $OUT/system/build.prop | cut -d= -f2)\" }]}" | tee $OUT/update
