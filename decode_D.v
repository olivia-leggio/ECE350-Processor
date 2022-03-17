module decode_D(ctrl_readB, is_bex, op);
    input [4:0] op;
    output ctrl_readB, is_bex;

    wire sw;
    wire jr;
    wire branch;

    assign sw = (op == 5'b00111);
    assign jr = (op == 5'b00100);
    assign branch = (~op[4] & ~op[3] & op[1] & ~op[0]); //handles 00010 and 00110   bne and blt

    assign ctrl_readB = (sw | jr | branch);
    assign is_bex = (op == 5'b10110);

endmodule