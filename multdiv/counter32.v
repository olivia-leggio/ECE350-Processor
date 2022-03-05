module counter32(flag, clk, clr);
    input clk, clr;
    output flag;

    wire [31:0] adder_in, to_adder;
    wire [31:0] adder_out;
    wire adder_INE, adder_ILT, adder_overflow;

    assign to_adder = clr ? 32'b0 : adder_in;

    adder32 adder(adder_out, adder_INE, adder_ILT, adder_overflow, to_adder, 32'b00000000000000000000000000000001, 1'b0);

    assign adder_in [31:6] = 26'b0;

    dffe_ref bit0(adder_in[0], adder_out[0], clk, 1'b1, clr);
    dffe_ref bit1(adder_in[1], adder_out[1], clk, 1'b1, clr);
    dffe_ref bit2(adder_in[2], adder_out[2], clk, 1'b1, clr);
    dffe_ref bit3(adder_in[3], adder_out[3], clk, 1'b1, clr);
    dffe_ref bit4(adder_in[4], adder_out[4], clk, 1'b1, clr);
    dffe_ref bit5(adder_in[5], adder_out[5], clk, 1'b1, clr);

    //assign flag = adder_in[0]&adder_in[1]&adder_in[2]&adder_in[3];
    assign flag = adder_in[5];
endmodule