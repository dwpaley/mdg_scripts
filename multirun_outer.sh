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

command_file=$(mktemp multirun_commands_temp.XXXXXX)

for m in $(cat $run_file); do

  if [ $m == "END" ]; then break; fi

  h5=$MASTER/run_000${m}.JF07T32V01_master.h5
  run_out=$trial_out/$m
  echo "Process $h5"

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

  echo "$SCRIPTS/multirun_inner.sh $root $trial $m $nodes_per_job &" \
    >> $command_file

done

echo "running jobs in $command_file"
module load parallel
cat $command_file > parallel --jobs $n_jobs
rm $command_file
