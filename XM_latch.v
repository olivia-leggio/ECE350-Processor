module XM_latch(IR_out, O_out, B_out, IR_in, O_in, B_in, clk, reset, en);
    output [31:0] IR_out, O_out, B_out;
    input [31:0] IR_in, O_in, B_in;
    input clk, reset, en;

    one_register IR_reg(IR_out, IR_in, clk, reset, en);
    one_register O_reg(O_out, O_in, clk, reset, en);
    one_register B_reg(B_out, B_in, clk, reset, en);

endmodule