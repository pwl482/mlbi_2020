#!/bin/bash

set -euo pipefail

ENVNAME="week2_fithic2_env" # Defining environment Folder
SOURCE="$( realpath "${BASH_SOURCE[0]}" )"
SOURCE_DIR="$( dirname "$SOURCE" )"
ENV_SETUP="${SOURCE_DIR}/env_setup"
OLD_WD="$( pwd )"

stop_setup () {
    cd "$OLD_WD"
    unset ENVNAME OLD_WD ENV_SETUP SOURCE SOURCE_DIR
    exit 0
}

remove_faulty_environment () {
	set +eu
	if [ -d "${ENVNAME}" ]; then
		. activate "${ENVNAME}/" || rm -rf ${ENVNAME}
		[ -d "${ENVNAME}" ] && conda deactivate
	fi
	set -eu
}

fallback_environment_setup () {
	echo Conda is not able to do its job properly
	conda install \
    		-c defaults -c anaconda -c conda-forge -c bioconda \
    		networkx numpy=1.14 scipy=1.1 scikit-learn sortedcontainers=2.0 matplotlib=2.2 tabix\
    		-ymp $ENVNAME
	. activate "${ENVNAME}/" && python -m pip install fithic --trusted-host pypi.python.org --trusted-host files.pythonhosted.org
}


fix_strange_python_interpreter_issue () {
	# get possible broken python #! lines
	# they get messed up if there are spaces in the filepath
    set +eu
	grep -R '^#!.*'"${ENVNAME}"'/bin/python.*' ${ENVNAME}/ \
	    |& cut -d':' -f1 | xargs sed -i -e 's;^#!.*/bin/python.*;#!/usr/bin/env python;'
    set -eu
	# grep detects these recursively
	# its output gets piped into cut, which extracts the filename
	# xargs then uses sed on the filenames to fix the shbangs
}

customize_conda_environment () {
	# This sets up the the splash when activating
	APATH="${ENVNAME}/etc/conda/activate.d"
	DPATH="${ENVNAME}/etc/conda/deactivate.d"
	mkdir -p ${APATH}
	mkdir -p ${DPATH}

	cp env_setup/a.welcome.sh env_setup/a.env_vars.sh $APATH
	cp env_setup/d.env_vars.sh $DPATH
}

add_fithc_utility_files_to_env () {
    # This is stuff the authors of fithic forgot to add to their conda
    # recipe.
    echo PULLING FITHIC UTILITIES FROM ITS GIT MASTER BRANCH
    echo STATE APRIL 10 2020
    local FitPath="${ENVNAME}/opt/fithic"
    mkdir -p $FitPath
    cd $FitPath
    if [ -d .git ]; then
        echo already setup as git
    else
        git init
        git remote add -f origin https://github.com/ay-lab/fithic.git
        git config core.sparsecheckout true
        echo fithic/utils >> .git/info/sparse-checkout
    fi
    git pull origin master
    git checkout 0eababa70e0b1ef91f0c38c5ca24f32d555e2fd4
    git am < "${ENV_SETUP}/0001-Ease-of-Use.patch"
    chmod +x fithic/utils/*
    ln -sr fithic/utils/* "${OLD_WD}/${ENVNAME}/bin/."
}

# Actual execution of code happens here
remove_faulty_environment
# installing the Tool and adding necessary conda channels
conda install \
    -c defaults -c anaconda -c conda-forge -c bioconda \
    networkx tabix fithic \
    -ymp $ENVNAME || fallback_environment_setup
fix_strange_python_interpreter_issue
customize_conda_environment
add_fithc_utility_files_to_env
stop_setup
