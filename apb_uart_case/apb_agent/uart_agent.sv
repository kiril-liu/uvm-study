class uart_agent extends uvm_agent;
	`uvm_component_utils(uart_agent)
	
	uart_tx_monitor tx_mon;
	function new(string name = "uart_agent",uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);

		super.build_phase(phase);

		tx_mon=uart_tx_monitor::type_id::create("tx_mon",this);
	endfunction

endclass
