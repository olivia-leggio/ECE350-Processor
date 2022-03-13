module fivebit_mux4(out, in1, in2, in3, in4, sel);
    input [4:0] in1, in2, in3, in4;
        //in1 = 00
        //in2 = 01
        //in3 = 10
        //in4 = 11
    input [1:0] sel;
    output [4:0] out;

    wire [4:0] part1, part2;

    assign part1 = sel[0] ? in2 : in1;
    assign part2 = sel[0] ? in4 : in3;

    assign out = sel[1] ? part2 : part1;

endmodule