//`include "adder_module.v"

module adder32(S, isNotEqual, isLessThan, overflow, A, B, Cin);
    input [31:0] A, B;
    input Cin;
    output [31:0] S;
    output isNotEqual, isLessThan, overflow;
    wire Cout;

    wire [7:0] mod1A, mod1B, mod2A, mod2B, mod3A, mod3B, mod4A, mod4B;    //adder_module inputs
    wire [7:0] S1, S2, S3, S4;               //adder_module outputs

    wire p0, g0, p1, g1, p2, g2, p3, g3;     //p and g from each adder_module
    wire c1, c2, c3;                         //carries between each module
    
    wire c11;                      //c1 parts
    wire c21, c22;                 //c2 parts
    wire c31, c32, c33;            //c3 parts
    wire c41, c42, c43, c44;       //c4 parts


//~~~~~~~~~~~~~~~~~~~~~~~splitting inputs~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //A
    assign mod1A[0] = A[0];
    assign mod1A[1] = A[1];
    assign mod1A[2] = A[2];
    assign mod1A[3] = A[3];
    assign mod1A[4] = A[4];
    assign mod1A[5] = A[5];
    assign mod1A[6] = A[6];
    assign mod1A[7] = A[7];

    assign mod2A[0] = A[8];
    assign mod2A[1] = A[9];
    assign mod2A[2] = A[10];
    assign mod2A[3] = A[11];
    assign mod2A[4] = A[12];
    assign mod2A[5] = A[13];
    assign mod2A[6] = A[14];
    assign mod2A[7] = A[15];

    assign mod3A[0] = A[16];
    assign mod3A[1] = A[17];
    assign mod3A[2] = A[18];
    assign mod3A[3] = A[19];
    assign mod3A[4] = A[20];
    assign mod3A[5] = A[21];
    assign mod3A[6] = A[22];
    assign mod3A[7] = A[23];

    assign mod4A[0] = A[24];
    assign mod4A[1] = A[25];
    assign mod4A[2] = A[26];
    assign mod4A[3] = A[27];
    assign mod4A[4] = A[28];
    assign mod4A[5] = A[29];
    assign mod4A[6] = A[30];
    assign mod4A[7] = A[31];

    //B
    assign mod1B[0] = B[0];
    assign mod1B[1] = B[1];
    assign mod1B[2] = B[2];
    assign mod1B[3] = B[3];
    assign mod1B[4] = B[4];
    assign mod1B[5] = B[5];
    assign mod1B[6] = B[6];
    assign mod1B[7] = B[7];

    assign mod2B[0] = B[8];
    assign mod2B[1] = B[9];
    assign mod2B[2] = B[10];
    assign mod2B[3] = B[11];
    assign mod2B[4] = B[12];
    assign mod2B[5] = B[13];
    assign mod2B[6] = B[14];
    assign mod2B[7] = B[15];

    assign mod3B[0] = B[16];
    assign mod3B[1] = B[17];
    assign mod3B[2] = B[18];
    assign mod3B[3] = B[19];
    assign mod3B[4] = B[20];
    assign mod3B[5] = B[21];
    assign mod3B[6] = B[22];
    assign mod3B[7] = B[23];

    assign mod4B[0] = B[24];
    assign mod4B[1] = B[25];
    assign mod4B[2] = B[26];
    assign mod4B[3] = B[27];
    assign mod4B[4] = B[28];
    assign mod4B[5] = B[29];
    assign mod4B[6] = B[30];
    assign mod4B[7] = B[31];

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~carries~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //c1
    and c1and1(c11, Cin, p0);
    or c1or(c1, c11, g0);

    //c2
    and c2and1(c21, Cin, p0, p1);
    and c2and2(c22, g0, p1);
    or c2or(c2, c21, c22, g1);

    //c3
    and c3and1(c31, Cin, p0, p1, p2);
    and c3and2(c32, g0, p1, p2);
    and c3and3(c33, g1, p2);
    or c3or(c3, c31, c32, c33, g2);

    //c4
    and c4and1(c41, Cin, p0, p1, p2, p3);
    and c4and2(c42, g0, p1, p2, p3);
    and c4and3(c43, g1, p2, p3);
    and c4and4(c44, g2, p3);
    or c4or(Cout, c41, c42, c43, c44, g3);

//~~~~~~~~~~~~~~~~~~~~~~~~adder modules~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    adder_module mod1(S1, g0, p0, mod1A, mod1B, Cin);
    adder_module mod2(S2, g1, p1, mod2A, mod2B, c1);
    adder_module mod3(S3, g2, p2, mod3A, mod3B, c2);
    adder_module mod4(S4, g3, p3, mod4A, mod4B, c3);

//~~~~~~~~~~~~~~~~~~~~~~~~combining sums~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    assign S[0] = S1[0];
    assign S[1] = S1[1];
    assign S[2] = S1[2];
    assign S[3] = S1[3];
    assign S[4] = S1[4];
    assign S[5] = S1[5];
    assign S[6] = S1[6];
    assign S[7] = S1[7];

    assign S[8] = S2[0];
    assign S[9] = S2[1];
    assign S[10] = S2[2];
    assign S[11] = S2[3];
    assign S[12] = S2[4];
    assign S[13] = S2[5];
    assign S[14] = S2[6];
    assign S[15] = S2[7];

    assign S[16] = S3[0];
    assign S[17] = S3[1];
    assign S[18] = S3[2];
    assign S[19] = S3[3];
    assign S[20] = S3[4];
    assign S[21] = S3[5];
    assign S[22] = S3[6];
    assign S[23] = S3[7];

    assign S[24] = S4[0];
    assign S[25] = S4[1];
    assign S[26] = S4[2];
    assign S[27] = S4[3];
    assign S[28] = S4[4];
    assign S[29] = S4[5];
    assign S[30] = S4[6];
    assign S[31] = S4[7];

//~~~~~~~~~~~~~~~~~~~~~~~~extra bits~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //overflow
    wire negA, negB, negS, ovfand1, ovfand2;
    not negAA(negA, A[31]);
    not negBB(negB, B[31]);
    not negSS(negS, S[31]);

    and ovfandd1(ovfand1, negA, negB, S[31]);
    and ovfandd2(ovfand2, A[31], B[31], negS);
    or ovfor(overflow, ovfand1, ovfand2);

    //isNotEqual
    wire or1, or2, or3, or4;
    or pa1(or1, S[0], S[1], S[2], S[3], S[4], S[5], S[6], S[7]);
    or pa2(or2, S[8], S[9], S[10], S[11], S[12], S[13], S[14], S[15]);
    or pa3(or3, S[16], S[17], S[18], S[19], S[20], S[21], S[22], S[23]);
    or pa4(or4, S[24], S[25], S[26], S[27], S[28], S[29], S[30], S[31]);
    or noteq(isNotEqual, or1, or2, or3, or4);

    //isLessThan
    wire LT, not_LT;
    assign LT = S[31];
    not LTnotter(not_LT, LT);

    assign isLessThan = overflow ? not_LT : LT;

endmodule