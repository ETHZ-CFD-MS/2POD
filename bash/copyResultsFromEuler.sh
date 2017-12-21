#!/bin/bash

rsync -avz --include=*/ --include=*.mat --exclude=* $HOME/mnt/scratch_euler/matlab/phosph_decays/* .
