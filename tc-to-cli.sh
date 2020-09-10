#!/bin/bash

function tc-to-cli() {
  local filepath=$1
  local filename=$(basename -- "$filepath")
  local extension="${filename##*.}"
  local filename_without_ext="${filename%.*}"
  local temp_file="${filename_without_ext}_temp.${extension}"

  cp "${filepath}" "${temp_file}"

  sed -i.bak 1d "${temp_file}"

  # pre process
  perl -p -i -e 's/\d+,([^,]+),OK,(\d+)/--- PASS: $1 ($2s)/g' "${temp_file}"
  perl -p -i -e 's/\d+,([^,]+),Failure,(\d+)/--- FAIL: $1 ($2s)/g' "${temp_file}"
  perl -p -i -e 's/\d+,([^,]+),Ignored,(\d+)/--- SKIP: $1 ($2s)/g' "${temp_file}"
  perl -p -i -e 's!\((\d+)s\)!sprintf("(%.2fs)", $1/1000)!ge' "${temp_file}"

  cat "${temp_file}"
  rm "${temp_file}"
}
