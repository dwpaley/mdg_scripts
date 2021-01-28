#!/bin/bash

data_root=$1
m=$2

XFEL=/global/common/software/lcls/nersc-recipies/cctbx-production/modules/cctbx_project/xfel
PROJ=/global/cscratch1/sd/medha_dg
DATA=$PROJ/data/$data_root/data/dark
BEAM=$DATA
GEOM=$PROJ/geom
MASTER=$PROJ/master
DD=163.9

cmd1="libtbx.python $XFEL/swissfel/jf16m_cxigeom2nexus.py \
  unassembled_file=$DATA/run_000${m}.JF07T32V01.h5 \
  geom_file=$GEOM/16M_bernina_backview_optimized_adu_quads.geom \
  detector_distance=$DD \
  include_spectra=True \
  output_file=$MASTER/run_000${m}.JF07T32V01_temp_master.h5 \
  raw=False \
  beam_file=$BEAM/run_000${m}.BSREAD.h5"

cmd2="libtbx.python $XFEL/swissfel/sync_jf16m_geometry.py \
  nexus_master=$MASTER/run_000${m}.JF07T32V01_temp_master.h5 \
  new_geometry=$GEOM/split_0000.expt \
  output_file=$MASTER/run_000${m}.JF07T32V01_master.h5"

echo $cmd1
$cmd1

echo
echo
echo $cmd2
$cmd2

