module decode_F(ctrl_j, op);
    input [4:0] op;
    output ctrl_j;

    wire is_j;
    assign is_j = (op == 5'b00001);

    assign ctrl_j = is_j;

endmodule