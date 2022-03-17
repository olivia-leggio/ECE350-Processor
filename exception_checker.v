module exception_checker(add_exc, addi_exc, sub_exc, mul_exc, div_exc, OP, ALUOP, ALU_ovf, multdiv_ovf);
    input [4:0] OP, ALUOP;
    input ALU_ovf, multdiv_ovf;
    output add_exc, addi_exc, sub_exc, mul_exc, div_exc;

    wire is_basicALU, is_add, is_addi, is_sub, is_mult, is_div;
    //ALU ops
    wire add_op, sub_op;

    //wires of OP
    wire op4 = OP[4];
    wire op3 = OP[3];
    wire op2 = OP[2];
    wire op1 = OP[1];
    wire op0 = OP[0];

    //wires of ALUOP
    wire a4 = ALUOP[4];
    wire a3 = ALUOP[3];
    wire a2 = ALUOP[2];
    wire a1 = ALUOP[1];
    wire a0 = ALUOP[0];

    //detect operations
    assign is_basicALU = (~op4 & ~op3 & ~op2 & ~op1 & ~op0);
    assign is_add = (is_basicALU & (~a4 & ~a3 & ~a2 & ~a1 & ~a0));
    assign is_addi = (~op4 & ~op3 & op2 & ~op1 & op0);
    assign is_sub = (is_basicALU & (~a4 & ~a3 & ~a2 & ~a1 & a0));
    assign is_mult = (is_basicALU & (~a4 & ~a3 & a2 & a1 & ~a0));
    assign is_div = (is_basicALU & (~a4 & ~a3 & a2 & a1 & a0));

    //assign exceptions
    assign add_exc = (is_add & ALU_ovf);
    assign addi_exc = (is_addi & ALU_ovf);
    assign sub_exc = (is_sub & ALU_ovf);
    assign mul_exc = (is_mult & multdiv_ovf);
    assign div_exc = (is_div & multdiv_ovf);

endmodule