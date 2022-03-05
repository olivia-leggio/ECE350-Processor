module mytristate(out, in, out_enable);
    input out_enable;
    input [31:0] in;
    output [31:0] out;

    assign out = out_enable ? in : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
endmodule