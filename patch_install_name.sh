#!/bin/bash

# Set global parameters.
WORK_DIR=$HOME/tmp/patch_install_name

# Set a safe shell.
set -o errexit
set -o pipefail
set -o nounset

# Parse command line.
if [ "$#" -lt 2 ]
then
    echo "Usage: bash patch_install_name.sh FILENAME NAME0 [NAME1, ...]"
    echo "       where NAME0 with match file libNAME0.dylib"
    exit 1
fi
packagepath=$1
packagename=$(basename $1)

# Create a fresh WORK_DIR.
rm -rf $WORK_DIR
mkdir -p $WORK_DIR
cd $WORK_DIR

# Extract archive.
tar xvjf $packagepath
content=$(ls)

shift
for name in $@
do
    all_version_pattern="lib$name*.dylib"
    install_name="@rpath/lib$name.dylib"
    for libpath in $(find . -name $all_version_pattern)
    do
        echo "install_name_tool -id $install_name $libpath"
        install_name_tool -id $install_name $libpath
    done
done

# Create archive
tar cvjf $packagename $content
echo $WORK_DIR/$packagename
