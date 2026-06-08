class apb_reg_smoke_seq extends uvm_sequence #(apb_item);

  `uvm_object_utils(apb_reg_smoke_seq)

  function new(string name = "apb_reg_smoke_seq");
    super.new(name);
  endfunction

	task body();
		apb_item tr;

		tr=apb_item::type_id::create("write_bauddiv_tr");

		start_item(tr);

		tr.dir	=apb_item::APB_WRITE;
		tr.addr	=10'h004;
		tr.wdata=32'd16;

		finish_item(tr);

		`uvm_info("REG_SMOKE_SEQ","WRITE BAUDDIV = 16 done",UVM_MEDIUM)

		tr=apb_item::type_id::create("read_bauddiv_tr");

		start_item(tr);
		tr.dir	=apb_item::APB_READ;
		tr.addr =10'h004;
		tr.wdata='0;
		finish_item(tr);

		`uvm_info("REG_SMOKE_SEQ",$sformatf("Read BAUDDIV = 0x%0h",tr.rdata),UVM_MEDIUM);

		if(tr.rdata[19:0] != 20'd16) begin
			`uvm_error("REG_SMOKE_SEQ", $sformatf("BAUDDIV readback mismatch: expect=0x%0h actual=0x%0h",20'd16,tr.rdata[19:0]))
		end
		else begin
			`uvm_info("REG_SMOKE_SEQ", "BAUDDIV readback check passed", UVM_LOW)
		end

	endtask
endclass

