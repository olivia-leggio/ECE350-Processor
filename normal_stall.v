module normal_stall(do_stall, op_X, op_D, rs_D, rt_D, rd_X);
    output do_stall;
    input [4:0] op_X, op_D, rs_D, rt_D, rd_X;

    wire do_stall;
    wire is_load, check_rs, check_rt, not_store;

    assign is_load = (op_X == 5'b01000);
    assign check_rs = (rs_D == rd_X);
    assign check_rt = (rt_D == rd_X);
    assign not_store = (op_D != 5'b00111);

    assign do_stall = is_load && (check_rs || (check_rt && not_store));

endmodule