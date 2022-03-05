module overflow(flag, in);
    input [32:0] in;
    output flag;

    wire is_ones;
    wire is_zeros;

    assign is_ones = (in[32]&in[31]&in[31]&in[29]&in[28]&in[27]&in[26]&in[25]&in[24])&
                     (in[23]&in[22]&in[21]&in[20]&in[19]&in[18]&in[17]&in[16])&
                     (in[15]&in[14]&in[13]&in[12]&in[11]&in[10]&in[9]&in[8])&
                     (in[7]&in[6]&in[5]&in[4]&in[3]&in[2]&in[1]&in[0]);

    assign is_zeros = ~((in[32]|in[31]|in[31]|in[29]|in[28]|in[27]|in[26]|in[25]|in[24])|
                       (in[23]|in[22]|in[21]|in[20]|in[19]|in[18]|in[17]|in[16])|
                       (in[15]|in[14]|in[13]|in[12]|in[11]|in[10]|in[9]|in[8])|
                       (in[7]|in[6]|in[5]|in[4]|in[3]|in[2]|in[1]|in[0]));

    assign flag = ~(is_ones|is_zeros);

endmodule