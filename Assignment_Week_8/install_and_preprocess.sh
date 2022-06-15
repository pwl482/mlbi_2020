# ----docker install
git clone https://github.com/Christensen-Lab-Dartmouth/PyMethylProcess.git
cd PyMethylProcess
sudo bash docker_build.sh
#bash run_docker.sh
sudo docker run --name "week8" -it pymethylprocess
# ----preprocessing
pymethyl-preprocess download_geo -g GSE112047 -o geo_idats/
pymethyl-preprocess create_sample_sheet -is ./geo_idats/GSE112047_clinical_info.csv -s geo -i geo_idats/ -os geo_idats/samplesheet.csv -d "disease state:ch1" -c include_col.txt
mkdir backup_clinical && mv ./geo_idats/GSE112047_clinical_info.csv backup_clinical
pymethyl-preprocess meffil_encode -is geo_idats/samplesheet.csv -os geo_idats/samplesheet.csv
# ----here the process got killed even with 8Gb of RAM:
pymethyl-preprocess preprocess_pipeline -i geo_idats/ -p minfi -noob -qc
pymethyl-preprocess preprocess_pipeline -i geo_idats/ -p minfi -noob -u
# ----another preprocessing run with batch runs and parallel processes
#pymethyl-preprocess split_preprocess_input_by_subtype -i geo_idats/samplesheet.csv
#pymethyl-preprocess batch_deploy_preprocess -n 3 -m -r
#pymethyl-preprocess combine_methylation_arrays -h
# ----following preprocessing steps
pymethyl-utils remove_sex -i preprocess_outputs/methyl_array.pkl
pymethyl-preprocess na_report -i autosomal/methyl_array.pkl -o na_report/
pymethyl-preprocess imputation_pipeline -i ./autosomal/methyl_array.pkl -s fancyimpute -m KNN -k 15 -st 0.05 -ct 0.05
pymethyl-preprocess feature_select -n 300000
pymethyl-utils train_test_val_split -tp .8 -vp .125
exit
sudo docker cp week8:/pymethyl/train_val_test_sets ..
cd ..
echo "train/test/val split created!"
