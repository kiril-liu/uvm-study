class uart_rx_frame_seq extends uvm_sequence #(uart_item);
	`uvm_object_utils(uart_rx_frame_seq)
	
	bit [7:0] rx_data = 8'h5A;
	
	function new(string name = "uart_rx_frame_seq");
		super.new(name);
	endfunction
	
	task body();
		uart_item tr;
		tr = uart_item::type_id::create("rx_frame_tr");
		start_item(tr);
		tr.data      = rx_data;
		tr.start_bit = 1'b0;
		tr.stop_bit  = 1'b1;
		tr.stop_ok   = 1'b1;
		finish_item(tr);
		`uvm_info("UART_RX_FRAME_SEQ", $sformatf(
			"UART RX frame sequence sent: data=0x%02h",
			rx_data
			), UVM_LOW)
	endtask

endclass : uart_rx_frame_seq
