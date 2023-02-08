#!/bin/bash
path=$1

series_count=$(tiffcomment $path| grep -c '</image>')
echo "$series_count series found in $path"
echo "Series 0 will be skipped as presumed to be macro image"

START=1
END=$(($series_count-1))

for (( series=$START; series<=$END; series++ ))
do
   source twostep.sh $path $series
done
