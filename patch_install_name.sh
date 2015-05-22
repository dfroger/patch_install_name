#!/bin/bash

# Set global parameters.
WORK_DIR=$HOME/tmp/patch_install_name

# Set a safe shell.
set -o errexit
set -o pipefail
set -o nounset

# Parse command line.
if [ "$#" -ne 1 ]
then
    echo "Usage: bash patch_install_name.sh pkg.tar.bz2"
    exit 1
fi
packagepath=$1
packagename=$(basename $1)

# Create a fresh WORK_DIR.
rm -rf $WORK_DIR
mkdir -p $WORK_DIR
cd $WORK_DIR

# Extract archive.
tar xjf $packagepath
content=$(ls)

for filepath in $(find . -name '*.dylib')
do
    install_name="@rpath/$(basename $filepath)"
    echo "install_name_tool -id $install_name $filepath"
    #install_name_tool -id $install_name $filepath
done

# Create archive
tar cjf $packagename $content
echo $WORK_DIR/$packagename
