class uart_tx_basic_seq extends uvm_sequence #(apb_item);
	`uvm_object_utils(uart_tx_basic_seq)
	localparam bit [11:2] TXD_ADDR     = 10'h000; // byte 0x00 write TXD
	localparam bit [11:2] CTRL_ADDR    = 10'h002; // byte 0x08
	localparam bit [11:2] BAUDDIV_ADDR = 10'h004; // byte 0x10
	localparam bit [31:0] CTRL_TXEN    = 32'h0000_0001;
	bit [7:0] tx_data = 8'hA5;
	
	
	function new(string name = "uart_tx_basic_seq");
		super.new(name);
	endfunction

	task body();
		`uvm_info("UART_TX_BASIC_SEQ", $sformatf(
			"Starting UART TX basic sequence, tx_data=0x%02h",
			tx_data
			), UVM_LOW)

			apb_write(BAUDDIV_ADDR,32'd16);

			apb_write(CTRL_ADDR,CTRL_TXEN);
			apb_write(TXD_ADDR,{24'h0,tx_data});
			`uvm_info("UART_TX_BASIC_SEQ",
				"Finished UART TX basic sequence",
				UVM_LOW)
		endtask


	task apb_write(bit [11:2] addr, bit [31:0] data);
		apb_item tr;
		tr = apb_item::type_id::create("write_tr");
		start_item(tr);
		tr.dir   = apb_item::APB_WRITE;
		tr.addr  = addr;
		tr.wdata = data;
		finish_item(tr);
		if (tr.slverr !== 1'b0) begin
			`uvm_error("APB_WRITE", $sformatf(
				"APB write got PSLVERR: paddr=0x%0h byte_addr=0x%0h data=0x%08h",
				addr,
				{addr, 2'b00},
				data))
		end
	endtask

endclass
