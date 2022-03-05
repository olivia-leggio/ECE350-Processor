module tristate1(out, in, sel);
    input in;
    output out;
    input sel;

    assign out = sel ? in : 1'bz;

endmodule