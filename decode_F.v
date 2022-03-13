module decode_F(ctrl_j, ctrl_jr, op);
    input [4:0] op;
    output ctrl_j, ctrl_jr;

    wire is_j, is_jr;
    assign is_j = (~op[4] & ~op[3] & ~op[2] & op[0]); //handles 00001 and 00011 (j and jal)
    assign is_jr = (op == 5'b00100);

    assign ctrl_j = is_j;
    assign ctrl_jr = is_jr;

endmodule