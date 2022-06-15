# Assignment Week 4

[[_TOC_]]

## Task
Reproduce the results of the Paper "Deep learning enables de novo peptide sequencing 
from data-independent-acquisition mass spectrometry" using a real and an optional synthetic dataset.

## DeepNovo-DIA Software

### Dependencies
- unix based operating system
- everything else comes packed with the executable deepnovo_main

### Installation and Data (for the oc dataset)
- navigate to a folder of choice for installation
- clone this repository: git clone https://git.imp.fu-berlin.de/pvjet86/mlbi-2020.git
- navigate to mlbi-2020/Assignment_Week_4/
- run: bash [deepnovo_setup.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_4/deepnovo_setup.sh)

## How to run

### Run on real data
- run: bash [deepnovo_run_oc.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_4/deepnovo_run_oc.sh)
- The file with extension .accuracy shows the comparison result for each feature.

### Run Blast on 3 samples from the real data
Run either the script to blast three samples:
- Requirements: Python 3 with "biopython", "pandas", "re" installed
- put [blast_predicted.py](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_4/blast_predicted.py) in the folder above the created DeepNovo-DIA folder
- the blast query and the results visualisation of the created xml file can be toggled individually with two flags in the script (default: both True)
- run with: 
    
    $ python blast_predicted.py

or manually blast:
- open the file [blast_predicted.fasta](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_4/blast_predicted.fasta)
- open the [protein BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE=Proteins) website
- copy [blast_predicted.fasta](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment_Week_4/blast_predicted.fasta) into the field: "Enter accession number(s), gi(s), or FASTA sequence(s)"
- set the databade to: non-redundant protein sequences (nr)
- select the organism: human (taxid:9606)
- click the blue "BLAST" to run
- select the three different sequences from: "Results for"


Then you get the following output:
- the results with best E-value and query-covery are:
    - sequence 0: isotopes of kininogen 1
    - sequence 1: alpha chain of Amylase
    - sequence 2: apolipoprotein D

### Run on synthetic data


