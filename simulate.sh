#!/bin/bash

cd ./sim
echo "Starting simulation"
vsim -do ./modelsim_script.tcl

cd ..