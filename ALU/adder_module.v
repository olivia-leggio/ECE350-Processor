module adder_module(S, G, P, A, B, c0);
    input [7:0] A, B;
    input c0;
    output [7:0] S;
    output G, P;

    wire p0, g0, p1, g1, p2, g2, p3, g3, p4, g4, p5, g5, p6, g6, p7, g7;
    wire c1, c2, c3, c4, c5, c6, c7;                 //carries
    
    wire c11;                                        //c1 parts
    wire c21, c22;                                   //c2 parts
    wire c31, c32, c33;                              //c3 parts
    wire c41, c42, c43, c44;                         //c4 parts
    wire c51, c52, c53, c54, c55;                    //c5 parts
    wire c61, c62, c63, c64, c65, c66;               //c6 parts
    wire c71, c72, c73, c74, c75, c76, c77;          //c7 parts
    wire c81, c82, c83, c84, c85, c86, c87, c88;     //c8 parts

//~~~~~~~~~~~~~~~~generate and propagate functions~~~~~~~~~~~~~~~~~~//

    or P0(p0, A[0], B[0]);
    and G0(g0, A[0], B[0]);

    or P1(p1, A[1], B[1]);
    and G1(g1, A[1], B[1]);

    or P2(p2, A[2], B[2]);
    and G2(g2, A[2], B[2]);

    or P3(p3, A[3], B[3]);
    and G3(g3, A[3], B[3]);

    or P4(p4, A[4], B[4]);
    and G4(g4, A[4], B[4]);

    or P5(p5, A[5], B[5]);
    and G5(g5, A[5], B[5]);

    or P6(p6, A[6], B[6]);
    and G6(g6, A[6], B[6]);

    or P7(p7, A[7], B[7]);
    and G7(g7, A[7], B[7]);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~carries~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //c1
    and c1and1(c11, c0, p0);
    or c1or(c1, c11, g0);

    //c2
    and c2and1(c21, c0, p0, p1);
    and c2and2(c22, g0, p1);
    or c2or(c2, c21, c22, g1);

    //c3
    and c3and1(c31, c0, p0, p1, p2);
    and c3and2(c32, g0, p1, p2);
    and c3and3(c33, g1, p2);
    or c3or(c3, c31, c32, c33, g2);

    //c4
    and c4and1(c41, c0, p0, p1, p2, p3);
    and c4and2(c42, g0, p1, p2, p3);
    and c4and3(c43, g1, p2, p3);
    and c4and4(c44, g2, p3);
    or c4or(c4, c41, c42, c43, c44, g3);

    //c5
    and c5and1(c51, c0, p0, p1, p2, p3, p4);
    and c5and2(c52, g0, p1, p2, p3, p4);
    and c5and3(c53, g1, p2, p3, p4);
    and c5and4(c54, g2, p3, p4);
    and c5and5(c55, g3, p4);
    or c5or(c5, c51, c52, c53, c54, c55, g4);

    //c6
    and c6and1(c61, c0, p0, p1, p2, p3, p4, p5);
    and c6and2(c62, g0, p1, p2, p3, p4, p5);
    and c6and3(c63, g1, p2, p3, p4, p5);
    and c6and4(c64, g2, p3, p4, p5);
    and c6and5(c65, g3, p4, p5);
    and c6and6(c66, g4, p5);
    or c6or(c6, c61, c62, c63, c64, c65, c66, g5);

    //c7
    and c7and1(c71, c0, p0, p1, p2, p3, p4, p5, p6);
    and c7and2(c72, g0, p1, p2, p3, p4, p5, p6);
    and c7and3(c73, g1, p2, p3, p4, p5, p6);
    and c7and4(c74, g2, p3, p4, p5, p6);
    and c7and5(c75, g3, p4, p5, p6);
    and c7and6(c76, g4, p5, p6);
    and c7and7(c77, g5, p6);
    or c7or(c7, c71, c72, c73, c74, c75, c76, c77, g6);

    //generate G
    and c8and1(c81, c0, p0, p1, p2, p3, p4, p5, p6, p7);
    and c8and2(c82, g0, p1, p2, p3, p4, p5, p6, p7);
    and c8and3(c83, g1, p2, p3, p4, p5, p6, p7);
    and c8and4(c84, g2, p3, p4, p5, p6, p7);
    and c8and5(c85, g3, p4, p5, p6, p7);
    and c8and6(c86, g4, p5, p6, p7);
    and c8and7(c87, g5, p6, p7);
    and c8and8(c88, g6, p7);
    or c8or(G,c81, c82, c83, c84, c85, c86, c87, c88, g7);

    //generate P
    and genP(P, p0, p1, p2, p3, p4, p5, p6, p7);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sums~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    xor sum0(S[0], A[0], B[0], c0);
    xor sum1(S[1], A[1], B[1], c1);
    xor sum2(S[2], A[2], B[2], c2);
    xor sum3(S[3], A[3], B[3], c3);
    xor sum4(S[4], A[4], B[4], c4);
    xor sum5(S[5], A[5], B[5], c5);
    xor sum6(S[6], A[6], B[6], c6);
    xor sum7(S[7], A[7], B[7], c7);
    
endmodule