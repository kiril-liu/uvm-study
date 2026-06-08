//Case: apb_reg_smoke_test
//
//Purpose:
//  Check basic APB read/write path.
//
//Steps:
//  1. Write BAUDDIV register with 32'd16.
//  2. Read BAUDDIV register.
//  3. Compare readback value with 20'd16.
//
//Expected:
//  tr.rdata[19:0] == 20'd16
//  UVM_ERROR == 0
//  UVM_FATAL == 0


class apb_reg_smoke_test extends apb_uart_base_test;
	`uvm_component_utils(apb_reg_smoke_test)
	
	function new(string name = "apb_reg_smoke_test",uvm_component parent = null);
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		apb_reg_smoke_seq seq;
		phase.raise_objection(this);

		`uvm_info("REG_SMOKE_TEST", "Starting APB UART register smoke test", UVM_LOW)
		
		seq=apb_reg_smoke_seq::type_id::create("seq");
		seq.start(env.apb_agt.sqr);
		
		`uvm_info("REG_SMOKE_TEST", "APB UART register smoke test finished", UVM_LOW)
		
		phase.drop_objection(this);
	endtask
endclass
