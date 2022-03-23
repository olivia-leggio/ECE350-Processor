//`include "adder32.v"
//`include "and32.v"
//`include "or32.v"
//`include "sll.v"
//`include "sra.v"
//`include "mux8.v"
//`include "not32.v"

module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] adder_out, and_out, or_out, sll_out, sra_out, not_out, B_in, mux6, mux7;
    assign mux6 = 0;
    assign mux7 = 0;

//~~~~~~~~~~~~~~~~~~~~~~~~basic modules~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //adder module
    //LSB of opcode determines carry-in for subtract
    adder32 adder(adder_out, isNotEqual, isLessThan, overflow, data_operandA, B_in, ctrl_ALUopcode[0]);

    //and module
    and32 ander(and_out, data_operandA, data_operandB);

    //or module
    or32 orrer(or_out, data_operandA, data_operandB);

    //sll module
    sll sll(sll_out, data_operandA, ctrl_shiftamt);

    //sra module
    sra sra(sra_out, data_operandA, ctrl_shiftamt);

    //not module
    not32 notter(not_out, data_operandB);

    //selects which to output
    mux8 selector(data_result, adder_out, adder_out, and_out, or_out, sll_out, sra_out, mux6, mux7, ctrl_ALUopcode);


//~~~~~~~~~~~~~~~~~~~~~~~extra processing~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    //subtract processing
    assign B_in = ctrl_ALUopcode[0] ? not_out : data_operandB;

endmodule