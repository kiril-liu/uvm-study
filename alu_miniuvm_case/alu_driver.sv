class alu_driver extends uvm_driver #(alu_item);
  `uvm_component_utils(alu_driver)

  virtual dut_if#(32) vif;

  function new(string name="alu_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if#(32))::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "vif not set")
  endfunction

  task run_phase(uvm_phase phase);
    alu_item req;
    forever begin
      seq_item_port.get_next_item(req);

      vif.a  <= req.a;
      vif.b  <= req.b;
      vif.op <= req.op;

      // 组合 ALU 的话：可以让一个 delta cycle 过去再看 y
       #1;
       //`uvm_info("DRV", $sformatf("a=%h b=%h op=%0d y=%h", req.a, req.b, req.op, vif.y), UVM_LOW)

      seq_item_port.item_done();
    end
  endtask
endclass

