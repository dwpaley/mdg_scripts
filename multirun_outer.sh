#!/bin/bash

run_file=$1
n_jobs=$2
nodes_per_job=$3
root=$4
trial=$5

MEDHA=$SCRATCH/../medha_dg
SCRIPTS=$MEDHA/scripts
MASTER=$MEDHA/master_flat
RESULTS=$MEDHA/results_batch
PHIL=$MEDHA/phil

mkdir $RESULTS/$root
trial_out=$RESULTS/$root/$trial

if ! [ -e $PHIL/$root.phil ]; then
  echo "Can't find $PHIL/$root.phil. Aborting"
  exit
fi

if ! $(mkdir $trial_out); then
  echo "Directory $trial_out already exists. Aborting"
  exit # TODO: This should be done per run instead
fi


for m in $(cat $run_file); do

  if [ $m == "END" ]; then break; fi

  h5=$MASTER/run_000${m}.JF07T32V01_master.h5
  run_out=$trial_out/$m
  echo "Process $h5"

  # Guard loop: wait until there's an open slot
  while true; do
    n_running=$(jobs | grep multirun_inner | wc -l)
    if [[ $n_running -lt $n_jobs ]]; then break; fi
    sleep 5
  done

  # Skip empty/failed master files, which are generally 15K in size
  if ! [ -e $h5 ]; then
    echo "Warning: file $h5 not found"
    continue
  fi
  size=$(du $h5 |awk '{print $1}')
  if [[ $size -le 20 ]]; then 
    echo "Warning: file $h5 appears corrupt. Skipping"
    continue
  fi

  mkdir $run_out
  mkdir -p $DW_JOB_STRIPED/log/$m
  mkdir -p $DW_JOB_STRIPED/out/$m

  $SCRIPTS/multirun_inner.sh $root $trial $m $nodes_per_job &

done

echo "Monitoring jobs. Press Ctrl-C when no jobs remain."
while true; do # TODO: this really should be able to end itself
  jobs
  n_running=$(jobs | grep multirun_inner | wc -l)
  if [[ $n_running -eq 0 ]]; then break; fi
  sleep 15
done


