class apb_safe_reg_random_seq extends uvm_sequence #(apb_item);

  `uvm_object_utils(apb_safe_reg_random_seq)

  localparam bit [11:2] CTRL_ADDR    = 10'h002;
  localparam bit [11:2] BAUDDIV_ADDR = 10'h004;

  localparam bit [31:0] CTRL_MASK    = 32'h0000_007F;
  localparam bit [31:0] BAUDDIV_MASK = 32'h000F_FFFF;

  int unsigned num_iters = 10;

  function new(string name = "apb_safe_reg_random_seq");
    super.new(name);
  endfunction


	task body();
		bit [11:2] rand_addr;
		bit [31:0] rand_wdata;
		bit [31:0] rdata;
		bit [31:0] mask;
		string     reg_name;
		
		`uvm_info("APB_SAFE_RANDOM_SEQ", $sformatf("Starting APB safe register random sequence, num_iters=%0d",num_iters), UVM_LOW)

		repeat (num_iters) begin
		if (!std::randomize(rand_addr, rand_wdata) with 
			{rand_addr inside {CTRL_ADDR, BAUDDIV_ADDR};
			//if (rand_addr == BAUDDIV_ADDR) {
			//	rand_wdata[19:0] inside {[20'd16:20'hF_FFFF]};
			//}
			rand_addr == BAUDDIV_ADDR ->
				rand_wdata[19:0] inside {[20'd16:20'hF_FFFF]};
		}) 
		begin
			`uvm_error("APB_SAFE_RANDOM_SEQ", "Randomization failed")
		end


		if (rand_addr == CTRL_ADDR) begin
			mask     = CTRL_MASK;
			reg_name = "CTRL";
		end
		else begin
			mask     = BAUDDIV_MASK;
			reg_name = "BAUDDIV";
		end

		apb_write(rand_addr, rand_wdata);
		apb_read(rand_addr, rdata);

		if ((rdata & mask) !== (rand_wdata & mask)) begin
			`uvm_error("APB_SAFE_RANDOM_CHECK", $sformatf("%s random RW mismatch: paddr=0x%0h byte_addr=0x%0h wdata=0x%08h rdata=0x%08h mask=0x%08h expected=0x%08h actual=0x%08h",
				reg_name,
				rand_addr,
				{rand_addr, 2'b00},
				rand_wdata,
				rdata,
				mask,
				rand_wdata & mask,
				rdata & mask
				))
		end
		else begin
`uvm_info("APB_SAFE_RANDOM_CHECK", $sformatf("%s random RW passed: paddr=0x%0h byte_addr=0x%0h wdata=0x%08h rdata=0x%08h",
				reg_name,
				rand_addr,
				{rand_addr, 2'b00},
				rand_wdata,
				rdata
				), UVM_LOW)
		end
	end
		`uvm_info("APB_SAFE_RANDOM_SEQ","Finished APB safe register random sequence",UVM_LOW)
	endtask

	task apb_write(bit [11:2]addr, bit [31:0]data);
		apb_item tr;
		tr = apb_item::type_id::create("write_tr");
		start_item(tr);
		tr.dir   = apb_item::APB_WRITE;
		tr.addr  = addr;
		tr.wdata = data;
		finish_item(tr);
		if (tr.slverr !== 1'b0) begin
			`uvm_error("APB_WRITE", $sformatf("APB write got PSLVERR: paddr=0x%0h byte_addr=0x%0h data=0x%08h",
		addr,
		{addr, 2'b00},
		data))
		end
	endtask

	task apb_read(bit [11:2]addr, output bit [31:0]data);
		apb_item tr;
		tr = apb_item::type_id::create("read_tr");
		start_item(tr);
		tr.dir   = apb_item::APB_READ;
		tr.addr  = addr;
		tr.wdata = '0;
		finish_item(tr);
		data = tr.rdata;
		if (tr.slverr !== 1'b0) begin
			`uvm_error("APB_READ", $sformatf("APB read got PSLVERR: paddr=0x%0h byte_addr=0x%0h data=0x%08h",
		addr,
		{addr, 2'b00},
		data))
		end
	endtask
endclass : apb_safe_reg_random_seq

