`timescale 1ns/100ps
module sll_tb;
    wire [31:0] in;
    wire [4:0] shamt;
    wire [31:0] out;

    sll shifter(out, in, shamt);

    assign in = 252645135; //00001111000011110000111100001111

    integer i;
    assign shamt = i;
    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            #20

            $display("%b:   %b\n", shamt, out);
        end
        $finish;
    end
endmodule