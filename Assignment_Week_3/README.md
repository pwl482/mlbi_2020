# Assignment Week 3

[[_TOC_]]

## Task
Reproduce the results of the Paper "Deep convolutional neural networks for accurate
somatic mutation detection" using a real and a synthetic dataset.

## NeuSomatic Software

### Dependencies
python 2.7 with:
- pytorch 0.3.1
- torchvision 0.2.0
- pybedtools 0.7.10
- pysam 0.14.1
- zlib 1.2.11
- numpy 1.14.3
- scipy 1.1.0
- biopython 1.68

additionally:
- cuda80 1.0 (if you want to use GPU)
- tabix 0.2.5
- bedtools 2.27.1
- samtools 1.7

### Docker installation
get the docker image from [here](https://hub.docker.com/r/msahraeian/neusomatic/)

### GitHub installation (did not work for most)
clone https://github.com/bioinform/neusomatic.git
then navigate to neusomatic/bin folder and run ./build.sh

## How to run

### Download the data
- get a hg38 reference genome fasta with index fai file
- get a hg38 genome normal and tumor bam files (from [here](ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/))
- get a hg38 region bed file like [this](https://github.com/bioinform/neusomatic/blob/paper/resources/hg38.bed) 

### Run on real data

### Run on synthetic data (here using the docker image)
- create a folder with the cloned neusomatic git inside (if you installed it)
- place the [synthetic_train.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_3/synthetic_train.sh) and [synthetic_call.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_3/synthetic_call.sh) in there
- clone the somaticseq git in the same folder (from [here](https:://github.com/bioinform/somaticseq.git))
- add a folder "data" containing the reference fasta, the regions bed and the bam file to generate the synthetic set from
- check if the names of the files in data match with the ones in [synthetic_train.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_3/synthetic_train.sh)
- create a synthetic dataset and train a classifier using [synthetic_train.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_3/synthetic_train.sh)
- find the latest training checkpoint in the folder "data/work_train/somecheckpoint.pth"
- change the path of the model in [synthetic_call.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_3/synthetic_call.sh) step 5 --checkpoint like this "/mnt/data/work_train/whatever_the_name_is.pth"
- run the variant calling using the changed [synthetic_call.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_3/synthetic_call.sh)
- analyse the final variant call file under "data/work_call/NeuSomatic.vcf"

