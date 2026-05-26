package tb_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	localparam int W = 32;
	`include "alu_item.sv"
	`include "alu_tr.sv"
	`include "basic_seq.sv"
	`include "alu_sequencer.sv"
	`include "alu_driver.sv"
	`include "alu_monitor.sv"
	`include "alu_scoreboard.sv"
	`include "alu_coverage.sv"
	`include "alu_env.sv"	
	`include "base_test.sv"

endpackage
