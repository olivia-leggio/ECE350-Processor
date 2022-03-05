module opdecode(wren, ctrl_writeEnable, ALU_B, reg_in_sel, ALU_MulDiv, sign_ext, currOP, ALU_OP);

    input [4:0] currOP, ALU_OP;
    output wren, ctrl_writeEnable, ALU_B, reg_in_sel, ALU_MulDiv, sign_ext;

    wire aluop, lw, sw, mul, div;

    assign aluop = (currOP == 5'b00000);
    assign lw = (currOP == 5'b01000);
    assign sw = (currOP == 5'b00111);
    assign mul = (ALU_OP == 5'b00110);
    assign div = (ALU_OP == 5'b00111);

    assign ctrl_writeEnable = (aluop | lw);
    assign wren = sw;
    assign sign_ext = (sw | lw);
    assign ALU_B = (sw | lw);
    assign reg_in_sel = lw;
    assign ALU_MulDiv = (mul | div);


endmodule