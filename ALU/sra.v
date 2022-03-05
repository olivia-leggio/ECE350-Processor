module sra(out, in, shamt);
    input [31:0] in;
    input [4:0] shamt;
    output [31:0] out;

    wire [31:0] p16, p8, p4, p2, p1; //wires coming out of shifters
    wire [31:0] m16, m8, m4, m2; //wires coming out of muxes

    shiftr16 shifter16(.out(p16), .in(in));
    assign m16 = shamt[4] ? p16 : in;

    shiftr8 shifter8(.out(p8), .in(m16));
    assign m8 = shamt[3] ? p8 : m16;

    shiftr4 shifter4(.out(p4), .in(m8));
    assign m4 = shamt[2] ? p4 : m8;

    shiftr2 shifter2(.out(p2), .in(m4));
    assign m2 = shamt[1] ? p2 : m4;

    shiftr1 shifter1(.out(p1), .in(m2));
    assign out = shamt[0] ? p1 : m2;

endmodule



module shiftr1(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] =  in[1];
    assign out[1] =  in[2];
    assign out[2] =  in[3];
    assign out[3] =  in[4];
    assign out[4] =  in[5];
    assign out[5] =  in[6];
    assign out[6] =  in[7];
    assign out[7] =  in[8];
    assign out[8] =  in[9];
    assign out[9] =  in[10];
    assign out[10] = in[11];
    assign out[11] = in[12];
    assign out[12] = in[13];
    assign out[13] = in[14];
    assign out[14] = in[15];
    assign out[15] = in[16];
    assign out[16] = in[17];
    assign out[17] = in[18];
    assign out[18] = in[19];
    assign out[19] = in[20];
    assign out[20] = in[21];
    assign out[21] = in[22];
    assign out[22] = in[23];
    assign out[23] = in[24];
    assign out[24] = in[25];
    assign out[25] = in[26];
    assign out[26] = in[27];
    assign out[27] = in[28];
    assign out[28] = in[29];
    assign out[29] = in[30];
    assign out[30] = in[31];
    assign out[31] = in[31];
endmodule

module shiftr2(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] =  in[2];
    assign out[1] =  in[3];
    assign out[2] =  in[4];
    assign out[3] =  in[5];
    assign out[4] =  in[6];
    assign out[5] =  in[7];
    assign out[6] =  in[8];
    assign out[7] =  in[9];
    assign out[8] =  in[10];
    assign out[9] =  in[11];
    assign out[10] = in[12];
    assign out[11] = in[13];
    assign out[12] = in[14];
    assign out[13] = in[15];
    assign out[14] = in[16];
    assign out[15] = in[17];
    assign out[16] = in[18];
    assign out[17] = in[19];
    assign out[18] = in[20];
    assign out[19] = in[21];
    assign out[20] = in[22];
    assign out[21] = in[23];
    assign out[22] = in[24];
    assign out[23] = in[25];
    assign out[24] = in[26];
    assign out[25] = in[27];
    assign out[26] = in[28];
    assign out[27] = in[29];
    assign out[28] = in[30];
    assign out[29] = in[31];
    assign out[30] = in[31];
    assign out[31] = in[31];
endmodule

module shiftr4(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] =  in[4];
    assign out[1] =  in[5];
    assign out[2] =  in[6];
    assign out[3] =  in[7];
    assign out[4] =  in[8];
    assign out[5] =  in[9];
    assign out[6] =  in[10];
    assign out[7] =  in[11];
    assign out[8] =  in[12];
    assign out[9] =  in[13];
    assign out[10] = in[14];
    assign out[11] = in[15];
    assign out[12] = in[16];
    assign out[13] = in[17];
    assign out[14] = in[18];
    assign out[15] = in[19];
    assign out[16] = in[20];
    assign out[17] = in[21];
    assign out[18] = in[22];
    assign out[19] = in[23];
    assign out[20] = in[24];
    assign out[21] = in[25];
    assign out[22] = in[26];
    assign out[23] = in[27];
    assign out[24] = in[28];
    assign out[25] = in[29];
    assign out[26] = in[30];
    assign out[27] = in[31];
    assign out[28] = in[31];
    assign out[29] = in[31];
    assign out[30] = in[31];
    assign out[31] = in[31];
endmodule

module shiftr8(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] =  in[8];
    assign out[1] =  in[9];
    assign out[2] =  in[10];
    assign out[3] =  in[11];
    assign out[4] =  in[12];
    assign out[5] =  in[13];
    assign out[6] =  in[14];
    assign out[7] =  in[15];
    assign out[8] =  in[16];
    assign out[9] =  in[17];
    assign out[10] = in[18];
    assign out[11] = in[19];
    assign out[12] = in[20];
    assign out[13] = in[21];
    assign out[14] = in[22];
    assign out[15] = in[23];
    assign out[16] = in[24];
    assign out[17] = in[25];
    assign out[18] = in[26];
    assign out[19] = in[27];
    assign out[20] = in[28];
    assign out[21] = in[29];
    assign out[22] = in[30];
    assign out[23] = in[31];
    assign out[24] = in[31];
    assign out[25] = in[31];
    assign out[26] = in[31];
    assign out[27] = in[31];
    assign out[28] = in[31];
    assign out[29] = in[31];
    assign out[30] = in[31];
    assign out[31] = in[31];
endmodule

module shiftr16(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] =  in[16];
    assign out[1] =  in[17];
    assign out[2] =  in[18];
    assign out[3] =  in[19];
    assign out[4] =  in[20];
    assign out[5] =  in[21];
    assign out[6] =  in[22];
    assign out[7] =  in[23];
    assign out[8] =  in[24];
    assign out[9] =  in[25];
    assign out[10] = in[26];
    assign out[11] = in[27];
    assign out[12] = in[28];
    assign out[13] = in[29];
    assign out[14] = in[30];
    assign out[15] = in[31];
    assign out[16] = in[31];
    assign out[17] = in[31];
    assign out[18] = in[31];
    assign out[19] = in[31];
    assign out[20] = in[31];
    assign out[21] = in[31];
    assign out[22] = in[31];
    assign out[23] = in[31];
    assign out[24] = in[31];
    assign out[25] = in[31];
    assign out[26] = in[31];
    assign out[27] = in[31];
    assign out[28] = in[31];
    assign out[29] = in[31];
    assign out[30] = in[31];
    assign out[31] = in[31];
endmodule