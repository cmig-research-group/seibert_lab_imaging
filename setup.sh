#!/usr/bin/tcsh

mv .tcshrc ~/
source ~/.tcshrc
mkdir -p ~/Documents/MATLAB
mv startup.m ~/Documents/MATLAB/

cd ../
git clone --depth 1 https://github.com/cmig-research-group/cmig_core_utils.git
git clone --depth 1 https://github.com/cmig-research-group/rsi_pelvis.git



