module decode_X(ALU_B_ctrl, op_ctrl, is_mult, is_div, is_bne, is_blt, op, ALU);
    input [4:0] op, ALU;
    output ALU_B_ctrl, op_ctrl, is_mult, is_div, is_bne, is_blt; //sub_ctrl

    wire addi, basicALU;
    assign addi = (op == 5'b00101);
    assign basicALU = (op == 5'b00000);

    //assign sub_ctrl = (op == 5'b00000) & (ALU == 5'b00001);
    assign ALU_B_ctrl = addi | (op == 5'b00111) | (op == 5'b01000);
    assign op_ctrl = addi;
    assign is_mult = basicALU & (ALU == 5'b00110);
    assign is_div = basicALU & (ALU == 5'b00111);
    assign is_bne = (op == 5'b00010);
    assign is_blt = (op == 5'b00110);

endmodule