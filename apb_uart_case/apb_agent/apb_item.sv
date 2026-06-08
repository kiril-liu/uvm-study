class apb_item extends uvm_sequence_item;
	typedef enum bit{
		APB_READ=1'b0,
		APB_WRITE=1'b1
		} apb_dir_e;

	rand apb_dir_e dir;
	rand bit [11:2] addr;
	rand bit [31:0] wdata;

	bit [31:0] rdata;
	bit        slverr;

	constraint c_addr_align {
		addr inside {
			10'h000,
			10'h001,
			10'h002,
			10'h003,
			10'h004
			};
		}

	`uvm_object_utils_begin(apb_item)
		`uvm_field_enum(apb_dir_e,dir,UVM_ALL_ON)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_int(wdata, UVM_ALL_ON)
		`uvm_field_int(rdata, UVM_ALL_ON)
		`uvm_field_int(slverr, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="apb_item");
		super.new(name);
	endfunction

endclass
