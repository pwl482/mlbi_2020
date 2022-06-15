# Assignment Week 5

[[_TOC_]]

## Task
Reproduce the results of the Paper "A comparative evaluation of the generalised predictive ability of eight
machine learning algorithms across ten clinical metabolomics data
sets for binary classifcation" for one of the datasets, using all eight ML methods.

## Dependencies
- a shell with git functionality:
    - either on a unix based System probably preinstalled (Linux/Mac)
    - or a Windows git extension, like using the anaconda prompt to install and run git commands
- python (probably python 3) with:
    - anaconda or another variant of the conda environment manager
    - jupyter notebooks (comes preinstalled with anaconda)

## Installation and Data
- navigate to a directory of choice for installation in the shell
- run the following:

```console
$ git clone https://github.com/cimcb/MetabComparisonBinaryML
$ cd MetabComparisonBinaryML
$ conda env create -f environment.yml
$ conda activate MetabComparisonBinaryML
$ jupyter notebook
```
    
- a conda environment will be set up and all dependencies will be installed, then jupyter notebooks will be opened in the browser
- open the "ComparisonTable.ipynb", there you can select any of the 80 jupyter notebooks to run, one for each classifer and dataset
- to run the automated collection of most important features move [n_most_important_features.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_5/n_most_important_features.ipynb) into the previously created directory "MetabComparisonBinaryML"

## How to run

- for the first run create a folder "results" under "../MetabComparisonBinaryML/notebooks/"
- from all 80 jupyter notebooks visible from the "ComparisonTable.ipynb" table select the notebook links for all the eight notebooks belonging to a dataset
- each notebook will open in an individual tab
- run each notebook individually, the resulting classification values of the p-value of the ManW test, the AUC and the R^2 will be stored in a file in the folder "../MetabComparisonBinaryML/notebooks/results"
- to get the most important features of three classifiers, open the notebook [n_most_important_features.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_5/n_most_important_features.ipynb)
- if the dataset is ST000369 nothing has to be done, in any other case the line "file = 'ST000369.xlsx'" has to be changed to whatever dataset was chosen
- then run the notebook [n_most_important_features.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_5/n_most_important_features.ipynb)


