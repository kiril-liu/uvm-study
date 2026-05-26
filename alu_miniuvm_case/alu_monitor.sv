class alu_monitor extends uvm_monitor;
	`uvm_component_utils(alu_monitor)

	virtual dut_if#(32) vif;
	uvm_analysis_port#(alu_tr) ap;

	function new(string name="alu_monitor",uvm_component parent=null);
		super.new(name,parent);
		ap=new("ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual dut_if#(32))::get(this,"","vif",vif))
			`uvm_fatal("NOVIF","vif not set")
	endfunction

	task run_phase(uvm_phase phase);
		alu_tr tr;
		forever begin
			#1ns;

			tr = alu_tr::type_id::create("tr");
			tr.a = vif.a;
			tr.b = vif.b;
			tr.op = vif.op;
			tr.y = vif.y;
       		`uvm_info("MON", $sformatf("a=%h b=%h op=%0d y=%h", tr.a, tr.b, tr.op, tr.y), UVM_LOW)

			ap.write(tr);
		end
	endtask
endclass

