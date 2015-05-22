#!/bin/bash

# Set a safe shell.
set -o errexit
set -o pipefail
set -o nounset

# Parse command line.
if [ "$#" -ne 2 ]
then
    echo "Usage: bash patch_install_name.sh PKG.tar.bz2 PATCHED-PKG.bz2"
    exit 1
fi
PACKAGEPATH=$1
PATCHED_PACKAGEPATH=$2

packagename=$(basename $1)

# Set up a fresh WORK_DIR.
WORK_DIR=/tmp/patch_install_name
rm -rf $WORK_DIR
mkdir -p $WORK_DIR
cd $WORK_DIR

# Extract archive.
tar xjf $PACKAGEPATH
content=$(ls)

for filepath in $(find . -name '*.dylib')
do
    install_name="@rpath/$(basename $filepath)"
    echo "install_name_tool -id $install_name $filepath"
    install_name_tool -id $install_name $filepath
done

# Create archive
tar cjf $PATCHED_PACKAGEPATH $content
