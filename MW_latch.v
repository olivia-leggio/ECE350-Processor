module MW_latch(PC_out, PC1_out, IR_out, O_out, D_out, PC_in, PC1_in, IR_in, O_in, D_in, clk, reset, en);
    output [31:0] PC_out, PC1_out, IR_out, O_out, D_out;
    input [31:0] PC_in, PC1_in, IR_in, O_in, D_in;
    input clk, reset, en;

    one_register PC_reg(PC_out, PC_in, clk, reset, en);
    one_register PC1_reg(PC1_out, PC1_in, clk, reset, en);
    one_register IR_reg(IR_out, IR_in, clk, reset, en);
    one_register O_reg(O_out, O_in, clk, reset, en);
    one_register D_reg(D_out, D_in, clk, reset, en);

endmodule