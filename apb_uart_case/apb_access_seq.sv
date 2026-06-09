class apb_access_seq extends uvm_sequence #(apb_item);
	`uvm_object_utils(apb_access_seq)
	
	apb_item::apb_dir_e dir;
	
	bit [11:2] addr;
	bit [31:0] wdata;
	bit [31:0] rdata;
	bit        slverr;
	
	function new(string name = "apb_access_seq");
		super.new(name);
	endfunction
	
	task body();
		apb_item tr;
		tr = apb_item::type_id::create("tr");
		start_item(tr);
		tr.dir   = dir;
		tr.addr  = addr;
		tr.wdata = wdata;
		finish_item(tr);
		rdata  = tr.rdata;
		slverr = tr.slverr;
	endtask
endclass : apb_access_seq
