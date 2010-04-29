#!/bin/bash

# growlnotify leopard bug workaround
# from http://hasseg.org/blog/post/111/growlnotify-leopard-incompatibility-workaround/ - thanks!

list_args()
{
    for p in "$@"
    do
        if [ "${p:0:1}" == "-" ];then
            echo -n "$p "
        else
            echo -n "\"$p\" "
        fi
    done
}

argstr=$(list_args "${@:$?}")

echo "-H localhost $argstr" | xargs /usr/local/bin/growlnotify

