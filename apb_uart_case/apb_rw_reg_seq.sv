class apb_rw_reg_seq extends uvm_sequence #(apb_item);

  `uvm_object_utils(apb_rw_reg_seq)

	localparam bit [11:2] CTRL_ADDR			=10'h002;
	localparam bit [11:2] BAUDDIV_ADDR	=10'h004;

	localparam bit [31:0] CTRL_MASK			=32'h0000_007F;
	localparam bit [31:0] BAUDDIV_MASK	=32'h000F_FFFF;

	function new(string name = "apb_rw_reg_seq");
    super.new(name);
  endfunction

	task body();
		`uvm_info("APB_RW_REG_SEQ","Starting APB RW register test sequence",UVM_LOW)

		// ------------------------------------------------------------
		// CTRL register corner values
		// ------------------------------------------------------------
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0000, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0001, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0002, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0003, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0004, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0008, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0010, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0020, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0040, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_007F, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h0000_0080, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'h5555_5555, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'hAAAA_AAAA, CTRL_MASK);
		check_rw_reg("CTRL", CTRL_ADDR, 32'hFFFF_FFFF, CTRL_MASK);
		// ------------------------------------------------------------
		//
		//
		// BAUDDIV register corner values
		// ------------------------------------------------------------
		// Spec says minimum value is 16.
		// So first use legal values >= 16.
		check_rw_reg("BAUDDIV", BAUDDIV_ADDR, 32'd16,        BAUDDIV_MASK);
		check_rw_reg("BAUDDIV", BAUDDIV_ADDR, 32'd17,        BAUDDIV_MASK);
		check_rw_reg("BAUDDIV", BAUDDIV_ADDR, 32'd31,        BAUDDIV_MASK);
		check_rw_reg("BAUDDIV", BAUDDIV_ADDR, 32'd255,       BAUDDIV_MASK);
		check_rw_reg("BAUDDIV", BAUDDIV_ADDR, 32'h0005_5555, BAUDDIV_MASK);
		check_rw_reg("BAUDDIV", BAUDDIV_ADDR, 32'h000A_AAAA, BAUDDIV_MASK);
		check_rw_reg("BAUDDIV", BAUDDIV_ADDR, 32'h000F_FFFF, BAUDDIV_MASK);
		check_rw_reg("BAUDDIV", BAUDDIV_ADDR, 32'hFFFF_FFFF, BAUDDIV_MASK);
		`uvm_info("APB_RW_REG_SEQ","Finished APB RW register test sequence",UVM_LOW)
	endtask


	task apb_write(bit [11:2]addr, bit [31:0]data);
		apb_item tr;
		tr = apb_item::type_id::create("write_tr");
		start_item(tr);

		tr.dir =apb_item::APB_WRITE;

		tr.addr =addr;
		tr.wdata =data;

		finish_item(tr);
		if(tr.slverr !== 1'b0) begin
			`uvm_error("APB_WRITE", $sformatf(
				"APB write got PSLVERR. addr=0x%0h data=0x%0h",
				addr,
				data))
			end
	endtask

	task apb_read(bit [11:2]addr,output bit [31:0]data);
		apb_item tr;
		tr =apb_item::type_id::create("read_tr");
		start_item(tr);
		tr.dir =apb_item::APB_READ;

		tr.addr =addr;
		tr.wdata='0;
		finish_item(tr);

		data=tr.rdata;

		if (tr.slverr !== 1'b0) begin
			`uvm_error("APB_READ", $sformatf(
				"APB read got PSLVERR. addr=0x%0h rdata=0x%0h",
				addr,
				data))
		end
	endtask

	task check_rw_reg(string reg_name,
		bit[11:2] addr,
		bit[31:0] wdata,
		bit[31:0] mask);

		bit [31:0] rdata;
		bit [31:0] expected;
		bit [31:0] actual;

		apb_write(addr,wdata);
		apb_read(addr,rdata);

		expected = wdata&mask;
		actual =rdata&mask;

		if(actual !== expected) begin
			`uvm_error("APB_RW_CHECK",$sformatf(
				"%s mismatch:addr=0x%0h wdata=0x%08h mask=0x%08h expected=0x%08h actual=0x%08h raw_rdata=0x%08h",
					reg_name,
					addr,
					wdata,
					mask,
					expected,
					actual,
					rdata))
		end
		else begin
			`uvm_info("APB_RW_CHECK",$sformatf(
				"%s passed:addr=0x%0h wdata=0x%08h rdata=0x%08h expected=0x%08h",
				reg_name,
				addr,
				wdata,
				rdata,
				expected),
				UVM_LOW)
		end
	endtask
endclass:apb_rw_reg_seq



