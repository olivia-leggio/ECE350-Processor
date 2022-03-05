//include "counter32.v"
module divider(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;


//~~~~~~~~~~~~~~~~~~~~~~~~~Adder MUX~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    wire [31:0] NOT_out, toAdd, fixedB, negB;
    wire ctrl_SUB;
    assign ctrl_SUB = ~from_shift[31];

    negate negateB(negB, data_operandB);
    assign fixedB = data_operandB[31] ? negB : data_operandB;

    not32 div_inverter(NOT_out, fixedB);
    assign toAdd = ctrl_SUB ? NOT_out : fixedB;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~Adder~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    wire [31:0] adder_out, from_shift;
    wire adder_INE, adder_ILT, adder_overflow;

    adder32 adder(adder_out, adder_INE, adder_ILT, adder_overflow, from_shift, toAdd, ctrl_SUB);

//~~~~~~~~~~~~~~~~~~~~~~Ouput sections~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    wire [31:0] top32, low32, negA, fixedA;
    wire [31:0] reg_back;
    wire [64:0] reg_in, reg_out, post_shift;
    //assign data_result and from_shift(goes to adder)

    assign top32 = ctrl_DIV ? 32'b0 : adder_out;
    //32'b00000000000000000000000000000000
    assign reg_back[0] = ~adder_out[31];

    negate negateA(negA, data_operandA);
    assign fixedA = data_operandA[31] ? negA : data_operandA;

    assign low32 = ctrl_DIV ? fixedA : reg_back;
    assign reg_in[63:32] = top32[31:0];
    assign reg_in[31:0] = low32[31:0];
    assign reg_in[64] = 1'b0;

    //stores value in reused 65 bit register, useless MSB
    reg65 div_reg(reg_out, reg_in, clock);

    //compute result, negate if needed
    wire [31:0] negRes, dataq;
    wire xorRes;

    assign dataq[31:0] = reg_out[31:0];
    xor xorer(xorRes, data_operandA[31], data_operandB[31]);

    negate negateRes(negRes, dataq);
    assign data_result = xorRes ? negRes : dataq;

    //65 bit shifter with useless MSB
    assign post_shift = reg_out << 1;
    //shifter outputs
    assign from_shift[31:0] = post_shift[63:32];
    assign reg_back[31:1] = post_shift[31:1];

    //counter
    counter32 div_cntr(data_resultRDY, clock, ctrl_DIV);

    //exception
    assign data_exception = ~(data_operandB[0]|data_operandB[1]|data_operandB[2]|data_operandB[3]|data_operandB[4]|data_operandB[5]|data_operandB[6]|data_operandB[7]|data_operandB[8]|data_operandB[9]|data_operandB[10]|data_operandB[11]|data_operandB[12]|data_operandB[13]|data_operandB[14]|data_operandB[15]|data_operandB[16]|data_operandB[17]|data_operandB[18]|data_operandB[19]|data_operandB[20]|data_operandB[21]|data_operandB[22]|data_operandB[23]|data_operandB[24]|data_operandB[25]|data_operandB[26]|data_operandB[27]|data_operandB[28]|data_operandB[29]|data_operandB[30]|data_operandB[31]);

endmodule