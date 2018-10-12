for combo in $(curl -s https://raw.githubusercontent.com/StagOS/android_vendor_stag/p9/stag.devices | sed -e 's/#.*$//' | awk '{printf "stag_%s-%s\n", $1, $2}')
do
    add_lunch_combo $combo
done
