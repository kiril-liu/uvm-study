class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	alu_env env;

	function new (string name="base_test",uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = alu_env::type_id::create("new",this);
	endfunction

	task run_phase(uvm_phase phase);
		basic_seq seq;
		phase.raise_objection(this);
		
		seq = basic_seq::type_id::create("seq");
		seq.start(env.seqr);

		phase.drop_objection(this);
	endtask
endclass
