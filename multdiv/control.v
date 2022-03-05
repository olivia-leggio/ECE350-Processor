module control(ctrl_mux, ctrl_sub, in);
    input[2:0] in;
    output [1:0] ctrl_mux;
    output ctrl_sub;

    assign ctrl_mux[0] = in[0]^in[1];
    assign ctrl_mux[1] = ((~in[2])&in[1]&in[0])|(in[2]&(~in[1])&(~in[0]));
    assign ctrl_sub = (in[2]&(~in[1]))|(in[2]&(~in[0]));

endmodule