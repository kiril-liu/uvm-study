class alu_coverage extends uvm_subscriber #(alu_tr);
	`uvm_component_utils(alu_coverage)


	covergroup cg;
		option.per_instance = 1;

		cp_op : coverpoint tr.op {
			bins add_op = {0};
			bins sub_op = {1};
			bins and_op = {2};
			bins xor_op = {3};
			}
		
		cp_a_kind :coverpoint tr.a {

			bins a0 ={0};
			bins a1 ={1};
			bins amax ={30};
			bins amid ={[2:29]};
			}

		cp_b_kind : coverpoint tr.b {
			bins b0={0};
			bins b1={1};
			bins bmax={30};
			bins bmid={[2:29]};
			}

		cr_op_a_b : cross cp_op, cp_a_kind, cp_b_kind;
	endgroup

	alu_tr tr;

	function new(string name="alu_coverage",uvm_component parent=null);
		super.new(name,parent);
		tr = new ("tr");
		cg = new ();
	endfunction


	function void write(alu_tr t);
		tr=t;
		cg.sample();
	endfunction
endclass


