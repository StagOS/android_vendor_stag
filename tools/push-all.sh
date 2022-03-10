#!/usr/bin/env bash
# Script to merge latest AOSP tag in AOSP-LEGACY source
# Can be adapted to other AOSP-based ROMs as well
#
# Retarded repo push script based on https://raw.githubusercontent.com/ghostrider-reborn/scripts/master/merge-aosp-tag-legacy.sh
#
# Usage: Just run the script in root of ROM source
#

# Colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'

# Assumes user is running the script in root of source
ROM_PATH=$(pwd)

# ROM-specific constants
BRANCH=staging/u14
REMOTE_NAME=stag
REPO_XML_PATH="snippets/stag.xml"

# Blacklisted repos - don't push these.
blacklist="manifest"

# Logic kanged from some similar script
repos="$(grep "remote=\"$REMOTE_NAME\"" $ROM_PATH/.repo/manifests/$REPO_XML_PATH  | awk '{print $2}' | awk -F '"' '{print $2}')"

for files in success failed; do
    rm $files 2> /dev/null
    touch $files
done

for REPO in $repos; do
    if [[ $blacklist =~ $REPO ]]; then
        echo -e "\n$REPO is in blacklist, skipping"
      fi
            cd $REPO
                if [[ $(git rev-parse HEAD) != $(git rev-parse $REMOTE_NAME/$BRANCH) ]] && [[ $(git diff HEAD $REMOTE_NAME/$BRANCH) ]]; then
                   echo "Sus moment"
                   echo "$REPO" >> $ROM_PATH/success
                else
                   echo "$REPO" >> $ROM_PATH/failed
                fi
                cd $ROM_PATH
done

echo $red
read -p "Do you want to push your progress and not be stupid like coderastic who forgot and force-synced 2 months worth of work? (Y/N): " PUSH
echo $end

if [[ $PUSH == "Y" ]] || [[ $PUSH == "y" ]]; then
    # Push succesfully merged repos
    for REPO in $(cat success); do
        cd $REPO
        echo -e "Pushing $REPO ..."
        git push -q $REMOTE_NAME HEAD:$BRANCH &> /dev/null
        cd $ROM_PATH
    done
fi

echo "All done :)"
