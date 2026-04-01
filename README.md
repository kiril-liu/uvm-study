# uvm_study
UVM Learning Journey
1. Project goals:
    a.32-bit ALU with 4 op-codes non-uvm mini system.(directed-vector,golden model, auto_compare, coverage_collection).
2. Environment:
    Win11,QuestaSim64-10.7c
3. CMDS
    a.Compile:
        vlog +cover=sbceft alu.v tb_directed.sv
    b.Simulate: "-sv_seed 1" seed value; "./alu_seed1.ucdb" coverage file
        vsim -coverage -sv_seed 1 -do "run -all; coverage save -directive -cvg -codeAll ./alu_seed1.ucdb; quit -sim" work.top
    c.Merge coverage files
        vcover merge alu_seed01.ucdb alu_seed0.ucdb alu_seed1.ucdb
    d.Coverage Report:"-htmldir covhtmlseed1" directory of report; "alu_seed01.ucdb" coverage file; open index.html
        vcover report -html -htmldir covhtmlseed1 -source -details -directive -cvg -code bcefst -threshL 50 -threshH 90 alu_seed01.ucdb
4. Notes:
    a.mini system
        The system is used for understanding the fundamental of DUT, generator, scoreboard/golden model, coverage.
