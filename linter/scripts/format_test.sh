#!/usr/bin/env bash
function get_full_path(){
    DIR=$(dirname $1)
    PREFIX=$(cd ${DIR} && pwd)
    echo "${PREFIX}/`basename $1`"
}

function format_diff(){
    cd $1
    echo "clang-format is executed at [$1]"
    clang-format -style=f"{`cat $1 | sed 's/
/,/g'`}" $2 > tmp
    diff -u $2 tmp
    rm tmp
}

script_dir=$(cd `dirname $0` && pwd)
format_diff "${script_dir}/.clang-format" `get_full_path $1`
