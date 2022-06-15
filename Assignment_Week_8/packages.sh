# ----second try using a conda r environment (worked better?)
conda create -n methyl_r_env r-essentials r-base
conda activate methyl_r_env
# ----manual install, or...
pip install git+https://github.com/bodono/scs-python.git@bb45c69ce57b1fbb5ab23e02b30549a7e0b801e3 git+https://github.com/jlevy44/hypopt.git@af59fbed732f5377cda73fdf42f3d4981c2be3ce
pip install pymethylprocess && pymethyl-install_r_dependencies
conda install -c conda-forge hdbscan
conda install -c conda-forge umap-learn
pip install hypopt
conda install -c conda-forge tabulate
conda install -c conda-forge tzlocal
conda install -c bioconda bioconductor-geoquery
conda install pytorch torchvision -c pytorch
pip install methylnet
#for feature analysis
conda install -c r r-biocmanager
