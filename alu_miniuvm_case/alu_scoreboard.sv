class alu_scoreboard extends uvm_component;
	`uvm_component_utils(alu_scoreboard)

	uvm_analysis_imp #(alu_tr, alu_scoreboard) imp;

	function new(string name="alu_scoreboard", uvm_component parent=null);
		super.new(name,parent);
		imp = new("imp",this);
	endfunction

    function bit[W-1:0] golden(
            bit[W-1:0] a_i,
            bit[W-1:0] b_i,
            [1:0] op);
            case(op)
                2'd0:golden=a_i+b_i;
                2'd1:golden=a_i-b_i;
                2'd2:golden=a_i&b_i;
                2'd3:golden=a_i^b_i;
                default:golden=0;
            endcase
    endfunction

	function void write(alu_tr tr);
		int seed;
		bit [W-1:0] exp;
		exp = golden(tr.a,tr.b,tr.op);
		$value$plusargs("SEED=%d", seed);
		//`uvm_info("SCB",$sformatf("op=%0d a =%h b=%h exp=%h act=%h",tr.op,tr.a,tr.b,exp,tr.y),UVM_LOW)
		if(tr.y !== exp) begin
			`uvm_error("SCB",$sformatf("Mismatch: op=%0d a =%h b=%h exp=%h act=%h seed=%0d",tr.op,tr.a,tr.b,exp,tr.y,seed))
		end
	endfunction
endclass

