//include "counter_module.v"
module multiplier(
    data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;


//~~~~~~~~~~~~~~~~~~~~~~~~~Adder MUX~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    wire [31:0] lshift, MUX_out, NOT_out, toAdd;
    wire [1:0] ctrl_MUX;
    wire ctrl_SUB;
    assign lshift = data_operandA << 1;

    mux4 MUX(MUX_out, 32'b00000000000000000000000000000000, data_operandA, lshift, 32'b00000000000000000000000000000000, ctrl_MUX);
    not32 inverter(NOT_out, MUX_out);
    assign toAdd = ctrl_SUB ? NOT_out : MUX_out;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~Adder~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    wire [31:0] adder_out, from_reg;
    wire adder_INE, adder_ILT, adder_overflow;

    adder32 adder(adder_out, adder_INE, adder_ILT, adder_overflow, toAdd, from_reg, ctrl_SUB);

//~~~~~~~~~~~~~~~~~~~~~~Ouput sections~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    wire [64:0] to_shift, post_shift, reg_in, reg_out;
    wire [2:0] to_control;
    
    assign to_shift[64:33] = adder_out[31:0];
    assign to_shift[32:0] = reg_out[32:0];

    assign post_shift[64] = to_shift[64];
    assign post_shift[63] = to_shift[64];
    assign post_shift[62:0] = to_shift[64:2];

    assign reg_in[64:33] = ctrl_MULT ? 32'b0 : post_shift[64:33];
    assign reg_in[32:1] = ctrl_MULT ? data_operandB : post_shift[32:1];
    assign reg_in[0] = ctrl_MULT ? 1'b0 : post_shift[0];
    
    reg65 adder_reg(reg_out, reg_in, clock);


    //assign output
    assign data_result[31:0] = reg_out[32:1];
    
    //assign exception
    wire overflow1, overflow2;
    overflow checker(overflow1, reg_out[64:32]);
    and ovfer(overflow2, data_operandA[31], data_operandB[31], data_result[31]);
    or resulter(data_exception, overflow1, overflow2);

    //back to adder
    assign from_reg[31:0] = reg_out[64:33];
    //last 3 bits go to control
    assign to_control[2:0] = reg_out[2:0];


    //counter
    counter_module cntr(data_resultRDY, clock, ctrl_MULT);

 //~~~~~~~~~~~~~~~~~~~~~~~Control logic~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    control control_logic(ctrl_MUX, ctrl_SUB, to_control);

endmodule