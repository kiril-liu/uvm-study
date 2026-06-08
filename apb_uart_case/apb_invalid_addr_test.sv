class apb_invalid_addr_test extends apb_uart_base_test;
	
	`uvm_component_utils(apb_invalid_addr_test)
	
	function new(string name = "apb_invalid_addr_test",uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	task run_phase(uvm_phase phase);
		apb_invalid_addr_seq seq;
		
		phase.raise_objection(this);
		`uvm_info("APB_INVALID_ADDR_TEST","Starting APB invalid address test",UVM_LOW)
		seq = apb_invalid_addr_seq::type_id::create("seq");
		
		seq.start(env.apb_agt.sqr);
		`uvm_info("APB_INVALID_ADDR_TEST","Finished APB invalid address test",UVM_LOW)
		
		phase.drop_objection(this);
	
	endtask
endclass : apb_invalid_addr_test
