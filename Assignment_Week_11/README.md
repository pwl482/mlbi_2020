# Assignment Week 11

[[_TOC_]]

## Task
- Find Metabolomics data e.g  [MTBLS1129](https://www.nature.com/articles/s41598-020-61851-0)
- Extract Features using pyOpenMS
- Do QC & nescessary corrections as shown in [nPYc](https://academic.oup.com/bioinformatics/article/35/24/5359/5539689) tutorial
- Train two ML classifier (if possible not used before) to classify a choosen class
- Evaluate the models and features
- (Optional) compare to results without nPYc quality controle

## Dataset used

## Dependencies
- python3 with
    - conda
    - jupyter notebook
    - pyopenms
    - nPYc
- bash shell

## Get the data
- run the script [week11_download.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_11/week11_download.sh) in a desired directory, to download the MTBLS946 data into a subfolder "./data/"

## How to run
- run the notebooks:
    - [feature_extraction.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_11/feature_extraction.ipynb) for extracting features from mzXML files into featureXML files
    - [feature_preprocessing.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_11/feature_preprocessing.ipynb) for creating a nPYc compatible input and metadata file
    - [Preprocessing_and_QC_nPYc-simple.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_11/Preprocessing_and_QC_nPYc-simple.ipynb) for simply converting the features to ML usable format, or [Preprocessing_and_QC_nPYc.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_11/Preprocessing_and_QC_nPYc.ipynb) for a full quality control (did not work yet)
- the file [MTBLS946_dataset_combinedData.csv](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_11/MTBLS946_dataset_combinedData.csv) contains the ML ready features plus classes
- run the classifier:
    - [VotingClassifier_with_feature_selection.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_11/VotingClassifier_with_feature_selection.ipynb)
    - [RandomForest_with_feature_selection.ipynb](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_11/RandomForest_with_feature_selection.ipynb)