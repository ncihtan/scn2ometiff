#!/bin/bash

path=$1
series=$2
filename=${path%.*}

rm -rf .raw
rm -rf $filename.ome.tiff

echo "Starting to convert $path series $series to  $filename-series$2.ome.tiff"
echo ""

echo "Converting $path series $series to OME-Zarr"
bioformats2raw --series $series $path .raw --progress --target-min-size 512

echo ""
echo "Cleaning up OME-XML"
python clean_ome.py '.raw/OME/METADATA.ome.xml' > '.raw/OME/METADATA_NEW.ome.xml'
rm  '.raw/OME/METADATA.ome.xml'
mv  '.raw/OME/METADATA_NEW.ome.xml' '.raw/OME/METADATA.ome.xml'

echo ""
echo "Converting OME-Zarr to OME-TIFF"

raw2ometiff .raw $filename-series$2.ome.tiff --progress --rgb --compression JPEG

echo ""
echo "Cleaning up intermediate directory"
rm -rf .raw

echo ""
echo "Complete!"
