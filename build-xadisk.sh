#!/bin/bash

source src/functions.sh

check_commands svn unzip patch ant
make_directory -f dist
download_and_unzip https://svn.java.net/svn/xadisk~svn/trunk
patch_files
maven_build
save_result

