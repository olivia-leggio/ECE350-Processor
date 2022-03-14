module decode_D(ctrl_readB, op);
    input [4:0] op;
    output ctrl_readB;

    wire sw;
    wire jr;

    assign sw = (op == 5'b00111);
    assign jr = (op == 5'b00100);

    assign ctrl_readB = (sw | jr);

endmodule