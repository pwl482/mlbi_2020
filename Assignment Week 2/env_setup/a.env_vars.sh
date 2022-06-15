#!/bin/bash

NEW_PREFIX="MLBI2020: Week 2 - FitHiC2"
export PS1="$(sed "s;""$CONDA_DEFAULT_ENV"";$NEW_PREFIX;g"  <<< $PS1)"
export CONDA_PROMPT_MODIFIER="($NEW_PREFIX) "
export UTILITYFOLDER="${CONDA_PREFIX}/opt/fithic/fithic/utils/"
