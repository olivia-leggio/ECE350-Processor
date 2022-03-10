module check_readwrite(A_reads_rs, B_reads_rt, B_reads_rd, M_writes_rd, W_writes_rd, op_X, op_M, op_W);
    input [4:0] op_X, op_M, op_W;
    output A_reads_rs, B_reads_rt, B_reads_rd, M_writes_rd, W_writes_rd;

    wire xs0, xs1, xs2, xs3, xs4;
    wire m0, m1, m2, m3, m4;
    wire w0, w1, w2, w3, w4;

    assign xs0 = op_X[0];
    assign xs1 = op_X[1];
    assign xs2 = op_X[2];
    assign xs3 = op_X[3];
    assign xs4 = op_X[4];

    assign m0 = op_M[0];
    assign m1 = op_M[1];
    assign m2 = op_M[2];
    assign m3 = op_M[3];
    assign m4 = op_M[4];

    assign w0 = op_W[0];
    assign w1 = op_W[1];
    assign w2 = op_W[2];
    assign w3 = op_W[3];
    assign w4 = op_W[4];

    wire basicALU = (~xs4 & ~xs3 & ~xs2 & ~xs1 & ~xs0); //00000
    wire addi     = (~xs4 & ~xs3 &  xs2 & ~xs1 &  xs0); //00101
    wire sw       = (~xs4 & ~xs3 &  xs2 &  xs1 &  xs0); //00111
    wire lw       = (~xs4 &  xs3 & ~xs2 & ~xs1 & ~xs0); //01000
    wire bne      = (~xs4 & ~xs3 & ~xs2 &  xs1 & ~xs0); //00010
    wire blt      = (~xs4 & ~xs3 &  xs2 &  xs1 & ~xs0); //00110
    wire jr       = (~xs4 & ~xs3 &  xs2 & ~xs1 & ~xs0); //00100


    assign A_reads_rs = basicALU | addi | sw | lw | bne | blt;
    assign B_reads_rt = basicALU;
    assign B_reads_rd = bne | jr | blt;

    assign M_writes_rd = (~m4 & ~m2 & ~m1 & ~m0) | //00000 or 01000
                         (~m4 & ~m3 &  m2 & ~m1 &  m0); //00101 addi

    assign W_writes_rd = (~w4 & ~w2 & ~w1 & ~w0) | //00000 or 01000
                         (~w4 & ~w3 &  w2 & ~w1 &  w0); //00101 addi

endmodule