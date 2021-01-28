#!/bin/bash

MEDHA=$SCRATCH/../medha_dg
SCRIPTS=$MEDHA/scripts
MASTER=$MEDHA/master_flat
RESULTS=$MEDHA/results_batch
PHIL=$MEDHA/phil

root=$1
trial=$2
m=$3

#source /img/activate.sh
source /global/common/software/m3562/dials/build/conda_setpaths.sh
export HDF5_USE_FILE_LOCKING=FALSE


dials.stills_process \
  $PHIL/$root.phil \
  $MASTER/run_000${m}.JF07T32V01_master.h5 \
  mp.method=mpi \
  output.output_dir=$DW_JOB_STRIPED/$m/out \
  output.logging_dir=$DW_JOB_STRIPED/$m/log \
  > $DW_JOB_STRIPED/$m/log/stdout.log \
  2> $DW_JOB_STRIPED/$m/log/stderr.log \
  dispatch.process_percent=3
