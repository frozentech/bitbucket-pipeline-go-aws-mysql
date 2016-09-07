#!/usr/bin/env bash

# exit on error
set -e

if test "$#" -ne 2; then
    echo "Illegal number of parameters"
fi

cat <<EOF
default:
  driver: ${1}
  open: ${2}
EOF
