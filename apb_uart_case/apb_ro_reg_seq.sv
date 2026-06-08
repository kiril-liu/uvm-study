class apb_ro_reg_seq extends uvm_sequence #(apb_item);

  `uvm_object_utils(apb_ro_reg_seq)

	localparam bit [11:2] ID_ADDRS [8] = '{
		10'h0F8,
		10'h0F9,
		10'h0FA,
		10'h0FB,
		10'h0FC,
		10'h0FD,
		10'h0FE,
		10'h0FF
	};
	
	function new(string name = "apb_ro_reg_seq");
    super.new(name);
  endfunction

	task body();
		bit [31:0] before_data;
		bit [31:0] after_data;

		`uvm_info("APB_RO_REG_SEQ",
			"Starting APB RO register test sequence",
			UVM_LOW)

			foreach(ID_ADDRS[i]) begin
				apb_read(ID_ADDRS[i],before_data);
				apb_write(ID_ADDRS[i],32'hFFFF_FFFF);
				apb_read(ID_ADDRS[i],after_data);

				if(after_data !== before_data) begin
					`uvm_error("APB_RO_CHECK",$sformatf(
						"ID register changed after write;paddr = 0x%0h byte_addr=0x%0h before=0x%08h after=0x%08h",ID_ADDRS[i],{ID_ADDRS[i],2'b00},before_data,after_data))
					end
				else begin
						`uvm_info("APB_RO_CHECK",$sformatf("ID register RO check passed:paddr=0x%0h byte_addr=0x%0h value=0x%08h",ID_ADDRS[i],{ID_ADDRS[i],2'b00},before_data),UVM_LOW)
				end
			end

				`uvm_info("APB_RO_REG_SEQ","Finished APB RO register test sequence",UVM_LOW)
	endtask

	task apb_write(bit [11:2]addr,bit [31:0]data);
		apb_item tr;

		tr=apb_item::type_id::create("write_tr");
		start_item(tr);

		tr.dir=apb_item::APB_WRITE;
		tr.addr=addr;
		tr.wdata=data;
		finish_item(tr);

		if(tr.slverr !== 1'b0) begin
			`uvm_error("APB_WRITE",$sformatf("APB write got PSLVERR:paddr =0x%0h byte_addr=0x%0h data=0x%08h",addr,{addr,2'b00},data))
		end
	endtask

	task apb_read(bit [11:2]addr, output bit [31:0]data);

		apb_item tr;

		tr=apb_item::type_id::create("read_tr");
		start_item(tr);

		tr.dir=apb_item::APB_READ;
		tr.addr=addr;
		tr.wdata='0;
		//data=tr.rdata;
		finish_item(tr);
		data=tr.rdata;

		if(tr.slverr !== 1'b0) begin
			`uvm_error("APB_READ",$sformatf("APB read got PSLVERR:paddr =0x%0h byte_addr=0x%0h data=0x%08h",addr,{addr,2'b00},data))
		end
	endtask

endclass
