module decode_F(ctrl_j, op);
    input [4:0] op;
    output ctrl_j;

    wire is_j;
    assign is_j = (~op[4] & ~op[3] & ~op[2] & op[0]); //handles 00001 and 00011 (j and jal)

    assign ctrl_j = is_j;

endmodule