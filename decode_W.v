module decode_W(reg_write_en, ctrl_writeback, ctrl_setx, ctrl_jal, op);
    output reg_write_en, ctrl_writeback, ctrl_setx, ctrl_jal;
    input [4:0] op;

    wire is_lw, is_setx, is_jal;
    assign is_lw = (op == 5'b01000);
    assign is_setx = (op == 5'b10101);
    assign is_jal = (op == 5'b00011);

    assign reg_write_en = (op == 5'b00000) | is_lw | (op == 5'b00101) | is_setx | is_jal;
    assign ctrl_writeback = is_lw;
    assign ctrl_setx = is_setx;
    assign ctrl_jal = is_jal;

endmodule