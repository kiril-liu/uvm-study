class alu_tr extends uvm_sequence_item;
	bit [W-1:0] a,b;
	bit [1:0] op;
	bit [W-1:0] y;

	`uvm_object_utils(alu_tr)

	function new(string name="alu_tr");
		super.new(name);
	endfunction
endclass
