class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)

  alu_driver    drv;
  alu_sequencer seqr;
  alu_monitor mon;
  alu_scoreboard scb;
  alu_coverage cov;


  function new(string name="alu_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv  = alu_driver    ::type_id::create("drv",  this);
    seqr = alu_sequencer ::type_id::create("seqr", this);
    mon  = alu_monitor   ::type_id::create("mon", this);
    scb  = alu_scoreboard::type_id::create("scb", this);
	cov  = alu_coverage  ::type_id::create("cov",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
	mon.ap.connect(scb.imp);
	mon.ap.connect(cov.analysis_export);
  endfunction
endclass
