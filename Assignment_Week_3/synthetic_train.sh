#!/usr/bin/env bash
# Step 1: generate synthetic tumor and normal sample
echo "Step 1: generate synthetic tumor and normal sample"
sudo somaticseq/utilities/dockered_pipelines/bamSimulator/BamSimulator_singleThread.sh \
--output-dir data/trainingSet \
--genome-reference data/hg38.fa \
--tumor-bam-in data/HG003.mate_pair.sorted.bam \
--tumor-bam-out syntheticTumor.bam \
--normal-bam-out syntheticNormal.bam \
--split-proportion 0.5 \
--min-variant-reads 2 \
--num-snvs 10000 --num-indels 8000 --num-svs 1500 \
--min-vaf 0.0 --max-vaf 1.0 --left-beta 2 --right-beta 5 \
--split-bam
# Step 2: preprocess for training
echo "Step 2: preprocess for training"
test_dir=$(pwd)/data
docker run -v ${test_dir}:/mnt/data --memory 30G  msahraeian/neusomatic:0.2.1 /bin/bash -c \
"python /opt/neusomatic/neusomatic/python/preprocess.py \
	--mode train \
	--reference /mnt/data/hg38.fa \
	--region_bed /mnt/data/hg38.bed \
	--tumor_bam /mnt/data/trainingSet/syntheticTumor.bam \
	--normal_bam /mnt/data/trainingSet/syntheticNormal.bam \
	--work /mnt/data/work_train \
	--min_mapq 10 \
	--num_threads 1 \
	--scan_alignments_binary /opt/neusomatic/neusomatic/bin/scan_alignments"
# Step 3: run the training
echo "Step 3: run the training"
docker run -v ${test_dir}:/mnt/data --memory 30G --shm-size 8G msahraeian/neusomatic:0.2.1 /bin/bash -c \
"CUDA_VISIBLE_DEVICES= python /opt/neusomatic/neusomatic/python/train.py \
	--candidates_tsv /mnt/data/work_train/dataset/*/candidates*.tsv \
	--reference /mnt/data/hg38.fa \
	--out /mnt/data/work_train \
	--checkpoint /opt/neusomatic/neusomatic/models/NeuSomatic_v0.1.0_standalone_Dream3_70purity.pth \
	--num_threads 1 \
	--batch_size 100"

