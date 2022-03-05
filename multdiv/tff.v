module tff(q, t, clk, clr);
    input t, clk, clr;
    output q;

    wire OR_D, AND1_OR, AND2_OR, tNOT_AND1, Qout, QNOT_AND2;

    dffe_ref DFF(Qout, OR_D, 1'b1, clk, clr);
    or OR1(OR_D, AND1_OR, AND2_OR);
    and AND1(AND1_OR, Qout, tNOT_AND1);
    and AND2(AND2_OR, QNOT_AND2, t);
    not tNOT(tNOT_AND1, t);
    not QNOT(QNOT_AND2, Qout);

    assign q = Qout;

endmodule