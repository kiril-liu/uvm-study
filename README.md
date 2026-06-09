# Minimal UVM Environment
0->1 UVM

## Setting
Software：QuestaSim

## Intro

### alu_*
The dut is 32-bits 4 op-codes ALU
One of these cases is pure sv,
Another is same function but use UVM,
all UVM component is included

#### Run
Only command line supported.
1. Compile      vlog +cover=sbceft -F flist
2. Simulation   vsim -coverage -sv_seed 1 -do "run -all; coverage save -directive -cvg -codeAll ./alu_seed1.ucdb; quit -sim" work.tb_top
3. Merge        vcover merge alu.ucdb alu_seed0.ucdb alu_seed1.ucdb

### apb_uart
The dut is apb_uart
APB W&R and uart function validation

####  Run
1. use run_sim.sh XXX to run case and check the result at work_sim
2. userun_regression.sh to run regression and check the floder at regression folder.

