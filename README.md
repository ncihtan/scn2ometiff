# Converting Leica Versa SCN files to OME-TIFF

The following scripts help in the conversion of SCN files from Leica Versa slide scanners to OME-TIFF images that are tiled, pyramidal and contain a single scene. It also removes additional metadata from the OME-XML (acquisition data and strutured annotations) to ensure that files are de-identified.

The first series in a SCN file is (usually) the macro image. Conversion of this is skipped.  All other scenes are output to individual OME-TIFF files.

JPEG compression us used but this could be changed in `twosteps.sh`

## Requirements

- `bioformats2raw>=0.5` - this is in thr `ome` Anaconda channel but not for arm-64. If on a Apple Silicon Mac you may need to specify a x86 conda env or install from Github
- `raw2ometiff>=0.4` - this is not on the `ome` Anaconda channel yet so will need to be installed from Github and added to your path.
- `Python >=3.7`
- `ome_types` - Installable on pip

## Usage

If `input.scn` contains 3 series of which the first is a macro image

```
bash convert_scn.sh input.scn
```

Outputs:
- `inputs-scene1.ome.tiff`
- `inputs-scene2.ome.tiff`


## Nextflow usage

There is also a Nextflow pipeline for reproducible and contanarised conversion of scn files

To convert all `.scn` files in the `input` directory and output into the `output` directory run:

```
nextflow run adamjtaylor/scn2ometiff -r nf --input input/*.scn --output output
```
