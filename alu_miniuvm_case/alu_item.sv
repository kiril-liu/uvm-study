class alu_item extends uvm_sequence_item;
  rand bit [W-1:0] a, b;
  rand bit [1:0]  op;


  constraint value0_30 {
	  a inside {[0:30]};
	  b inside {[0:30]};
	  op inside {[0:3]};
	  }


  `uvm_object_utils(alu_item)

  function new(string name="alu_item");
    super.new(name);
  endfunction
endclass

