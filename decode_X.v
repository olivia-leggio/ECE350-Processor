module decode_X(ALU_B_ctrl, op_ctrl, op, ALU);
    input [4:0] op, ALU;
    output ALU_B_ctrl, op_ctrl; //sub_ctrl

    wire addi;
    assign addi = (op == 5'b00101);

    //assign sub_ctrl = (op == 5'b00000) & (ALU == 5'b00001);
    assign ALU_B_ctrl = addi | (op == 5'b00111) | (op == 5'b01000);
    assign op_ctrl = addi;

endmodule