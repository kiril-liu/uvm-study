class basic_seq extends uvm_sequence #(alu_item);
  `uvm_object_utils(basic_seq)

  function new(string name="basic_seq");
    super.new(name);
  endfunction

  task body();
    alu_item req;
    repeat (100) begin
      req = alu_item::type_id::create("req");
      assert(req.randomize());
      start_item(req);
      finish_item(req);
    end
  endtask
endclass
