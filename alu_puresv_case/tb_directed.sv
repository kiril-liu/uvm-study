
module top;
    parameter W=32;
    parameter ADD=2'd0;
    parameter SUB=2'd1;
    parameter AND=2'd2;
    parameter XOR=2'd3;

    logic [W-1:0] a,b;
    logic [1:0] op;
    logic [W-1:0]y;

    alu dut(
            .a(a),
            .b(b),
            .op(op),
            .y(y)
        );

//*******************Directed Vector Using display Function to Check By Hand****************
    //ADD directed vector
    logic [W-1:0] add_a [0:3] = {0,1,32'h7fff_ffff,32'hffff_ffff};
    logic [W-1:0] add_b [0:3] = {0,2,1,1};
    //SUB directed vector
    logic [W-1:0] sub_a [0:3] = {0,1,2,0};
    logic [W-1:0] sub_b [0:3] = {0,1,1,1};
    //AND directed vector
    logic [W-1:0] and_a [0:3] = {0,32'hffff_ffff,32'hffff_0000,32'haaaa_aaaa};
    logic [W-1:0] and_b [0:3] = {32'hffff_ffff,32'hffff_ffff,32'h0000_ffff,32'h5555_5555};
    //XOR directed vector
    logic [W-1:0] xor_a [0:3] = {0,32'hffff_ffff,32'haaaa_aaaa,32'hffff_0000};
    logic [W-1:0] xor_b [0:3] = {0,32'hffff_ffff,32'h5555_5555,32'h0000_ffff};
//    initial begin
//	    
//        //Check for ADD
//        op = ADD;
//        for(int i =0;i<4;i++) begin
//            a = add_a[i];
//            b = add_b[i];
//		    #0;
//            $display("ALU a:0x%h ADD b:0x%h is 0x%h",a,b,y);
//        end
//        //Check for SUB
//        op = SUB;
//        for(int i =0;i<4;i++) begin
//            a = sub_a[i];
//            b = sub_b[i];
//		    #0;
//            $display("ALU a:0x%h SUB b:0x%h is 0x%h",a,b,y);
//        end
//        //Check for AND
//        op = AND;
//        for(int i =0;i<4;i++) begin
//            a = and_a[i];
//            b = and_b[i];
//		    #0;
//            $display("ALU a:0x%h AND b:0x%h is 0x%h",a,b,y);
//        end
//        //Check for XOR
//        op = XOR;
//        for(int i =0;i<4;i++) begin
//            a = xor_a[i];
//            b = xor_b[i];
//		    #0;
//            $display("ALU a:0x%h XOR b:0x%h is 0x%h",a,b,y);
//        end
//    end
//
//***************Logs******************************
//# ALU a:0x00000000 ADD b:0x00000000 is 0x00000000
//# ALU a:0x00000001 ADD b:0x00000002 is 0x00000003
//# ALU a:0x7fffffff ADD b:0x00000001 is 0x80000000
//# ALU a:0xffffffff ADD b:0x00000001 is 0x00000000
//# ALU a:0x00000000 SUB b:0x00000000 is 0x00000000
//# ALU a:0x00000001 SUB b:0x00000001 is 0x00000000
//# ALU a:0x00000002 SUB b:0x00000001 is 0x00000001
//# ALU a:0x00000000 SUB b:0x00000001 is 0xffffffff
//# ALU a:0x00000000 AND b:0xffffffff is 0x00000000
//# ALU a:0xffffffff AND b:0xffffffff is 0xffffffff
//# ALU a:0xffff0000 AND b:0x0000ffff is 0x00000000
//# ALU a:0xaaaaaaaa AND b:0x55555555 is 0x00000000
//# ALU a:0x00000000 XOR b:0x00000000 is 0x00000000
//# ALU a:0xffffffff XOR b:0xffffffff is 0x00000000
//# ALU a:0xaaaaaaaa XOR b:0x55555555 is 0xffffffff
//# ALU a:0xffff0000 XOR b:0x0000ffff is 0xffffffff
//
//Using Task to make simplify code
//    task apply_vec(input logic [1:0] op_i,
//                input logic [W-1:0] a_i,
//                input logic [W-1:0] b_i);
//        begin
//            op= op_i;
//            a = a_i;
//            b = b_i;
//            #0;
//            $display("ALU:%d a:0x%h b:0x%h is 0x%h",op,a,b,y);
//        end
//    endtask
//    
//    initial begin
//       $display("ALU op code menu:\nADD:0|SUB:1|AND:2|XOR:3.\n"); 
//        //Check ADD
//        for(int i =0;i<4;i++) begin
//            apply_vec(ADD,add_a[i],add_b[i]);
//        end
//        //Check SUB
//        for(int i =0;i<4;i++) begin
//            apply_vec(SUB,sub_a[i],sub_b[i]);
//        end
//        //Check AND
//        for(int i =0;i<4;i++) begin
//            apply_vec(AND,and_a[i],and_b[i]);
//        end
//        //Check XOR
//        for(int i =0;i<4;i++) begin
//            apply_vec(XOR,xor_a[i],xor_b[i]);
//        end
//    end
//**************************logs*****************************
//# ALU op code menu:
//# ADD:0|SUB:1|AND:2|XOR:3.
//# 
//# ALU:0 a:0x00000000 b:0x00000000 is 0x00000000
//# ALU:0 a:0x00000001 b:0x00000002 is 0x00000003
//# ALU:0 a:0x7fffffff b:0x00000001 is 0x80000000
//# ALU:0 a:0xffffffff b:0x00000001 is 0x00000000
//# ALU:1 a:0x00000000 b:0x00000000 is 0x00000000
//# ALU:1 a:0x00000001 b:0x00000001 is 0x00000000
//# ALU:1 a:0x00000002 b:0x00000001 is 0x00000001
//# ALU:1 a:0x00000000 b:0x00000001 is 0xffffffff
//# ALU:2 a:0x00000000 b:0xffffffff is 0x00000000
//# ALU:2 a:0xffffffff b:0xffffffff is 0xffffffff
//# ALU:2 a:0xffff0000 b:0x0000ffff is 0x00000000
//# ALU:2 a:0xaaaaaaaa b:0x55555555 is 0x00000000
//# ALU:3 a:0x00000000 b:0x00000000 is 0x00000000
//# ALU:3 a:0xffffffff b:0xffffffff is 0x00000000
//# ALU:3 a:0xaaaaaaaa b:0x55555555 is 0xffffffff
//# ALU:3 a:0xffff0000 b:0x0000ffff is 0xffffffff
//
//
    task apply_vec(input logic [1:0] op_i,
                input logic [W-1:0] a_i,
                input logic [W-1:0] b_i);
        logic [W-1:0] alu_y;
        begin
            op= op_i;
            a = a_i;
            b = b_i;
            alu_y = alu_ref(a,b,op);
            #1;
            if(alu_y === y)
                $display("PASS. op:%d; a:%h,b%h.Gloden_model is %h, DUT is %h",op,a,b,alu_y,y);
            else
                $display("FAILED. op:%d; a:%h,b%h.Gloden_model is %h, DUT is %h",op,a,b,alu_y,y);
        end
    endtask

   // function logic[W-1:0] alu_ref;
   //         input logic[W-1:0] a_i;
   //         input logic[W-1:0] b_i;
   //         input [1:0] op;
   //     begin
   //         case(op)
   //             ADD:alu_ref=a_i+b_i;
   //             SUB:alu_ref=a_i-b_i;
   //             AND:alu_ref=a_i&b_i;
   //             XOR:alu_ref=a_i^b_i;
   //             default:alu_ref=0;
   //         endcase
   //     end
   // endfunction
    function logic[W-1:0] alu_ref(
            input logic[W-1:0] a_i,
            input logic[W-1:0] b_i,
            input [1:0] op);
        begin
            case(op)
                ADD:alu_ref=a_i+b_i;
                SUB:alu_ref=a_i-b_i;
                AND:alu_ref=a_i&b_i;
                XOR:alu_ref=a_i^b_i;
                default:alu_ref=0;
            endcase
        end
    endfunction

//    initial begin
//        for(int i=0; i<4; i++) begin
//            apply_vec(ADD,add_a[i],add_b[i]);
//        end
//        for(int i=0; i<4; i++) begin
//            apply_vec(SUB,sub_a[i],sub_b[i]);
//        end
//        for(int i=0; i<4; i++) begin
//            apply_vec(AND,and_a[i],and_b[i]);
//        end
//        for(int i=0; i<4; i++) begin
//            apply_vec(XOR,xor_a[i],xor_b[i]);
//        end
//    end

//*******************logs************************
//# PASS. op:0,a:00000000,b00000000.Gloden_model is 00000000, DUT is 00000000
//# FAIL. op:0,a:00000001,b00000002.Gloden_model is 00000003, DUT is ffffffff
//# FAIL. op:0,a:7fffffff,b00000001.Gloden_model is 80000000, DUT is 7ffffffe
//# FAIL. op:0,a:ffffffff,b00000001.Gloden_model is 00000000, DUT is fffffffe
//# PASS. op:1,a:00000000,b00000000.Gloden_model is 00000000, DUT is 00000000
//# PASS. op:1,a:00000001,b00000001.Gloden_model is 00000000, DUT is 00000000
//# PASS. op:1,a:00000002,b00000001.Gloden_model is 00000001, DUT is 00000001
//# PASS. op:1,a:00000000,b00000001.Gloden_model is ffffffff, DUT is ffffffff
//# PASS. op:2,a:00000000,bffffffff.Gloden_model is 00000000, DUT is 00000000
//# PASS. op:2,a:ffffffff,bffffffff.Gloden_model is ffffffff, DUT is ffffffff
//# PASS. op:2,a:ffff0000,b0000ffff.Gloden_model is 00000000, DUT is 00000000
//# PASS. op:2,a:aaaaaaaa,b55555555.Gloden_model is 00000000, DUT is 00000000
//# PASS. op:3,a:00000000,b00000000.Gloden_model is 00000000, DUT is 00000000
//# PASS. op:3,a:ffffffff,bffffffff.Gloden_model is 00000000, DUT is 00000000
//# PASS. op:3,a:aaaaaaaa,b55555555.Gloden_model is ffffffff, DUT is ffffffff
//# PASS. op:3,a:ffff0000,b0000ffff.Gloden_model is ffffffff, DUT is ffffffff
//
//
//

    covergroup cg;
        //coverpoint op{
        //    bins ADD = {0};
        //    bins SUB = {1};
        //    bins AND = {2};
        //    bins XOR = {3};
        //    }
        //
        cp_op : coverpoint op;
        cp_a : coverpoint a;
        cp_b : coverpoint b;
        cp_y : coverpoint y;
    endgroup


    initial begin
        logic [W-1:0] a_in;
        logic [W-1:0] b_in;
        bit [1:0] op;
        cg cg_inst;
        
        cg_inst = new();

        for(int i=0;i <9; i++) begin
            a_in = $urandom();
            b_in = $urandom();
            op = $urandom_range(0,3);
            apply_vec(op,a_in,b_in);

            cg_inst.sample();
        end
        $display("Simulation started with seed: %0d", $get_initial_random_seed());
        $display("Coverage of op is %d", cg_inst.get_inst_coverage());
        //****Both can be compiled,But if declaration as static.
        //****a_in,b_in,op_in will be randomized to same value.
        //****(depends on seeds) 
        //
        //for (int i=0; i<1000; i++) begin
        //    static logic [W-1:0] a_in = $urandom();
        //    static logic [W-1:0] b_in = $urandom();
        //    static logic [1:0]   op_in = $urandom_range(0,3);
        //    apply_vec(op_in, a_in, b_in);
        //end
        //for (int i=0; i<1000; i++) begin
        //    automatic logic [W-1:0] a_in = $urandom();
        //    statictic logic [W-1:0] b_in = $urandom();
        //    statictic logic [1:0]   op_in = $urandom_range(0,3);
        //    apply_vec(op_in, a_in, b_in);
        //end
    end


endmodule
