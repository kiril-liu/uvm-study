#!/usr/bin/env bash

set -euo pipefail

PROJ=$(pwd)
WORKDIR="$PROJ/sim_work"
FLIST="$PROJ/flist"

TOP="work.tb_top"

TEST="${1:-apb_reg_smoke_test}"
#TEST="apb_reg_smoke_test"

echo "Project folder：$PROJ"
echo "temporary folder: $WORKDIR"
echo "File list: $FLIST"
echo "Top module: $TOP"
echo "Test name: $TEST"


if [[ -z "$WORKDIR" || "$WORKDIR" == "/" ]]; then
	echo "WRONG: WORKDIR access deny: $WORKDIR"
	exit 1
fi

if [[ ! -f "$FLIST" ]]; then
	echo "WRONG: flist not found: $FLIST"
	exit 1
fi


rm -rf "$WORKDIR"

mkdir -p "$WORKDIR"/{logs,cov,waves}

cd "$WORKDIR"


echo "At temporary folder:"
pwd

echo "Floder is ready."

vlib work
vmap work work

echo "QuestaSim work library is ready."

echo "Start compiling..."

vlog -reportprogress 300 -F "$FLIST" -l logs/compile.log

echo "Compile finished."
echo "Compile log: $WORKDIR/logs/compile.log"

echo "Start simulation..."

vsim -c "$TOP"\
	+UVM_TESTNAME="$TEST"\
	-l logs/${TEST}.log\
	-do "run -all;quit -f"

echo "Simulation finished."
echo "Simatation log: $WORKDIR/logs/sim.log"

