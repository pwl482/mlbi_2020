# Pull data
wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE68nnn/GSE68086/suppl/GSE68086%5FTEP%5Fdata%5Fmatrix%2Etxt%2Egz
# Download excel file with sig. differential mRNAs
wget https://www.cell.com/cms/10.1016/j.ccell.2015.09.018/attachment/4234d020-b946-4699-bffa-479614929500/mmc3.xlsx

gunzip GSE68086_TEP_data_matrix.txt.gz

# Set up conda environment
conda create --name week7 python=3.7
source activate week7
conda install numpy pandas matplotlib seaborn scikit-learn imbalanced-learn xlrd
pip install jupyter
