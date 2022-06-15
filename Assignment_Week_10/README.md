# Assignment Week 8

[[_TOC_]]

## Task
- Use read in data from "A comprehensive full factorial LC-MS/MS proteomics benchmark data set" by Wessels et al. Using [pyOpenMS](https://pyopenms.readthedocs.io/en/latest/getting_started.html)
- select two groups from dataset
- Use the pyOpenMS(FeatureFinder algorithm) to extract features from raw spectra
- Bin the extracted features
- Use the Tidy Data Framework (week 5) as structure for pre-processed data
- train two classifiers that where not used before.

## Dataset used
- [Wessels et al.](http://www.cac.science.ru.nl/research/data/ecoli/)

## Dependencies
- python3 with
    - conda
    - jupyter notebook
    - pyopenms
- bash shell

## How to run

### Setup
- navigate to a folder of choice and copy the files from this git directory there
- open a bash console and run [setup.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_10/setup.sh) (this will setup a conda environment with the nescessary dependencies and download the MS raw data in mzXML files.)
```console
$ bash setup.sh
```
### Feature finding
- to find features in the raw mzXML files activat conda env and run the jupyter notebook [feature_extraction.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_10/feature_extraction.ipynb)
```console
$ conda activate week10
$ jupyter notebook
```
### Feature processing and binning
- run [feature_preprocessing.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_10/feature_preprocessing.ipynb) from jupyter notebooks

### Classification
- run these two notebooks for the classification:
    - [AdaBoost_with_feature_selection.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_10/AdaBoost_with_feature_selection.ipynb)
    - [GradientBoost_with_feature_selection.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_10/GradientBoost_with_feature_selection.ipynb)
