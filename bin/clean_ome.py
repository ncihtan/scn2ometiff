#!/usr/bin/ python

from ome_types import from_xml, to_xml
import sys
from xml.etree import ElementTree as ET


# Read the XML from the first script argument
path = sys.argv[1]
ome = from_xml(path, parser = 'lxml')

# remove structured annotations
ome.structured_annotations = []

# remove acquisition_date from first image
ome.images[0].acquisition_date = None

xml = to_xml(ome)

print(xml)
