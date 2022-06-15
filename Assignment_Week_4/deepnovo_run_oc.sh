#!/bin/sh
cd DeepNovo-DIA

# run deepnovo on ovarian cyst data
echo RUNNING DEEPNOVO ON OC DATA
chmod +x deepnovo_main
./deepnovo_main --search_denovo --train_dir train.urine_pain.ioncnn.lstm --denovo_spectrum oc/testing_oc.spectrum.mgf --denovo_feature oc/testing_oc.feature.csv

# test results on labeled features
echo EVALUATING PREDICTION
./deepnovo_main --test --target_file oc/testing_oc.feature.csv --predicted_file oc/testing_oc.feature.csv.deepnovo_denovo