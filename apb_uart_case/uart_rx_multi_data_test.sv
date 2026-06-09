class uart_rx_multi_data_test extends apb_uart_base_test;

  `uvm_component_utils(uart_rx_multi_data_test)

  localparam bit [11:2] RXD_ADDR     = 10'h000; // byte 0x00 read RXD
  localparam bit [11:2] STAT_ADDR    = 10'h001; // byte 0x04
  localparam bit [11:2] CTRL_ADDR    = 10'h002; // byte 0x08
  localparam bit [11:2] BAUDDIV_ADDR = 10'h004; // byte 0x10

  localparam bit [31:0] CTRL_RXEN    = 32'h0000_0002; // CTRL[1] RX enable

  bit [7:0] rx_patterns[$] = '{
    8'h00,
    8'hFF,
    8'h55,
    8'hAA,
    8'hA5,
    8'h5A,
    8'h01,
    8'h80
  };

  function new(string name = "uart_rx_multi_data_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

	task run_phase(uvm_phase phase);
		uart_rx_frame_seq rx_seq;
		
		bit [31:0] rdata;
		bit [31:0] stat;
		
		phase.raise_objection(this);
		
		`uvm_info("UART_RX_MULTI_TEST",
			"Starting UART RX multi-data test",
			UVM_LOW)
		
		apb_write(BAUDDIV_ADDR, 32'd16);
		apb_write(CTRL_ADDR, CTRL_RXEN);
		
		foreach (rx_patterns[i]) begin

		`uvm_info("UART_RX_MULTI_TEST", $sformatf(
			"Start RX pattern: index=%0d data=0x%02h",
			i,
			rx_patterns[i]
			), UVM_LOW)
		
		rx_seq = uart_rx_frame_seq::type_id::create($sformatf("rx_seq_%0d", i));
		rx_seq.rx_data = rx_patterns[i];
		rx_seq.start(env.uart_agt.rx_sqr);
		
		poll_rx_buf_full();
		apb_read(RXD_ADDR, rdata);

		if (rdata[7:0] !== rx_patterns[i]) begin
		`uvm_error("UART_RX_MULTI_TEST", $sformatf(
			"UART RX data mismatch: index=%0d expected=0x%02h actual=0x%02h raw_rdata=0x%08h",
			i,
			rx_patterns[i],
			rdata[7:0],
			rdata
			))
		end
		else begin
		`uvm_info("UART_RX_MULTI_TEST", $sformatf(
			"UART RX data matched: index=%0d data=0x%02h",
			i,
			rdata[7:0]
			), UVM_LOW)
		end
		
		apb_read(STAT_ADDR, stat);
		if (stat[1] !== 1'b0) begin
		`uvm_error("UART_RX_MULTI_TEST", $sformatf(
			"RX buffer full not cleared after RXD read: index=%0d STAT=0x%08h",
			i,
			stat
			))
		end
		else begin
		`uvm_info("UART_RX_MULTI_TEST", $sformatf(
			"RX buffer full cleared: index=%0d STAT=0x%08h",
			i,
			stat
			), UVM_LOW)
		end
		end
		
		`uvm_info("UART_RX_MULTI_TEST",
			"Finished UART RX multi-data test",
			UVM_LOW)
		phase.drop_objection(this);
	endtask
	
	task apb_write(bit [11:2] addr, bit [31:0] data);
		apb_access_seq seq;
		seq = apb_access_seq::type_id::create("apb_write_seq");
		seq.dir   = apb_item::APB_WRITE;
		seq.addr  = addr;
		seq.wdata = data;
		seq.start(env.apb_agt.sqr);
		if (seq.slverr !== 1'b0) begin
			`uvm_error("APB_WRITE", $sformatf(
				"APB write got PSLVERR: paddr=0x%0h byte_addr=0x%0h data=0x%08h",
				addr,
				{addr, 2'b00},
				data
				))
		end
	endtask
	
	task apb_read(bit [11:2] addr, output bit [31:0] data);
		apb_access_seq seq;
		seq = apb_access_seq::type_id::create("apb_read_seq");
		seq.dir   = apb_item::APB_READ;
		seq.addr  = addr;
		seq.wdata = '0;
		seq.start(env.apb_agt.sqr);
		data = seq.rdata;
		if (seq.slverr !== 1'b0) begin
			`uvm_error("APB_READ", $sformatf(
				"APB read got PSLVERR: paddr=0x%0h byte_addr=0x%0h rdata=0x%08h",
				addr,
				{addr, 2'b00},
				data
				))
		end
	endtask
	
	task poll_rx_buf_full();
		bit [31:0] stat;
		bit        got_full;
		got_full = 1'b0;
		
		repeat (100) begin
			apb_read(STAT_ADDR, stat);
			if (stat[1] == 1'b1) begin
				got_full = 1'b1;
				`uvm_info("UART_RX_MULTI_TEST", $sformatf(
					"RX buffer full detected: STAT=0x%08h",
					stat
					), UVM_LOW)
					break;
			end
		end
			if (!got_full) begin
			`uvm_error("UART_RX_MULTI_TEST",
				"Timeout waiting for RX buffer full STAT[1]")
		end
	endtask


endclass
