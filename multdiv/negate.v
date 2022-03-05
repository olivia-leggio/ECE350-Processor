module negate(out, in);
    input [31:0] in;
    output [31:0] out;
    wire [31:0] NOT_out;
    wire adder_INE, adder_ILT, adder_overflow;

    not32 notter(NOT_out, in);

    adder32 adder(out, adder_INE, adder_ILT, adder_overflow, NOT_out, 32'b0, 1'b1);
endmodule