#!/bin/bash

set -eEuo pipefail

ENVNAME="neusomatic_env"
SOURCE="$( realpath "${BASH_SOURCE[0]}" )"
SOURCE_DIR="$( dirname "$SOURCE" )"
ENV_SETUP="${SOURCE_DIR}/env_setup"
OUTDIR=${1-.}
CONDA_ACTIVATE="$(which activate)"
ENVPATH="$(realpath "${OUTDIR}/${ENVNAME}")"
APATH="${ENVPATH}/etc/conda/activate.d"
DPATH="${ENVPATH}/etc/conda/deactivate.d"
CONDA_ACTIVE=0

stop_setup(){

    while [ $CONDA_ACTIVE -gt 0 ]; do
        deactivate_conda
    done

    unset ENVNAME SOURCE SOURCE_DIR ENV_SETUP OUTDIR ENVPATH APATH DPATH
    unset CONDA_ACTIVE CONDA_ACTIVATE
    exit 0
}

activate_conda(){
    echo $@
    set +ue
    source "$CONDA_ACTIVATE" "$@"
    set -ue
    CONDA_ACTIVE=$((CONDA_ACTIVE+1))
    echo CONDA ENVIRONMENTS "$CONDA_ACTIVE"
}

deactivate_conda(){
    set +ue
    conda deactivate
    set -ue
    CONDA_ACTIVE=$((CONDA_ACTIVE-1))
    echo ACTIVE CONDA ENVIRONMENTS $CONDA_ACTIVE
}

conda_env_install(){
    conda install \
        -c defaults -c conda-forge -c pytorch -c bioconda \
        zlib=1.2.* \
        numpy=1.* \
        scipy=1.2.* \
        pytorch=0.* \
        torchvision=0.* \
        imageio=2.5.* \
        cuda80=1.0 \
        cmake=3.12.1 \
        pysam=0.14.* \
        pybedtools=0.7.* \
        samtools=1.* \
        tabix=0.2.* \
        bedtools=2.* \
        biopython=1.* \
        gxx_linux-64=5.4.0 \
        gcc_linux-64=5.4.0 \
        -ymp "${ENVPATH}"
}

setup_env(){
    mkdir -p "${APATH}"
    mkdir -p "${DPATH}"

    cp "${ENV_SETUP}/a.welcome.sh" "${ENV_SETUP}/a.env_vars.sh" "${APATH}"
    cp "${ENV_SETUP}/d.env_vars.sh" "${DPATH}"
}
# Customization

get_neusomatic_and_install () {
    # This is stuff the authors of fithic forgot to add to their conda
    # recipe.
    echo PULLING NEUSOMATIC
    echo STATE: TAG VERSION 0.2.1
    local OptPath="${ENVPATH}/opt"
    mkdir -p "$OptPath"
    cd "${OptPath}"
    [ -d neusomatic/.git ] ||  git clone --branch "v0.2.1" https://github.com/bioinform/neusomatic
    cd neusomatic
    activate_conda "${ENVPATH}/"
    local CMAKE_CXX_COMPILER="$CXX"
    local LD_LIBRARY_PATH="${ENVPATH}/lib:$LD_LIBRARY_PATH"
    [ -f neusomatic/bin/scan_alignments ] || bash build.sh
    deactivate_conda
    [ -f "${ENVPATH}/bin/scan_alignments" ] ||  ln -sr  neusomatic/bin/* "${ENVPATH}/bin/"
}

conda_env_install
setup_env
get_neusomatic_and_install
stop_setup
