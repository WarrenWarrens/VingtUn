#!/bin/sh
echo -ne '\033c\033]0;CardGame1\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/CardGame1.x86_64" "$@"
