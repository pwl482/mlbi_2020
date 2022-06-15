# Assignment Week 8

[[_TOC_]]

## Task
- run PyMethylProcess on one of the datasets mentioned in the paper "Machine learning and clinical epigenetics: a review of challenges for diagnosis and classification", by S.Rauschert, K. Raubenheimer, P. E. Melton and R. C. Huang
- develop two ML classifier for the preprocessed dataset
- run the MethylNet classifier on the preprocessed dataset

## Dataset used
- paper: [Genomic DNA Methylation-Derived Algorithm Enables Accurate Detection of Malignant Prostate Tissues](https://doi.org/10.3389/fonc.2018.00100)
- related GEO page: [GSE112047](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE112047)

## Dependencies
- python3 with
    - conda
    - jupyter notebook
- bash shell
- docker

## How to run

### Preprocessing run
- navigate to a folder of choice and copy the files from this git directory there
- open a bash console and run [install_and_preprocess.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/%20Assignment_Week_8/install_and_preprocess.sh)

```console
$ bash install_and_preprocess.sh
```

### Notebook Postprocessing and Classification
- run [packages.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/%20Assignment_Week_8/packages.sh)

```console
$ bash packages.sh
$ jupyter notebook
```

- open these notebooks for a SVM classifier or a RF classifier:
    - [SVM_with_feature_selection.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/%20Assignment_Week_8/SVM_with_feature_selection.ipynb)
    - [RFC_with_feature_selection.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/%20Assignment_Week_8/RFC_with_feature_selection.ipynb)
- open notebook for feature annotation extraction [feature_analysis.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/%20Assignment_Week_8/feature_analysis.ipynb)
### MethylNet Postprocessing and Classification
- if not still active, activate the conda environment created by packages.sh, then run the methylnet pipeline using methylnet_run.sh:

```console
$ conda activate methyl_r_env
$ bash methylnet_run.sh
```
