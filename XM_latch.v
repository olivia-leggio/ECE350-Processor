module XM_latch(IR_out, O_out, B_out, IR_in, O_in, B_in, clk, reset);
    output [31:0] IR_out, O_out, B_out;
    input [31:0] IR_in, O_in, B_in;
    input clk, reset;

    one_register IR_reg(IR_out, IR_in, clk, reset, 1'b1);
    one_register O_reg(O_out, O_in, clk, reset, 1'b1);
    one_register B_reg(B_out, B_in, clk, reset, 1'b1);

endmodule