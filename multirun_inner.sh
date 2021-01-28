#!/bin/bash

MEDHA=$SCRATCH/../medha_dg
SCRIPTS=$MEDHA/scripts
MASTER=$MEDHA/master_flat
RESULTS=$MEDHA/results_batch
PHIL=$MEDHA/phil


root=$1
trial=$2
m=$3
nodes_per_job=$4

mkdir -p $DW_JOB_STRIPED/$m/log
mkdir -p $DW_JOB_STRIPED/$m/out

let ntasks=$nodes_per_job*32
#srun -N $nodes_per_job -n $ntasks shifter $SCRIPTS/multirun_srun.sh $root $trial $m
srun -N $nodes_per_job -n $ntasks $SCRIPTS/multirun_srun.sh $root $trial $m > $m.srunlog 2> $m.srunerr

echo "moving files for $m"

#mv $DW_JOB_STRIPED/$m $RESULTS/$root/$trial/

echo "done with $m"

