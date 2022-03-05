module decoder32(out, in);
    input [4:0] in;
    output [31:0] out;

    sll shifter(out, 32'b1, in);
endmodule