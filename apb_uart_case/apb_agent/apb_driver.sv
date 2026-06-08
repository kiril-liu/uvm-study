class apb_driver extends uvm_driver #(apb_item);
	`uvm_component_utils(apb_driver)
	virtual apb_interface vif;
	function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

	function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get apb_if from uvm_config_db")
    end
  endfunction


	task run_phase(uvm_phase phase);
		apb_item req;
		reset_bus();

		forever begin
			seq_item_port.get_next_item(req);
			drive_transfer(req);
			seq_item_port.item_done();
		end
	endtask

	task reset_bus();
		vif.drv_cb.PSEL				<= 1'b0;
		vif.drv_cb.PENABLE		<= 1'b0;
		vif.drv_cb.PWRITE			<= 1'b0;
		vif.drv_cb.PADDR			<= '0;
		vif.drv_cb.PWDATA			<= '0;

		wait (vif.PRESETn == 1'b1);
		@(vif.drv_cb);
	endtask

	task drive_transfer(apb_item tr);

		vif.drv_cb.PSEL				<=1'b1;
		vif.drv_cb.PENABLE		<=1'b0;
		vif.drv_cb.PWRITE			<=tr.dir;
		vif.drv_cb.PADDR			<=tr.addr;
		vif.drv_cb.PWDATA			<=tr.wdata;

		@(vif.drv_cb);

		vif.drv_cb.PENABLE	<=1'b1;

		do begin
			@(vif.drv_cb);
		end while (vif.drv_cb.PREADY !== 1'b1);

		if(tr.dir == apb_item::APB_READ) begin
			tr.rdata = vif.drv_cb.PRDATA;
		end

		tr.slverr = vif.drv_cb.PSLVERR;


		vif.drv_cb.PSEL				<=1'b0;
		vif.drv_cb.PENABLE		<=1'b0;
		vif.drv_cb.PWRITE			<=1'b0;
		vif.drv_cb.PADDR			<='0;
		vif.drv_cb.PWDATA			<='0;

		@(vif.drv_cb);
	endtask
endclass
