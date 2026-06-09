class apb_uart_base_test extends uvm_test;

  `uvm_component_utils(apb_uart_base_test)

  apb_uart_env env;

  function new(string name = "apb_uart_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(uvm_active_passive_enum)::set(
			this,
			"env.apb_agt",
			"is_active",
			UVM_ACTIVE
			);

		uvm_config_db#(uvm_active_passive_enum)::set(
			this,
			"env.uart_agt",
			"is_active",
			UVM_ACTIVE
			);

		env=apb_uart_env::type_id::create("env",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);

		uvm_top.print_topology();
	endfunction

endclass
