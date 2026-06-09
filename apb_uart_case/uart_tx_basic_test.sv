class uart_tx_basic_test extends apb_uart_base_test;
	
	`uvm_component_utils(uart_tx_basic_test)
	function new(string name = "uart_tx_basic_test",
		uvm_component parent = null);
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		uart_tx_basic_seq seq;

		phase.raise_objection(this);

		`uvm_info("UART_TX_BASIC_TEST",
			"Starting UART TX basic test",
			UVM_LOW)

		env.sb.set_tx_check_enable(1'b1, 1'b1);
		seq=uart_tx_basic_seq::type_id::create("seq");
		seq.tx_data=8'hA5;

		env.sb.expect_tx_data(seq.tx_data);
		seq.start(env.apb_agt.sqr);

		#50000ns;

		`uvm_info("UART_TX_BASIC_TEST",
			"Finished UART TX basic test",
			UVM_LOW)
		phase.drop_objection(this);
	endtask
endclass
