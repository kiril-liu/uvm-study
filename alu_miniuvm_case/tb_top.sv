`include "uvm_macros.svh"
import uvm_pkg::*;
import tb_pkg::*;

module tb_top;
localparam int W = 32;

	dut_if #(W) vif();
	
	
	alu #(W) u_dut(
		.a(vif.a),
		.b(vif.b),
		.op(vif.op),
		.y(vif.y));

	initial begin
		uvm_config_db#(virtual dut_if#(W))::set(null,"uvm_test_top.*","vif",vif);
		run_test("base_test");
	
	end


endmodule
