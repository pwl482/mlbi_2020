#!/bin/bash



printf "%s\n" \
    "Neusomatic Tool for varient calling" \
    "Location: $CONDA_PREFIX"\
    " "\
    "$(conda list |& grep -E '^gxx|^gcc|^perl\s|^python|biopython|cmake|scipy')" \
    " "\
    "This environment is used to build and run neusomatic " \
    " "\
    "Pretrained Models are found in folder associated with Environment Variable" \
    "   NEUSOMATIC_MODELS"\
    "Neosomatic Python Scripts are found in:"\
    "   NEUSOMATIC_SCRIPTS"
