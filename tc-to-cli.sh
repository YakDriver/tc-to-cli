#!/bin/bash

function tc-to-cli() {
  local filepath=$1
  local temp_file="${filepath}.bak"

  # creates a temp file we can use for rest of processing
  sed -i.bak 1d "${filepath}"

  # pre process
  perl -p -i -e 's/\d+,([^,]+),OK,(\d+)/--- PASS: $1 ($2s)/g' "${temp_file}"
  perl -p -i -e 's/\d+,([^,]+),Failure,(\d+)/--- FAIL: $1 ($2s)/g' "${temp_file}"
  perl -p -i -e 's/\d+,([^,]+),Ignored,(\d+)/--- SKIP: $1 ($2s)/g' "${temp_file}"
  perl -p -i -e 's!\((\d+)s\)!sprintf("(%.2fs)", $1/1000)!ge' "${temp_file}"

  cat "${temp_file}"
  rm "${temp_file}"
}
