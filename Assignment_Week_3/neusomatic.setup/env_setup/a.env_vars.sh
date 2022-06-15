#!/bin/bash

NEW_PREFIX="tool-env: neusomatic"
export PS1="$(sed "s;""$CONDA_DEFAULT_ENV"";$NEW_PREFIX;g"  <<< $PS1)"
export CONDA_PROMPT_MODIFIER="($NEW_PREFIX) "
export NEUSOMATIC_MODELS="${CONDA_PREFIX}/opt/neusomatic/neusomatic/models"
export NEUSOMATIC_SCRIPTS="${CONDA_PREFIX}/opt/neusomatic/neusomatic/python"
