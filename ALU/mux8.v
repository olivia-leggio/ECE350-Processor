module mux8(out, in0, in1, in2, in3, in4, in5, in6, in7, OP);
    input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
    input [4:0] OP;
    output [31:0] out;

    wire [31:0] level21, level22, level31, level32, level33, level34;

    assign out = OP[0] ? level22 : level21;

    assign level21 = OP[1] ? level32 : level31;
    assign level22 = OP[1] ? level34 : level33;

    assign level31 = OP[2] ? in4 : in0;
    assign level32 = OP[2] ? in6 : in2;
    assign level33 = OP[2] ? in5 : in1;
    assign level34 = OP[2] ? in7 : in3;

endmodule