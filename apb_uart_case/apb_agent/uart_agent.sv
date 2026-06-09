class uart_agent extends uvm_agent;
	`uvm_component_utils(uart_agent)
	
	uart_tx_monitor tx_mon;
	uart_sequencer  rx_sqr;
	uart_rx_driver  rx_drv;

	function new(string name = "uart_agent",uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);

		super.build_phase(phase);

		tx_mon=uart_tx_monitor::type_id::create("tx_mon",this);


		// RX side is active
		if (is_active == UVM_ACTIVE) begin
			rx_sqr = uart_sequencer ::type_id::create("rx_sqr", this);
			rx_drv = uart_rx_driver ::type_id::create("rx_drv", this);
		end

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if (is_active == UVM_ACTIVE) begin
			rx_drv.seq_item_port.connect(rx_sqr.seq_item_export);
		end
	endfunction

endclass
