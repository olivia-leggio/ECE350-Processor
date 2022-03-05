module FD_latch(PC_out, IR_out, PC_in, IR_in, clk, reset);
    output [31:0] PC_out, IR_out;
    input [31:0] PC_in, IR_in;
    input clk, reset;

    one_register PC_reg(PC_out, PC_in, clk, reset, 1'b1);
    one_register IR_reg(IR_out, IR_in, clk, reset, 1'b1);

endmodule