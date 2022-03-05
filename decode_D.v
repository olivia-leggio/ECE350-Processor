module decode_D(ctrl_readB, op);
    input [4:0] op;
    output ctrl_readB;

    wire sw;

    assign sw = (op == 5'b00111);

    assign ctrl_readB = sw;

endmodule