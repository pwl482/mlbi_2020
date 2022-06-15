#!/bin/bash
# clone deepnovo repository
echo PULLING DEEPNOVO
[ -d DeepNovo-DIA/ ] || git clone https://github.com/nh2tran/DeepNovo-DIA

# get knapsack matrix
mv knapsack.npy DeepNovo-DIA/.
cd DeepNovo-DIA

# download test data
echo PULLING OC DATA
wget -r -nH --cut-dirs=2 ftp://anonymous@massive.ucsd.edu/MSV000082368/other/oc/testing_oc.spectrum.mgf
wget -r -nH --cut-dirs=2 ftp://anonymous@massive.ucsd.edu/MSV000082368/other/oc/testing_oc.feature.csv
wget -r -nH --cut-dirs=2 ftp://anonymous@massive.ucsd.edu/MSV000082368/other/train.urine_pain.ioncnn.lstm/