#!/bin/bash

function usage
{
    echo "usage: $0 <input> <from line> <output>"
    echo "<input>: ports csv file"
    echo "<output>: geocoded csv file"
    echo "<from line>: read input from line, default 2"
}

# check arguments count:
if [ $# -lt 3 ]; then
    usage; exit 1
fi

input="$1"
fromLine=${2-2}
output=$3

currentLine=$fromLine
IFS=$'\n'     # new field separator, the end of line
for line in $(tail -n +$fromLine $input)
do
  geocodedLine=$(node ./geojs/index.js $line)
  rc=$?; if [[ $rc != 0 ]]; then echo 'ERROR: '$geocodedLine; exit $rc; fi
  echo -e $currentLine')\t'$line' -> \n\t'$geocodedLine
  echo $geocodedLine >> $output
  currentLine=$((currentLine+1))
done
