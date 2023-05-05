#!/bin/bash

MODELSIM_PATH="/c/modeltech64_10.6d/win64"

cd ./sim
echo "Starting simulation"
$MODELSIM_PATH/vsim -do ./modelsim_script.tcl

cd ..