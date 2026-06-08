class apb_safe_reg_random_test extends apb_uart_base_test;
	`uvm_component_utils(apb_safe_reg_random_test)
	
	function new(string name = "apb_safe_reg_random_test",uvm_component parent = null);
		super.new(name, parent);
	endfunction


	task run_phase(uvm_phase phase);
		apb_safe_reg_random_seq seq;
		
		phase.raise_objection(this);
		`uvm_info("APB_SAFE_RANDOM_TEST","Starting APB safe register random test",UVM_LOW)
		seq = apb_safe_reg_random_seq::type_id::create("seq");

		// 第一版固定 100 笔
		seq.num_iters = 100;
		seq.start(env.apb_agt.sqr);
		`uvm_info("APB_SAFE_RANDOM_TEST","Finished APB safe register random test",UVM_LOW)
		phase.drop_objection(this);
	
	endtask

endclass : apb_safe_reg_random_test

