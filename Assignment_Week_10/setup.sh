#!/bin/bash


##create conda environment
echo 'Creating conda environment...'
conda create --name week10 python=3.7 numpy jupyter
conda activate week10
pip install pyopenms
conda deactivate
##download the nescesarry data
echo 'downlaoding data to ./data/' 
[ -d data/ ] ||  mkdir data
cd data
wget -O Class_0_L.zip http://www.cac.science.ru.nl/research/data/ecoli/download-Class_0_L.php
wget -O Class_L_L.zip http://www.cac.science.ru.nl/research/data/ecoli/download-Class_L_L.php
wget -O Class_L_0.zip http://www.cac.science.ru.nl/research/data/ecoli/download-Class_L_0.php
#create directories for different conditions
for ZARC in *.zip
	do
	DIR=${ZARC%.zip}
	mkdir $DIR
	cp $ZARC $DIR
	cd $DIR 
	unzip $ZARC
	cd ..
	rm $ZARC
	done
cd ..
