module decode_W(reg_write_en, ctrl_writeback, ctrl_setx, op);
    output reg_write_en, ctrl_writeback, ctrl_setx;
    input [4:0] op;

    wire is_lw, is_setx;
    assign is_lw = (op == 5'b01000);
    assign is_setx = (op == 5'b10101);

    assign reg_write_en = (op == 5'b00000) | is_lw | (op == 5'b00101) | is_setx;
    assign ctrl_writeback = is_lw;
    assign ctrl_setx = is_setx;

endmodule