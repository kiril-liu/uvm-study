class uart_tx_monitor extends uvm_monitor;

  `uvm_component_utils(uart_tx_monitor)

  virtual uart_interface vif;

  uvm_analysis_port #(uart_item) tx_ap;

  function new(string name = "uart_tx_monitor",
               uvm_component parent = null);
    super.new(name, parent);
    tx_ap = new("tx_ap", this);
  endfunction



	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual uart_interface)::get(this, "", "vif", vif)) begin
			`uvm_fatal("NO_VIF", "Failed to get uart_interface from uvm_config_db")
		end
	endfunction

	task run_phase(uvm_phase phase);
		wait(vif.PRESETn == 1'b1);
		`uvm_info("UART_TX_MON","UART TX monitor started",UVM_LOW)
		forever begin
			collect_tx_frame();
		end
	endtask
	
	task collect_tx_frame();
		uart_item tr;
		bit prev_txd;
		tr=uart_item::type_id::create("tr");

		prev_txd =1'b1;
		forever begin
			@(vif.tx_mon_cb);
			if((prev_txd == 1'b1) && (vif.tx_mon_cb.TXD == 1'b0)) begin
				break;
			end
			prev_txd =vif.tx_mon_cb.TXD;
		end

		
		`uvm_info("UART_TX_MON","Detected UART TX start bit",UVM_HIGH)

		wait_baud_ticks(8);
		tr.start_bit=vif.tx_mon_cb.TXD;
		if(tr.start_bit !== 1'b0) begin
			`uvm_error("UART_TX_MON", $sformatf("Invalid start bit: expected=0 actual=%0b",tr.start_bit))
		end

		for (int i=0;i<8;i++) begin
			wait_baud_ticks(16);
			tr.data[i] = vif.tx_mon_cb.TXD;
		end

		wait_baud_ticks(16);
		tr.stop_bit = vif.tx_mon_cb.TXD;
		tr.stop_ok=(tr.stop_bit==1'b1);
		if(!tr.stop_ok) begin
		
		`uvm_error("UART_TX_MON", $sformatf("Invalid stop bit: expected=1 actual=%0b data=0x%02h",tr.stop_bit,tr.data))
		end


		`uvm_info("UART_TX_MON", $sformatf("UART TX frame received: data=0x%02h start=%0b stop=%0b",
		tr.data,
		tr.start_bit,
		tr.stop_bit), UVM_LOW)
		
		tx_ap.write(tr);
	endtask

	task wait_baud_ticks(int unsigned n);
		int unsigned cnt;
		cnt =0;

		while(cnt <n) begin
			@(vif.tx_mon_cb);
			if(vif.tx_mon_cb.BAUDTICK == 1'b1) begin
				cnt ++;
			end
		end
	endtask

endclass


	
