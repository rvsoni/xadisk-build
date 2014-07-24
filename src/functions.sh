#!/bin/bash

function patch_files {
    for f in src/*.patch
    do
         patch_file $f
    done
}
function patch_file {
    echo "Patching file $1"
    echo "=== Patch $1 ===" >> work/build.log
    patch -p0 < $1 >> work/build.log
}

function check_commands {
    for arg in $*
    do
        check_command $arg
    done
}
function check_command {
    command -v $1 >/dev/null 2>&1 || { echo >&2 "$1 is not installed.  Aborting."; exit 1; }
}

function download_and_unzip {    
    URL=$1
    FILENAME=${URL##*/}
    echo "Trying to checkout XADisk."
    rm -rf work
    svn export $URL work
}

function maven_build {
    echo "Launching Maven build `pwd`"
    echo "=== Maven ===" >> work/build.log
    MVN=`pwd`/tool/bin/mvn
    MVN_REPO="-Dmaven.repo.local=`pwd`/.m2"
    cd work
    $MVN $MVN_REPO clean install package >> build.log 2>&1
    cd ..
}

function save_result {
    # Copy zip files to the base dir, excluding the src files
    cp work/target/xadisk*.rar dist/XADisk.rar

    if [ -f dist/XADisk.rar ]
    then
        echo "Build done. Check your dist directory for the new XADisk.rar."
        exit 0
    else
        echo "Build failed. You may have a look at the work/build.log file, maybe you'll find the reason why it failed."
        exit 1
    fi
}

function make_directory {
    if [ $1 == "-f" ]
    then
        rm -rf $2
        mkdir $2
    elif [ ! -d $1 ]
    then
        mkdir $1
    fi    
}