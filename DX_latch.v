module DX_latch(PC_out, IR_out, A_out, B_out, PC_in, IR_in, A_in, B_in, clk, reset);
    output [31:0] PC_out, IR_out, A_out, B_out;
    input [31:0] PC_in, IR_in, A_in, B_in;
    input clk, reset;

    one_register PC_reg(PC_out, PC_in, clk, reset, 1'b1);
    one_register IR_reg(IR_out, IR_in, clk, reset, 1'b1);
    one_register A_reg(A_out, A_in, clk, reset, 1'b1);
    one_register B_reg(B_out, B_in, clk, reset, 1'b1);

endmodule