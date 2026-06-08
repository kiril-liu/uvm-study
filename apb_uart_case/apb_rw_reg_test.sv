class apb_rw_reg_test extends apb_uart_base_test;
	`uvm_component_utils(apb_rw_reg_test)
	
	function new(string name = "apb_rw_reg_test",uvm_component parent = null);
		super.new(name, parent);
	endfunction



	task run_phase(uvm_phase phase);
		apb_rw_reg_seq seq;
		phase.raise_objection(this);
		`uvm_info("APB_RW_REG_TEST",
			"Starting APB RW register test",
			UVM_LOW)
		seq = apb_rw_reg_seq::type_id::create("seq");
		seq.start(env.apb_agt.sqr);
		

		`uvm_info("APB_RW_REG_TEST",
			"Finished APB RW register test",
			UVM_LOW)
			
		phase.drop_objection(this);
	endtask

endclass : apb_rw_reg_test
