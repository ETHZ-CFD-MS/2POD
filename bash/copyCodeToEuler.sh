#!/bin/bash

rsync -avz --include=*/ --include=*.m --include=*.sh --exclude=* ./* $HOME/mnt/scratch_euler/matlab/phosph_decays
