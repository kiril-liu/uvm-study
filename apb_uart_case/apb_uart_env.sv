class apb_uart_env extends uvm_env;

  `uvm_component_utils(apb_uart_env)

  apb_agent apb_agt;

  uart_agent uart_agt;
  // apb_uart_scoreboard sb;
  // apb_uart_coverage   cov;
	//
	
	function new(string name = "apb_uart_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    apb_agt = apb_agent::type_id::create("apb_agt", this);

    uart_agt = uart_agent::type_id::create("uart_agt", this);
  endfunction

	  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // 目前 APB agent 内部自己连接 driver/sequencer
    // env 这里暂时没有连接关系
  endfunction

endclass
