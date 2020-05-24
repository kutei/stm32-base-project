#!/usr/bin/env bash
function print_usage(){
    echo "USAGE: ${PROGRAM_NAME} [options] <path>..."
    echo ""
    echo "[options]"
    echo "  -h,--help     show usage"
    echo "  -i            overwrite the file"
    echo "  -e <regex>    the regular expression of path to exclude"
    echo "                ex) -e \"/build/\" : exclude the file which of path include \"/build/\""
}

function get_fullpath(){
    DIR=$(dirname $1)
    PREFIX=$(cd ${DIR} && pwd)
    echo "${PREFIX}/`basename $1`"
}

function formatting(){
    filename=$1
    overwrite=$2
    tmp_true=$(mktemp /tmp/tmp.clang-formater.XXXXXXXXXX)
    tmp_diff="${tmp_true}.diff"

    if [[ ${overwrite} -eq 1 ]]; then
        # only checking
        clang-format -style=file ${filename} ${opt_overwrite} -i
        echo "${filename}: formated by clang-format"
    else
        # only checking
        clang-format -style=file ${filename} ${opt_overwrite} > ${tmp_true}
        diff -U 0 ${filename} ${tmp_true} > ${tmp_diff}
        if [[ -z "$(cat ${tmp_diff})" ]]; then
            echo "${filename}: OK"
        else
            echo "${filename}: clag-format error"
            cat ${tmp_diff} >&2
        fi
        rm ${tmp_diff}
    fi
    rm ${tmp_true}
}

function main(){
    # parse option
    for OPT in "$@"
    do
        case $OPT in
            -i)
                flag_overwrite=1
                ;;
            -e)
                flag_exclude=1
                value_exclude=$2
                shift
                ;;
            -h|--help)
                print_usage
                exit
                ;;
            -*)
                echo "${PROGRAM_NAME}: unknown option $1"
                exit 1
                ;;
            *)
                list_workspace="${list_workspace}$OPT "
                ;;
        esac
        shift
    done

    # check and get full path of args
    ws_count=0
    for ws in ${list_workspace}; do
        if [[ -e ${ws} ]] ; then
            list_ws_fullpath="${list_ws_fullpath}`get_fullpath ${ws}` "
            ws_count=$((${ws_count}+1))
        else
            echo "${ws}: No such a file or directory" >&2
            exit 1;
        fi
    done
    if [[ ${ws_count} -eq 0 ]]; then
        echo "${PROGRAM_NAME}: no file or directory is specfied."
        exit 1
    fi

    # create find option
    suffix_list="c h cpp hpp cc hh"
    for suffix in ${suffix_list}; do
        find_option="${find_option} -o -name \"*.${suffix}\""
    done
    find_option=`echo ${find_option} | cut -b 4-`

    # get file list
    filelist=$(mktemp /tmp/tmp.clang-formater.XXXXXXXXXX)
    find_cmd="find ${list_ws_fullpath} ${find_option}"
    if [[ ${flag_exclude} ]]; then
        find_cmd="${find_cmd} | grep -v -e \"${value_exclude}\""
    fi
    bash -c "${find_cmd}" > ${filelist}

    # do clang-format
    format_error=$(mktemp /tmp/tmp.clang-formater.XXXXXXXXXX)
    cat ${filelist} | xargs -n 1 -P `getconf _NPROCESSORS_ONLN` -I@ bash -c "formatting @ ${flag_overwrite:-0}" 2> ${format_error}

    # check output
    if [[ ! -z "$(cat ${format_error})" ]]; then
        cat ${format_error} >&2
        echo "format error is found in file"
        exit 1
    fi

    # rm temporary file
    rm ${filelist} ${format_error}
}

# function define for xargs
export -f formatting

# global variable
export PROGRAM_NAME=`basename $0`

main $@
