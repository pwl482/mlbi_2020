#!/usr/bin/env bash
test_dir=$(pwd)/data
# Step 4: preprocess for calling
echo "Step 4: preprocess for calling"
docker run -v ${test_dir}:/mnt/data --memory 30G  msahraeian/neusomatic:0.2.1 /bin/bash -c \
"python /opt/neusomatic/neusomatic/python/preprocess.py \
	--mode call \
	--reference /mnt/data/hg38.fa \
	--region_bed /mnt/data/hg38.bed \
	--tumor_bam /mnt/data/trainingSet/syntheticTumor.bam \
	--normal_bam /mnt/data/trainingSet/syntheticNormal.bam \
	--work /mnt/data/work_call \
	--min_mapq 10 \
	--num_threads 1 \
	--scan_alignments_binary /opt/neusomatic/neusomatic/bin/scan_alignments"
# Step 5: run the calling
echo "Step 5: run the calling"
docker run -v ${test_dir}:/mnt/data --memory 30G --shm-size 8G msahraeian/neusomatic:0.2.1 /bin/bash -c \
"CUDA_VISIBLE_DEVICES= python /opt/neusomatic/neusomatic/python/call.py \
		--candidates_tsv /mnt/data/work_call/dataset/*/candidates*.tsv \
		--reference /mnt/data/hg38.fa \
		--out /mnt/data/work_call \
		--checkpoint /mnt/data/work_train/some_checkpoint.pth \
		--num_threads 1 \
		--batch_size 100"
# Step 6: postprocessing for calling
echo "Step 6: postprocessing for calling"
docker run -v ${test_dir}:/mnt/data --memory 30G  msahraeian/neusomatic:0.2.1 /bin/bash -c \
"python /opt/neusomatic/neusomatic/python/postprocess.py \
		--reference /mnt/data/hg38.fa \
		--tumor_bam /mnt/data/trainingSet/syntheticTumor.bam \
		--pred_vcf /mnt/data/work_call/pred.vcf \
		--candidates_vcf /mnt/data/work_call/work_tumor/filtered_candidates.vcf \
		--output_vcf /mnt/data/work_call/NeuSomatic.vcf \
		--work /mnt/data/work_call "

