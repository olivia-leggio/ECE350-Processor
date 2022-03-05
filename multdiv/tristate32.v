module tristate32(out, in, sel);
    input [31:0] in;
    output [31:0] out;
    input sel;

    assign out[31:0] = sel ? in[31:0] : 32'bz;

endmodule