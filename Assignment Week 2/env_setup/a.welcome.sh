#!/bin/bash



printf "%s\n" \
    "Loaded environment: MLBI-2020 Week 2" \
    "Location: $CONDA_PREFIX"\
    " "\
    "$(conda list |& grep -E '^fithic|^numpy|^python|^scipy|^scikit|^sorted')" \
    " "\
    "This environment is used for testing the FitHiC Tool" \
    "It should also contain utility scripts from the fithic git repository"\
    " "\
    "The are:" \
    "$(ls -A "${CONDA_PREFIX}/opt/fithic/fithic/utils"   || echo NOT FOUND)" \
    " "\
    "And should be added to the path, if they were displayed above ^^^"\
    " "\
    "Enviroment Variables:"\
    " "\
    "UTILITYFOLDER - Custom Environment Variable that points to the FitHIC"\
    "                Utils Folder"
