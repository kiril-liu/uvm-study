interface dut_if #(parameter W);

	logic [W-1:0] a;
	logic [W-1:0] b;
	logic [1:0] op;
    logic [W-1:0] y;


	modport DUT(input a,b,op, output y);
	modport TB(input y, output a,b,op);
endinterface
