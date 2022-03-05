module one_register(ouputs, in, clk, reset, in_en);
    input [31:0] in;
    input clk, reset, in_en, out_en;
    output [31:0] ouputs;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~32 dffe~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    dffe_ref reg0(ouputs[0], in[0], clk, in_en, reset);
    dffe_ref reg1(ouputs[1], in[1], clk, in_en, reset);
    dffe_ref reg2(ouputs[2], in[2], clk, in_en, reset);
    dffe_ref reg3(ouputs[3], in[3], clk, in_en, reset);

    dffe_ref reg4(ouputs[4], in[4], clk, in_en, reset);
    dffe_ref reg5(ouputs[5], in[5], clk, in_en, reset);
    dffe_ref reg6(ouputs[6], in[6], clk, in_en, reset);
    dffe_ref reg7(ouputs[7], in[7], clk, in_en, reset);

    dffe_ref reg8(ouputs[8], in[8], clk, in_en, reset);
    dffe_ref reg9(ouputs[9], in[9], clk, in_en, reset);
    dffe_ref reg10(ouputs[10], in[10], clk, in_en, reset);
    dffe_ref reg11(ouputs[11], in[11], clk, in_en, reset);

    dffe_ref reg12(ouputs[12], in[12], clk, in_en, reset);
    dffe_ref reg13(ouputs[13], in[13], clk, in_en, reset);
    dffe_ref reg14(ouputs[14], in[14], clk, in_en, reset);
    dffe_ref reg15(ouputs[15], in[15], clk, in_en, reset);

    dffe_ref reg16(ouputs[16], in[16], clk, in_en, reset);
    dffe_ref reg17(ouputs[17], in[17], clk, in_en, reset);
    dffe_ref reg18(ouputs[18], in[18], clk, in_en, reset);
    dffe_ref reg19(ouputs[19], in[19], clk, in_en, reset);

    dffe_ref reg20(ouputs[20], in[20], clk, in_en, reset);
    dffe_ref reg21(ouputs[21], in[21], clk, in_en, reset);
    dffe_ref reg22(ouputs[22], in[22], clk, in_en, reset);
    dffe_ref reg23(ouputs[23], in[23], clk, in_en, reset);

    dffe_ref reg24(ouputs[24], in[24], clk, in_en, reset);
    dffe_ref reg25(ouputs[25], in[25], clk, in_en, reset);
    dffe_ref reg26(ouputs[26], in[26], clk, in_en, reset);
    dffe_ref reg27(ouputs[27], in[27], clk, in_en, reset);

    dffe_ref reg28(ouputs[28], in[28], clk, in_en, reset);
    dffe_ref reg29(ouputs[29], in[29], clk, in_en, reset);
    dffe_ref reg30(ouputs[30], in[30], clk, in_en, reset);
    dffe_ref reg31(ouputs[31], in[31], clk, in_en, reset);

    /*
    genvar i;
    generate
        for(i=0; i<32; i=i+1) begin : genreg
            dffe_ref regi(.q(outputs[i]), .d(in[i]), .clk(clk), .en(in_en), .clr(reset));
            tristate trii(.out(out[i]), .in(outputs[i]), .out_enable(out_en));
        end
    endgenerate
    */
endmodule