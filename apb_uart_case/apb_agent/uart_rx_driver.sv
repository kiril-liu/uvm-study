class uart_rx_driver extends uvm_driver #(uart_item);
	`uvm_component_utils(uart_rx_driver)
	
	virtual uart_interface vif;
	
	function new(string name = "uart_rx_driver",
		uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	if(!uvm_config_db#(virtual uart_interface)::get(this,"","vif",vif)) begin
		`uvm_fatal("NO_VIF", "Failed to get uart_interface from uvm_config_db")
	end
	endfunction
	
	task run_phase(uvm_phase phase);
		uart_item req;
		reset_bus();
		forever begin
			seq_item_port.get_next_item(req);
			drive_rx_frame(req);
			seq_item_port.item_done();
		end
	endtask
	task reset_bus();
		// UART idle state is 1
		vif.rx_drv_cb.RXD <= 1'b1;
		wait (vif.PRESETn == 1'b1);
			@(vif.rx_drv_cb);
	endtask
	
	task drive_rx_frame(uart_item tr);
			`uvm_info("UART_RX_DRV", $sformatf(
				"Drive UART RX frame: data=0x%02h",
				tr.data
				), UVM_LOW)
		
		vif.rx_drv_cb.RXD <=1'b1;
		wait_baud_ticks(4);
		
		vif.rx_drv_cb.RXD <=1'b0;
		wait_baud_ticks(16);
		
		for(int i=0;i<8;i++)begin
			vif.rx_drv_cb.RXD <= tr.data[i];
			wait_baud_ticks(16);
		end
		
		vif.rx_drv_cb.RXD <=1'b1;
		wait_baud_ticks(16);
		
		vif.rx_drv_cb.RXD <=1'b1;
		
		wait_baud_ticks(4);
			`uvm_info("UART_RX_DRV", $sformatf(
			"Finished UART RX frame: data=0x%02h",
			tr.data
			), UVM_LOW)
	endtask
	
	task wait_baud_ticks(int unsigned n);
		int unsigned cnt;
		cnt = 0;
		while (cnt < n) begin
			@(vif.rx_drv_cb);
			if (vif.rx_drv_cb.BAUDTICK == 1'b1) begin
				cnt++;
			end
		end
	endtask
endclass : uart_rx_driver
