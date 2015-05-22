#!/bin/bash

# Set a safe shell.
set -o errexit
set -o pipefail
set -o nounset

HERE=$PWD
CACHE_DIR=$HERE/cache
PATCHED_DIR=$HERE/patched

mkdir -p $CACHE_DIR
mkdir -p $PATCHED_DIR

# Download pacakges
cd $CACHE_DIR
if [ ! -f mpich-3.1.4-0.tar.bz2 ]
then
    curl -L -O https://binstar.org/mpi4py/mpich/3.1.4/download/osx-64/mpich-3.1.4-0.tar.bz2 
fi

# Patch packages
cd $HERE
for filename in mpich-3.1.4-0.tar.bz2 
do
    patch_install_name.sh $CACHE_DIR/$filename $PATCHED_DIR/$filename
    echo "=== patched: $PATCHED_DIR/$filename"
done
