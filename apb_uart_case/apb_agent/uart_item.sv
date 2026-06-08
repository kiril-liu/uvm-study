class uart_item extends uvm_sequence_item;

  rand bit [7:0] data;
  
  bit start_bit;
  bit stop_bit;
  bit stop_ok;

  `uvm_object_utils_begin(uart_item)
  `uvm_field_int(data,			UVM_ALL_ON)
	`uvm_field_int(start_bit,	UVM_ALL_ON)
	`uvm_field_int(stop_bit,	UVM_ALL_ON)
	`uvm_field_int(stop_ok,		UVM_ALL_ON)
	`uvm_object_utils_end


	function new(string name ="uart_item");
		super.new(name);
	endfunction

endclass
