# Assignment Week 2

[[_TOC_]]

Reproduce results of Paper



## Resources

Data: [Submitted_Data_FitHiC2.zip](https://zenodo.org/record/3380589/files/Submitted_Data_FitHiC2.zip?download=1)

## FitHIC2 Software

### Dependencies
For most scripts:
- python3, python2 with numpy, scipy, matplotlib, sortedcontainers, scikit-learn
- bash shell

For converting to Epigenome Browser Input:
- htslib [here](www.htslib.org/download), using the following two functions:
    - bgzip
    - tabix

### GitHub Installation (easiest)
    $ cd path/to/where/the/utilities/should/be/saved
    $ git clone https://github.com/ay-lab/fithic.git


### Conda Installation (needs supporting utilities separately)

See Wiki for conda setup [here](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/wikis/Home#setting-up-conda)

`conda install -c bioconda fithic`

Alternatively You can navigate to this folder and run the env_setup.sh script
Requirement is running a bash terminal on a linux flavor 


    $ cd path/2/this/folder
    $ bash setup_env.sh
    $ . activate week1_fithic2_env/ 
    
![CondaEnvironment](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/wikis/uploads/ab39b0154eee584659b1fef009b7b8c3/CondaEnvironment.png)

needs the supporting utilities separately:
https://pypi.org/project/fithic/#files


### Pip Installation (needs supporting utilities separately)

`pip install fithic`

needs the supporting utilities separately:
https://pypi.org/project/fithic/#files

## How to run

### Download the data
    $ cd path/to/where/the/data/should/be/stored
    $ wget http://fithic.lji.org/fithic_protocol_data.tar.gz
    $ tar -xvzf fithic_protocol_data.tar.gz

### Set up Variables
If you did not stay in the same folder as in the last step:

    $ cd path/to/where/the/data/is/stored
Then run:

    $ cd fithic_protocol_data/data
    $ DATADIR=$(pwd)
Now navigate to the folder where the fithic utilities or git repository are stored:

    $ cd
    $ cd path/to/where/the/utilities-or-git/are/stored
    $ cd fithic/fithic
    $ FITHICDIR=$(pwd)
    $ export DATADIR
    $ export FITHICDIR

The FITHICDIR path should contain the "utils" folder, where all of the
additional fithic utilities are stored.
The DATADIR should contain the following folders:
- validPairs
- fithicOutput
- biasValues
- referenceGenomes
- contactCounts
- fragmentMappability

### Run the preprocessing
For preprocessing run this file
- [run_preprocessing.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment%20Week%202/run_preprocessing.sh)

Run the file like this:

    $ cd to/where/the/script/is/saved
    $ ./run_preprocessing.sh

### Run the use case for the set Rao_GM12878-primary-chr5_5kb

For evaluating the test set Rao_GM12878-primary-chr5_5kb run:
- [run_Rao_GM12878-primary-chr5_5kb.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment%20Week%202/run_Rao_GM12878-primary-chr5_5kb.sh)

Run the file like this:

    $ cd to/where/the/script/is/saved
    $ ./run_Rao_GM12878-primary-chr5_5kb.sh

### Prepare the test set for viewing in the genome browser run:
- [run_epigen_browser_transform_Rao.sh](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment%20Week%202/run_epigen_browser_transform_Rao.sh)

Run the file like this:


    $ cd to/where/the/script/is/saved
    $ ./run_epigen_browser_transform_Rao.sh


The output is visualized in the Epigenome Browser in this image:
- ![EpigenomeBrowser](https://git.imp.fu-berlin.de/pvjet86/mlbi-2020/-/blob/master/Assignment%20Week%202/washu_browser_example.png)

