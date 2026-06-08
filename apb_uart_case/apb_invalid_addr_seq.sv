class apb_invalid_addr_seq extends uvm_sequence #(apb_item);

  `uvm_object_utils(apb_invalid_addr_seq)

  localparam bit [11:2] CTRL_ADDR    = 10'h002; // byte 0x08
  localparam bit [11:2] BAUDDIV_ADDR = 10'h004; // byte 0x10

  localparam bit [31:0] CTRL_MASK    = 32'h0000_007F;
  localparam bit [31:0] BAUDDIV_MASK = 32'h000F_FFFF;

  localparam bit [31:0] CTRL_KNOWN_VALUE    = 32'h0000_0055;
  localparam bit [31:0] BAUDDIV_KNOWN_VALUE = 32'h0005_A5A5;

	  localparam bit [11:2] INVALID_ADDRS [8] = '{
    10'h005, // byte 0x014
    10'h006, // byte 0x018
    10'h007, // byte 0x01C
    10'h010, // byte 0x040
    10'h020, // byte 0x080
    10'h080, // byte 0x200
    10'h100, // byte 0x400
    10'h200  // byte 0x800
  };

	function new(string name = "apb_invalid_addr_seq");
    super.new(name);
  endfunction

	task body();
		bit [31:0] rdata;
		bit [31:0] ctrl_after;
		bit [31:0] bauddiv_after;
		
		`uvm_info("APB_INVALID_ADDR_SEQ",
			"Starting APB invalid address test sequence",
			UVM_LOW)


		apb_write(CTRL_ADDR, CTRL_KNOWN_VALUE);
		apb_write(BAUDDIV_ADDR, BAUDDIV_KNOWN_VALUE);

		foreach (INVALID_ADDRS[i]) begin
			apb_read(INVALID_ADDRS[i], rdata);
			if (rdata !== 32'h0000_0000) begin
				`uvm_error("APB_INVALID_READ", $sformatf("Invalid address read returned non-zero: paddr=0x%0h byte_addr=0x%0h rdata=0x%08h",INVALID_ADDRS[i],{INVALID_ADDRS[i], 2'b00},rdata))
			end
			else begin
				`uvm_info("APB_INVALID_READ", $sformatf("Invalid address read returned zero: paddr=0x%0h byte_addr=0x%0h",INVALID_ADDRS[i],{INVALID_ADDRS[i], 2'b00}), UVM_LOW)
			end
		end

		foreach (INVALID_ADDRS[i]) begin
			apb_write(INVALID_ADDRS[i], 32'hFFFF_FFFF);
			apb_write(INVALID_ADDRS[i], 32'hA5A5_5A5A);
			apb_write(INVALID_ADDRS[i], 32'h0000_0000);
		

		apb_read(CTRL_ADDR, ctrl_after);
		apb_read(BAUDDIV_ADDR, bauddiv_after);
		if ((ctrl_after & CTRL_MASK) !== (CTRL_KNOWN_VALUE & CTRL_MASK)) begin
			`uvm_error("APB_INVALID_WRITE", $sformatf("CTRL corrupted after invalid writes: expected=0x%08h actual=0x%08h raw=0x%08h",CTRL_KNOWN_VALUE & CTRL_MASK,ctrl_after & CTRL_MASK,ctrl_after))
		end
		else begin
			`uvm_info("APB_INVALID_WRITE","CTRL not corrupted after invalid writes",UVM_LOW)
		end

		if ((bauddiv_after & BAUDDIV_MASK) !== (BAUDDIV_KNOWN_VALUE & BAUDDIV_MASK)) begin
			`uvm_error("APB_INVALID_WRITE", $sformatf("BAUDDIV corrupted after invalid writes: expected=0x%08h actual=0x%08h raw=0x%08h",BAUDDIV_KNOWN_VALUE & BAUDDIV_MASK,bauddiv_after & BAUDDIV_MASK,bauddiv_after))
		end
		else begin
			`uvm_info("APB_INVALID_WRITE","BAUDDIV not corrupted after invalid writes",UVM_LOW)
		end

	end

		`uvm_info("APB_INVALID_ADDR_SEQ","Finished APB invalid address test sequence",UVM_LOW)
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
			`uvm_error("APB_WRITE", $sformatf("APB write got PSLVERR: paddr=0x%0h byte_addr=0x%0h data=0x%08h", addr,{addr, 2'b00},data))
		end
	endtask

	task apb_read(bit [11:2] addr, output bit [31:0] data);
		apb_item tr;
		tr = apb_item::type_id::create("read_tr");
		start_item(tr);
		tr.dir   = apb_item::APB_READ;
		tr.addr  = addr;
		tr.wdata = '0;
		finish_item(tr);
		data = tr.rdata;
		if (tr.slverr !== 1'b0) begin
			`uvm_error("APB_READ", $sformatf("APB read got PSLVERR: paddr=0x%0h byte_addr=0x%0h data=0x%08h", addr,{addr, 2'b00},data))
		end
	endtask
endclass : apb_invalid_addr_seq
