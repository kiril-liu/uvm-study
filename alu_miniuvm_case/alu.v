//module alu(
//    input a,b,op;
//    output y;
//    );
//    parameter W = 32;
//    
//    wire [W-1:0] op,a,b;
//    reg [W-1:0] y;
//    
//    typedef enum [1:0] {ADD,SUB,AND,XOR} op;
//
//    always @(*) begin
//        case (op)
//            ADD: y = a+b;
//            SUB: y = a-b;
//            AND: y = a&b;
//            XOR: y = a^b;
//        endcase
//    end
//endmodule
//
//
module alu #(parameter W)(
    input [W-1:0] a,
	input [W-1:0] b,
	input [1:0] op,
    output reg [W-1:0] y
    );

    parameter ADD = 2'b00;
	parameter SUB = 2'b01;
	parameter AND = 2'b00;
	parameter XOR = 2'b11;

    always @(*) begin
        case (op)
            ADD: y = a+b;
            SUB: y = a-b;
            AND: y = a&b;
            XOR: y = a^b;
        endcase
    end
endmodule
