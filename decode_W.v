module decode_W(reg_write_en, ctrl_writeback, op);
    output reg_write_en, ctrl_writeback;
    input [4:0] op;

    wire is_lw;
    assign is_lw = (op == 5'b01000);
    assign reg_write_en = (op == 5'b00000) | is_lw | (op == 5'b00101);
    assign ctrl_writeback = is_lw;

endmodule