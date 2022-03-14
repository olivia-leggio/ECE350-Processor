/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */


    /**
     * WIRE DEFINITIONS
     * Y = stage letter (F, D, X, M, W)
     *---------------------------------------------*
     * op_Y          - opcode for stage Y
     * rd_Y          - rd for stage Y
     * rs_Y          - rs for stage Y
     * rt_Y          - rt for stage Y
     * shamt_Y       - shamt for stage Y
     * ALU_Y         - ALU_op for stage Y
     * imm_Y         - 32 bit sign extended immediate for stage Y
     * targ_Y        - target field for stage Y
     *
     * PC_Y          - PC for stage Y
     * instr_Y       - instruction for stage Y
    */


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //-------------------------------------------- F STAGE --------------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

        wire [31:0] PC_F;
        wire [31:0] PC_plus_one;
        wire [31:0] ext_PC;
        wire [31:0] new_PC;


        //target of jump instruction
        assign ext_PC[26:0] = targ_X[26:0];
        assign ext_PC[31:27] = 5'b00000;


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Adder ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire INE_F, ILT_F, OVF_F;
        adder32 PCplusOne(PC_plus_one, INE_F, ILT_F, OVF_F, PC_F, 32'b00000000000000000000000000000001, 1'b0);
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PC Register ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [31:0] jump_or_normal;
        assign jump_or_normal = ctrl_j ? ext_PC : PC_plus_one;
        //tristate32 non_jr(new_PC, jump_or_normal, ~ctrl_jr);
        //tristate32 jr_case(new_PC, ALU_B_bypassed, ctrl_jr);
        assign new_PC = ctrl_jr ? ALU_B_bypassed : jump_or_normal;

        one_register pc_reg(PC_F, new_PC, ~clock, reset, PC_en);

        //into imem
        assign address_imem = PC_F;


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ F Control ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire ctrl_j, ctrl_jr;
        decode_F decode_f(ctrl_j, ctrl_jr, op_X);





        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FD Latch~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire[31:0] into_FD;
        wire do_nop;
        assign do_nop = (ctrl_j | ctrl_jr);
        assign into_FD = do_nop ? 32'b0 : q_imem;
        FD_latch fd_latch(PC_D, PC1_D, instr_D, PC_F, PC_plus_one, into_FD, ~clock, reset, FD_en);

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //-------------------------------------------- D STAGE --------------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [31:0] PC_D, PC1_D, instr_D;
        wire [4:0] op_D, rd_D, rs_D, rt_D, shamt_D, ALU_D;
        wire [31:0] imm_D;
        wire [26:0] targ_D; 

        wire [31:0] A_read, B_read;

        instr_split split_D(op_D, rd_D, rs_D, rt_D, shamt_D, ALU_D, imm_D, targ_D, instr_D);


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~Data into Regfile~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [1:0] wreg_sel;
        assign wreg_sel[0] = ctrl_setx;
        assign wreg_sel[1] = ctrl_jal;
        fivebit_mux4 fb_mux4(ctrl_writeReg, rd_W, 5'b11110, 5'b11111, 5'b11111, wreg_sel);
            //00 = no setx or jal = write to rd from W stage
            //01 = setx = write to $30
            //10 = jal = write to $31
            //11 = should not be possible = write to $31

        assign ctrl_readRegA[4:0] = rs_D[4:0];
        //mux to choose between rt and rd
        assign ctrl_readRegB[4:0] = ctrl_readB ? rd_D[4:0] : rt_D[4:0];
        assign A_read[31:0] = data_readRegA[31:0];
        assign B_read[31:0] = data_readRegB[31:0];
        assign data_writeReg[31:0] = writeback[31:0];


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ D Control ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        //writeback and ctrl_writeEnable handled in W stage
        wire ctrl_readB;
        decode_D decode_d(ctrl_readB, op_D);

        //stall NOP insert
        wire [31:0] instr_into_DX;
        assign instr_into_DX = ctrl_DX_instr ? 32'b0 : instr_D;





        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DX Latch~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire[31:0] into_DX;
        assign into_DX = do_nop ? 32'b0 : instr_into_DX;
        DX_latch dx_latch(PC_X, PC1_X, instr_X, A_fromD, B_fromD, PC_D, PC1_D, into_DX, A_read, B_read, ~clock, reset, DX_en);

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //-------------------------------------------- X STAGE --------------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [31:0] PC_X, PC1_X, instr_X;
        wire [4:0] op_X, rd_X, rs_X, rt_X, shamt_X, ALU_X;
        wire [31:0] imm_X;
        wire [26:0] targ_X;

        wire[31:0] A_fromD, B_fromD;
        wire[31:0] into_ALU_A, into_ALU_B;
        wire[31:0] ALU_out;

        instr_split split_X(op_X, rd_X, rs_X, rt_X, shamt_X, ALU_X, imm_X, targ_X, instr_X);


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ X Control ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire ALU_B_ctrl, op_ctrl, is_mult, is_div;
        decode_X decode_x(ALU_B_ctrl, op_ctrl, is_mult, is_div, op_X, ALU_X);


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ALU ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        assign into_ALU_B = ALU_B_ctrl ? imm_X : ALU_B_bypassed;

        wire INE, ILT, OVF;
        wire [4:0] into_ALU_op;

        assign into_ALU_op = op_ctrl ? 5'b00000 : ALU_X;
        alu ALU(into_ALU_A, into_ALU_B, into_ALU_op, shamt_X, ALU_out, INE, ILT, OVF);
        


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MULTDIV ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire is_multdiv;
        or multdiver(is_multdiv, is_mult, is_div);

        //multdiv inputs
        wire [31:0] md_A, md_B;
        tristate32 mdA(md_A, into_ALU_A, is_multdiv);
        tristate32 mdB(md_B, ALU_B_bypassed, is_multdiv);
        //store previous enable to ensure multdiv ctrl on for one cycle only
        wire ctrl_mult, ctrl_div, prev_enable;
        dffe_ref prev_en(prev_enable, DX_en, ~clock, 1'b1, 1'b0);
        assign ctrl_mult = prev_enable & is_mult;
        assign ctrl_div = prev_enable & is_div;

        //multdiv outputs
        wire multdiv_exception, multdiv_RDY;
        wire [31:0] multdiv_result;

        multdiv multiplierdivider(md_A, md_B, ctrl_mult, ctrl_div, clock, multdiv_result, multdiv_exception, multdiv_RDY);


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~ X STAGE OUTPUT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [31:0] X_out;

        assign X_out = is_multdiv ? multdiv_result : ALU_out;





        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~XM Latch~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        XM_latch xm_latch(PC_M, PC1_M, instr_M, O_fromX, B_fromX, PC_X, PC1_X, instr_X, X_out, ALU_B_bypassed, ~clock, reset, XM_en);

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //-------------------------------------------- M STAGE --------------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [31:0] PC_M, PC1_M, instr_M;
        wire [4:0] op_M, rd_M, rs_M, rt_M, shamt_M, ALU_M;
        wire [31:0] imm_M;
        wire [26:0] targ_M;

        wire [31:0] O_fromX, B_fromX;

        instr_split split_M(op_M, rd_M, rs_M, rt_M, shamt_M, ALU_M, imm_M, targ_M, instr_M);


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ M Control ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        assign wren = (op_M == 5'b00111);
        assign address_dmem = O_fromX;






        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MW Latch~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        MW_latch mw_latch(PC_W, PC1_W, instr_W, O_fromM, D_fromM, PC_M, PC1_M, instr_M, O_fromX, q_dmem, ~clock, reset, MW_en);

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //-------------------------------------------- W STAGE --------------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [31:0] PC_W, PC1_W, instr_W;
        wire [4:0] op_W, rd_W, rs_W, rt_W, shamt_W, ALU_W;
        wire [31:0] imm_W;
        wire [26:0] targ_W;

        wire[31:0] O_fromM, D_fromM;
        wire [31:0] writeback, arith_writeback, ext_targ_W;
        wire ctrl_writeback, ctrl_setx, ctrl_jal;

        instr_split split_W(op_W, rd_W, rs_W, rt_W, shamt_W, ALU_W, imm_W, targ_W, instr_W);


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ W Control ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        decode_W decode_w(ctrl_writeEnable, ctrl_writeback, ctrl_setx, ctrl_jal, op_W);

        assign ext_targ_W[26:0] = targ_W[26:0];
        assign ext_targ_W[31:27] = 5'b00000;

        assign arith_writeback[31:0] = ctrl_writeback ? D_fromM : O_fromM;

        wire [1:0] writeback_sel;
        assign writeback_sel[0] = ctrl_setx;
        assign writeback_sel[1] = ctrl_jal;
        mux4 writeback_mux(writeback, arith_writeback, ext_targ_W, PC1_W, PC1_W, writeback_sel);
            //00 = normal arithmetic = write data from M stage
            //01 = setx = write extended target
            //10 = jal = write PC+1
            //11 = shouldn't be possible = write PC+1





    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //------------------------------------ BYPASS AND STALL LOGIC -------------------------------------//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        //----------BYPASS-------------
        wire A_reads_rs;
        wire B_reads_rt;
        wire B_reads_rd;
        wire M_writes_rd;
        wire W_writes_rd;
        wire M_nonzero;
        wire W_nonzero;

        check_readwrite checks_rw(A_reads_rs, B_reads_rt, B_reads_rd, M_writes_rd, W_writes_rd, op_X, op_M, op_W);

        assign M_nonzero = (rd_M[4] | rd_M[3] | rd_M[2] | rd_M[1] | rd_M[0]);
        assign W_nonzero = (rd_W[4] | rd_W[3] | rd_W[2] | rd_W[1] | rd_W[0]);


        //ALU A bypassing
        wire [1:0] ALU_A_select;
        assign ALU_A_select[0] = (rs_X == rd_W) & A_reads_rs & W_writes_rd & W_nonzero;
        assign ALU_A_select[1] = (rs_X == rd_M) & A_reads_rs & M_writes_rd & M_nonzero;
        mux4 A_bypass(into_ALU_A, A_fromD, writeback, O_fromX, O_fromX, ALU_A_select);
        //ALU B bypassing
        wire [31:0] ALU_B_bypassed;
        wire [1:0] ALU_B_select;
        assign ALU_B_select[0] = (((rt_X == rd_W) & B_reads_rt) | ((rd_X == rd_W) & B_reads_rd)) & W_writes_rd & W_nonzero;
        assign ALU_B_select[1] = (((rt_X == rd_M) & B_reads_rt) | ((rd_X == rd_M) & B_reads_rd)) & M_writes_rd & M_nonzero;
        mux4 B_bypass(ALU_B_bypassed, B_fromD, writeback, O_fromX, O_fromX, ALU_B_select);

        //data bypassing
        wire data_select;
        assign data_select = (rd_W == rd_M) & W_writes_rd & W_nonzero;
        assign data = data_select ? writeback : B_fromX;
        



        
        //-----------STALL-------------
        //load/addi stall
        wire PC_en, FD_en, DX_en, XM_en, MW_en;
        wire ctrl_DX_instr;

        normal_stall staller(PC_en, FD_en, ctrl_DX_instr, op_X, op_D, rs_D, rt_D, rd_X);

        //multdiv stall
        wire multdiv_stall;
        dffe_ref md_storer(multdiv_stall, is_multdiv, clock, 1'b1, multdiv_RDY);

        assign PC_en = ~multdiv_stall;
        assign FD_en = ~multdiv_stall;
        assign DX_en = ~multdiv_stall;
        assign XM_en = ~multdiv_stall;
        assign MW_en = ~multdiv_stall;


        //temp, remove when multdiv stall implemented
        //assign DX_en = 1'b1;
        //assign XM_en = 1'b1;
        //assign MW_en = 1'b1;

	/* END CODE */

endmodule
