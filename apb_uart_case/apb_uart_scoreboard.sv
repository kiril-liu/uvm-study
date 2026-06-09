class apb_uart_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_uart_scoreboard)

  uvm_analysis_imp #(uart_item, apb_uart_scoreboard) tx_imp;

	bit tx_check_enable;
	bit tx_check_required;
  bit [7:0] exp_tx_q[$];

  int unsigned tx_check_count;
	event tx_checked_e;

  function new(string name = "apb_uart_scoreboard",
               uvm_component parent = null);
    super.new(name, parent);

    tx_imp = new("tx_imp", this);

		tx_check_enable = 1'b0;
		tx_check_required=1'b0;

  endfunction

	function void write(uart_item tr);

		bit[7:0] exp_data;


		if (!tx_check_enable) begin
			`uvm_info("UART_TX_SB", $sformatf(
				"Ignore UART TX item because TX check is disabled: actual=0x%02h",
				tr.data
				), UVM_HIGH)
				return;
		end

		if(exp_tx_q.size() ==0)begin
			`uvm_error("UART_TX_SB", $sformatf(
				"Unexpected UART TX item: actual=0x%02h, no expected data in queue",
				tr.data
			))
			return;
		end

		exp_data = exp_tx_q.pop_front();
		if(tr.data !== exp_data) begin
			`uvm_error("UART_TX_SB", $sformatf(
				"UART TX data mismatch: expected=0x%02h actual=0x%02h start=%0b stop=%0b",
				exp_data,
				tr.data,
				tr.start_bit,
				tr.stop_bit
			))
		end
		else begin
			tx_check_count++;
			`uvm_info("UART_TX_SB", $sformatf(
				"UART TX data matched: data=0x%02h check_count=%0d",
				tr.data,
				tx_check_count
			), UVM_LOW)

			-> tx_checked_e;
		end
	endfunction

	function void set_tx_check_enable(bit enable,
	
		bit required = 1'b1);
		tx_check_enable   = enable;
		tx_check_required = required;
		
		`uvm_info("UART_TX_SB", $sformatf(
			"TX scoreboard config: enable=%0b required=%0b",
			tx_check_enable,
			tx_check_required
			), UVM_LOW)
	endfunction

	function void expect_tx_data(bit [7:0]data);

		if (!tx_check_enable) begin
			`uvm_warning("UART_TX_SB",
				"expect_tx_data called while tx_check_enable=0")
		end

		exp_tx_q.push_back(data);
		`uvm_info("UART_TX_SB", $sformatf(
			"Push expected UART TX data: 0x%02h queue_size=%0d",
			data,
			exp_tx_q.size()
		), UVM_LOW)
	endfunction

	function void check_phase(uvm_phase phase);
		super.check_phase(phase);

		if (tx_check_enable) begin
			if(exp_tx_q.size()!=0)begin
				`uvm_error("UART_TX_SB", $sformatf(
					"UART TX expected queue not empty: remaining=%0d",
					exp_tx_q.size()
				))
			end

			if(tx_check_count == 0)begin
				`uvm_error("UART_TX_SB",
					"No UART TX item was checked")
			end
		end
	endfunction

	task wait_tx_checked(int unsigned target_count);
		while (tx_check_count < target_count) begin
			@tx_checked_e;
		end
	endtask

endclass


