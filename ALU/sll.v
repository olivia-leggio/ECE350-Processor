module sll(out, in, shamt);
    input [31:0] in;
    input [4:0] shamt;
    output [31:0] out;

    wire [31:0] p16, p8, p4, p2, p1; //wires coming out of shifters
    wire [31:0] m16, m8, m4, m2; //wires coming out of muxes

    shift16 shift16(.out(p16), .in(in));
    assign m16 = shamt[4] ? p16 : in;

    shift8 shift8(.out(p8), .in(m16));
    assign m8 = shamt[3] ? p8 : m16;

    shift4 shift4(.out(p4), .in(m8));
    assign m4 = shamt[2] ? p4 : m8;

    shift2 shift2(.out(p2), .in(m4));
    assign m2 = shamt[1] ? p2 : m4;

    shift1 shift1(.out(p1), .in(m2));
    assign out = shamt[0] ? p1 : m2;

endmodule



module shift1(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] = 0;
    assign out[1] = in[0];
    assign out[2] = in[1];
    assign out[3] = in[2];

    assign out[4] = in[3];
    assign out[5] = in[4];
    assign out[6] = in[5];
    assign out[7] = in[6];

    assign out[8] = in[7];
    assign out[9] = in[8];
    assign out[10] = in[9];
    assign out[11] = in[10];

    assign out[12] = in[11];
    assign out[13] = in[12];
    assign out[14] = in[13];
    assign out[15] = in[14];

    assign out[16] = in[15];
    assign out[17] = in[16];
    assign out[18] = in[17];
    assign out[19] = in[18];

    assign out[20] = in[19];
    assign out[21] = in[20];
    assign out[22] = in[21];
    assign out[23] = in[22];

    assign out[24] = in[23];
    assign out[25] = in[24];
    assign out[26] = in[25];
    assign out[27] = in[26];

    assign out[28] = in[27];
    assign out[29] = in[28];
    assign out[30] = in[29];
    assign out[31] = in[30];
endmodule

module shift2(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] = 0;
    assign out[1] = 0;
    assign out[2] = in[0];
    assign out[3] = in[1];

    assign out[4] = in[2];
    assign out[5] = in[3];
    assign out[6] = in[4];
    assign out[7] = in[5];

    assign out[8] = in[6];
    assign out[9] = in[7];
    assign out[10] = in[8];
    assign out[11] = in[9];

    assign out[12] = in[10];
    assign out[13] = in[11];
    assign out[14] = in[12];
    assign out[15] = in[13];

    assign out[16] = in[14];
    assign out[17] = in[15];
    assign out[18] = in[16];
    assign out[19] = in[17];

    assign out[20] = in[18];
    assign out[21] = in[19];
    assign out[22] = in[20];
    assign out[23] = in[21];

    assign out[24] = in[22];
    assign out[25] = in[23];
    assign out[26] = in[24];
    assign out[27] = in[25];

    assign out[28] = in[26];
    assign out[29] = in[27];
    assign out[30] = in[28];
    assign out[31] = in[29];
endmodule

module shift4(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] = 0;
    assign out[1] = 0;
    assign out[2] = 0;
    assign out[3] = 0;

    assign out[4] = in[0];
    assign out[5] = in[1];
    assign out[6] = in[2];
    assign out[7] = in[3];

    assign out[8] = in[4];
    assign out[9] = in[5];
    assign out[10] = in[6];
    assign out[11] = in[7];

    assign out[12] = in[8];
    assign out[13] = in[9];
    assign out[14] = in[10];
    assign out[15] = in[11];

    assign out[16] = in[12];
    assign out[17] = in[13];
    assign out[18] = in[14];
    assign out[19] = in[15];

    assign out[20] = in[16];
    assign out[21] = in[17];
    assign out[22] = in[18];
    assign out[23] = in[19];

    assign out[24] = in[20];
    assign out[25] = in[21];
    assign out[26] = in[22];
    assign out[27] = in[23];

    assign out[28] = in[24];
    assign out[29] = in[25];
    assign out[30] = in[26];
    assign out[31] = in[27];
endmodule

module shift8(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] = 0;
    assign out[1] = 0;
    assign out[2] = 0;
    assign out[3] = 0;

    assign out[4] = 0;
    assign out[5] = 0;
    assign out[6] = 0;
    assign out[7] = 0;

    assign out[8] = in[0];
    assign out[9] = in[1];
    assign out[10] = in[2];
    assign out[11] = in[3];

    assign out[12] = in[4];
    assign out[13] = in[5];
    assign out[14] = in[6];
    assign out[15] = in[7];

    assign out[16] = in[8];
    assign out[17] = in[9];
    assign out[18] = in[10];
    assign out[19] = in[11];

    assign out[20] = in[12];
    assign out[21] = in[13];
    assign out[22] = in[14];
    assign out[23] = in[15];

    assign out[24] = in[16];
    assign out[25] = in[17];
    assign out[26] = in[18];
    assign out[27] = in[19];

    assign out[28] = in[20];
    assign out[29] = in[21];
    assign out[30] = in[22];
    assign out[31] = in[23];
endmodule

module shift16(out, in);
    input [31:0] in;
    output [31:0] out;

    assign out[0] = 0;
    assign out[1] = 0;
    assign out[2] = 0;
    assign out[3] = 0;

    assign out[4] = 0;
    assign out[5] = 0;
    assign out[6] = 0;
    assign out[7] = 0;

    assign out[8] = 0;
    assign out[9] = 0;
    assign out[10] = 0;
    assign out[11] = 0;

    assign out[12] = 0;
    assign out[13] = 0;
    assign out[14] = 0;
    assign out[15] = 0;

    assign out[16] = in[0];
    assign out[17] = in[1];
    assign out[18] = in[2];
    assign out[19] = in[3];

    assign out[20] = in[4];
    assign out[21] = in[5];
    assign out[22] = in[6];
    assign out[23] = in[7];

    assign out[24] = in[8];
    assign out[25] = in[9];
    assign out[26] = in[10];
    assign out[27] = in[11];

    assign out[28] = in[12];
    assign out[29] = in[13];
    assign out[30] = in[14];
    assign out[31] = in[15];
endmodule