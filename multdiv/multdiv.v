module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [31:0] mult_out, div_out;
    wire controls, was_MULT, was_DIV, mult_rdy, div_rdy, mult_ex, div_ex;

    multiplier multiply(data_operandA, data_operandB, 
        ctrl_MULT, ctrl_DIV, 
        clock, 
        mult_out, mult_ex, mult_rdy);

    divider divide(data_operandA, data_operandB, 
        ctrl_MULT, ctrl_DIV, 
        clock, 
        div_out, div_ex, div_rdy);

    or orrer(controls, ctrl_MULT, ctrl_DIV);

    dffe_ref mult(was_MULT, ctrl_MULT, clock, controls, 1'b0);
    dffe_ref div(was_DIV, ctrl_DIV, clock, controls, 1'b0);

    tristate32 domult(data_result, mult_out, was_MULT);
    tristate32 dodiv(data_result, div_out, was_DIV);

    tristate1 multrdy(data_resultRDY, mult_rdy, was_MULT);
    tristate1 divrdy(data_resultRDY, div_rdy, was_DIV);

    tristate1 multex(data_exception, mult_ex, was_MULT);
    tristate1 divex(data_exception, div_ex, was_DIV);

endmodule