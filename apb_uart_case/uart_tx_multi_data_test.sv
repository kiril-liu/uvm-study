class uart_tx_multi_data_test  extends uart_tx_basic_test;
	`uvm_component_utils(uart_tx_multi_data_test )

  bit [7:0] tx_patterns[$] = '{
    8'h00,
    8'hFF,
    8'h55,
    8'hAA,
    8'hA5,
    8'h5A,
    8'h01,
    8'h80
  };	
	

	function new(string name = "uart_tx_multi_data_test",uvm_component parent = null);
    super.new(name, parent);
  endfunction


	task run_phase(uvm_phase phase);
	uart_tx_basic_seq seq;
	phase.raise_objection(this);
		`uvm_info("UART_TX_MULTI_TEST",
			"Starting UART TX multi-data test",
			UVM_LOW)
	env.sb.set_tx_check_enable(1'b1, 1'b1);
	foreach (tx_patterns[i]) begin
		seq = uart_tx_basic_seq::type_id::create($sformatf("seq_%0d", i));
		
		seq.tx_data = tx_patterns[i];
		
		env.sb.expect_tx_data(seq.tx_data);
		
		seq.start(env.apb_agt.sqr);
		env.sb.wait_tx_checked(i + 1);
		
		`uvm_info("UART_TX_MULTI_TEST", $sformatf(
			"UART TX pattern checked: index=%0d data=0x%02h",
			i,
			tx_patterns[i]
			), UVM_LOW)
	end
	
	`uvm_info("UART_TX_MULTI_TEST",
		"Finished UART TX multi-data test",
		UVM_LOW)
	phase.drop_objection(this);

	
	endtask

endclass : uart_tx_multi_data_test
