module instr_split(op, rd, rs, rt, shamt, ALUop, ext_imm, targ, curr);
    input [31:0] curr;
    output [4:0] op, rd, rs, rt, shamt, ALUop;
    output [31:0] ext_imm;
    output [26:0] targ;

    assign op[4:0] = curr[31:27];
    assign rd[4:0] = curr[26:22];
    assign rs[4:0] = curr[21:17];
    assign rt[4:0] = curr[16:12];
    assign shamt[4:0] = curr[11:7];
    assign ALUop[4:0] = curr[6:2];
    assign targ[26:0] = curr[26:0];

    assign ext_imm[16:0] = curr[16:0];
    assign ext_imm[31:17] = curr[16] ? 15'b111111111111111 : 15'b000000000000000;

endmodule