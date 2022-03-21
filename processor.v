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
        wire do_normal, jump_bex;
        assign do_normal = ~(ctrl_j | ctrl_jr | ctrl_branch | ctrl_bex);
        assign jump_bex = (ctrl_j | ctrl_bex);
        tristate32 normal_PC(new_PC, PC_plus_one, do_normal);               //PC = PC+1
        tristate32 j_jal_bex(new_PC, ext_PC, jump_bex);                     //PC = targ_X
        tristate32 jr_case(new_PC, ALU_B_bypassed, ctrl_jr);                //PC = PC = rd_X
        tristate32 branch_case(new_PC, branch_PC, ctrl_branch);             //PC = PC + 1 + imm_X

        one_register pc_reg(PC_F, new_PC, ~clock, reset, PC_en);

        //into imem
        assign address_imem = PC_F;


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ F Control ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire ctrl_j, ctrl_jr;
        decode_F decode_f(ctrl_j, ctrl_jr, op_X);










        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FD Latch~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire[31:0] into_FD;
        wire do_nop;
        assign do_nop = (ctrl_j | ctrl_jr | ctrl_branch | ctrl_bex); //inserts NOP when jumping or branching, extends to DX latch
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

        //mux to choose between rs and $r30 ($rstatus)
        assign ctrl_readRegA[4:0] = is_bex_D ? 5'b11110 : rs_D[4:0];

        //mux to choose between rt, rd, and $r0 (on bex)
        wire [1:0] readB_sel;
        assign readB_sel[0] = ctrl_readB;
        assign readB_sel[1] = is_bex_D;
        fivebit_mux4 readBmux(ctrl_readRegB, rt_D, rd_D, 5'b00000, 5'b00000, readB_sel);
            //00 = read rt
            //01 = read rd on ctrl_readB signal
            //10 = read $r0 on bex
            //11 = should not be possible = read $r0

        //read and write to regfile module
        assign A_read[31:0] = data_readRegA[31:0];
        assign B_read[31:0] = data_readRegB[31:0];
        assign data_writeReg[31:0] = writeback[31:0];


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ D Control ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        //writeback and ctrl_writeEnable handled in W stage
        wire ctrl_readB, is_bex_D;
        decode_D decode_d(ctrl_readB, is_bex_D, op_D);

        //stall NOP insert
        wire [31:0] instr_into_DX;
        //assign instr_into_DX = ctrl_DX_instr ? 32'b0 : instr_D;

        tristate32 instr1(instr_into_DX, instr_D, ~short_stall);
        tristate32 instr2(instr_into_DX, 32'b0, ctrl_DX_instr);
        tristate32 instr3(instr_into_DX, setx_insert, ctrl_exc);











        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DX Latch~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire[31:0] into_DX, DX_A, DX_B;
        assign into_DX = do_nop ? 32'b0 : instr_into_DX;
        assign DX_A = do_nop ? 32'b0 : A_read;
        assign DX_B = do_nop ? 32'b0 : B_read;
        DX_latch dx_latch(PC_X, PC1_X, instr_X, A_fromD, B_fromD, PC_D, PC1_D, into_DX, DX_A, DX_B, ~clock, reset, DX_en);

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
        wire ALU_B_ctrl, op_ctrl, is_mult, is_div, is_bne, is_blt, is_bex_X;
        decode_X decode_x(ALU_B_ctrl, op_ctrl, is_mult, is_div, is_bne, is_blt, is_bex_X, op_X, ALU_X);


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ALU ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        assign into_ALU_B = ALU_B_ctrl ? imm_X : ALU_B_bypassed;

        wire INE, ILT, OVF;
        wire [4:0] into_ALU_op;
        wire [1:0] ALU_op_sel;
            assign ALU_op_sel[0] = op_ctrl;
            assign ALU_op_sel[1] = (ctrl_branch | is_bex_X);

        //assign into_ALU_op = op_ctrl ? 5'b00000 : ALU_X;
        fivebit_mux4 ALUop_mux(into_ALU_op, ALU_X, 5'b00000, 5'b00001, 5'b00001, ALU_op_sel);
            //00 = take the ALU op from the DX latch
            //01 = op_ctrl on = put in 00000 for addi instruction
            //10 = ctrl_branch or is_bex_X on = put in 00001 for subtraction to compare rs to rd
            //11 = should not be possible
        
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


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EXCEPTION LOGIC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire add_exc, addi_exc, sub_exc, mul_exc, div_exc;
        exception_checker check_exc(add_exc, addi_exc, sub_exc, mul_exc, div_exc, op_X, ALU_X, OVF, multdiv_exception);
        
        //1 if any exception is found
        wire ctrl_exc = (add_exc | addi_exc | sub_exc | mul_exc | div_exc);

        //setx instr to insert
        wire [31:0] setx_insert;
        tristate32  exc_add(setx_insert, 32'b10101000000000000000000000000001, add_exc);
        tristate32 exc_addi(setx_insert, 32'b10101000000000000000000000000010, addi_exc);
        tristate32  exc_sub(setx_insert, 32'b10101000000000000000000000000011, sub_exc);
        tristate32  exc_mul(setx_insert, 32'b10101000000000000000000000000100, mul_exc);
        tristate32  exc_div(setx_insert, 32'b10101000000000000000000000000101, div_exc);


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~ X STAGE OUTPUT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [31:0] X_out;

        assign X_out = is_multdiv ? multdiv_result : ALU_out;




        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BRANCHING ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        wire [31:0] branch_PC; //PC+1+extended immediate
        wire b_ine, b_ilt, b_ovf;
        adder32 branc_add(branch_PC, b_ine, b_ilt, b_ovf, PC_X, imm_X, 1'b1);

        wire branch_ILT, branch_INE;  //detects branch conditions; less than and not equal
        assign branch_INE = INE;
        assign branch_ILT = (~ILT & INE); //ALU ILT is rs < rd, branch needs rd < rs

        wire do_bne, do_blt;  //op code and condition match up
        assign do_bne = (is_bne & branch_INE);
        assign do_blt = (is_blt & branch_ILT);

        wire ctrl_branch;  //either branch taken
        assign ctrl_branch = (do_bne | do_blt); 
            //ctrl_branch used in X stage to make ALU subtract
            //ctrl_branch used in F stage as select bit for PC
            //ctrl_branch used in D stage and X stage for inserting NOP
        

        //bex op code and INE signal
        wire ctrl_bex;
        assign ctrl_bex = (is_bex_X & INE);











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
        wire rs_nonzero;

        check_readwrite checks_rw(A_reads_rs, B_reads_rt, B_reads_rd, M_writes_rd, W_writes_rd, op_X, op_M, op_W);

        assign M_nonzero = (rd_M[4] | rd_M[3] | rd_M[2] | rd_M[1] | rd_M[0]);
        assign W_nonzero = (rd_W[4] | rd_W[3] | rd_W[2] | rd_W[1] | rd_W[0]);
        assign rs_nonzero = (rs_X[4] | rs_X[3] | rs_X[2] | rs_X[1] | rs_X[0]);

        //----------ALU A BYPASSING-------------
        wire [1:0] ALU_A_select;
        wire [31:0] A_stage_one;
        assign ALU_A_select[0] = (rs_X == rd_W) & A_reads_rs & W_writes_rd & W_nonzero & rs_nonzero;
        assign ALU_A_select[1] = (rs_X == rd_M) & A_reads_rs & M_writes_rd & M_nonzero & rs_nonzero;
        mux4 A_bypass(A_stage_one, A_fromD, writeback, O_fromX, O_fromX, ALU_A_select);

        //bypassing exceptions
        //setx to bex
        wire M_setx, W_setx, no_setx;
        assign M_setx = (op_M == 5'b10101);
        assign W_setx = ((op_W == 5'b10101) & ~M_setx);
        assign no_setx = ~(M_bsetx | W_bsetx);

        wire [31:0] ext_targ_M;
        assign ext_targ_M[26:0] = targ_M[26:0];
        assign ext_targ_M[31:27] = 5'b00000;

        wire M_bsetx, W_bsetx;  //bex in X stage or rs_X reads $30
        assign M_bsetx = (M_setx & (is_bex_X | rs_reads30));
        assign W_bsetx = (W_setx & (is_bex_X | rs_reads30));

        tristate32 A_one(into_ALU_A, A_stage_one, no_setx);
        tristate32 Msetx(into_ALU_A, ext_targ_M, M_bsetx);
        tristate32 Wsetx(into_ALU_A, ext_targ_W, W_bsetx);


        //setx to $30 read
        wire rs30, rt30, rd30, rs_reads30, rt_reads30, rd_reads30;
        assign rs30 = (rs_X == 5'b11110);
        assign rt30 = (rt_X == 5'b11110);
        assign rd30 = (rd_X == 5'b11110);

        assign rs_reads30 = (rs30 & A_reads_rs);
        assign rt_reads30 = (rt30 & B_reads_rt);
        assign rd_reads30 = (rd30 & B_reads_rd);

        wire M_setx_bp, W_setx_bp, B_reads_30;
        assign B_reads_30 = (rt_reads30 | rd_reads30);
        assign M_setx_bp = (M_setx & B_reads_30);
        assign W_setx_bp = (W_setx & B_reads_30);



        
        //----------ALU B BYPASSING-------------
        wire [31:0] ALU_B_bypassed, B_stage_one;
        wire [1:0] ALU_B_select;
        assign ALU_B_select[0] = (((rt_X == rd_W) & B_reads_rt) | ((rd_X == rd_W) & B_reads_rd)) & W_writes_rd & W_nonzero;
        assign ALU_B_select[1] = (((rt_X == rd_M) & B_reads_rt) | ((rd_X == rd_M) & B_reads_rd)) & M_writes_rd & M_nonzero;
        mux4 B_bypass(B_stage_one, B_fromD, writeback, O_fromX, O_fromX, ALU_B_select);
            //00 = no bypassing case = use the B read from D stage
            //01 = WX bypass, use the W to regfile writeback value as the B in X
            //10 = MX bypass, use the ALU output that is now in M stage as the B in X
            //11 = if both M and W bypass to X, take the MX bypass value because it is more recent
                //useless case where M stage instr overwrites register written to in W stage instr

        //jal to jr
        wire M_jal, W_jal, no_jal, rd31;
        assign rd31 = (rd_X == 5'b11111);
        assign M_jal = (rd31 & (op_M == 5'b00011));
        assign W_jal = (rd31 & (op_W == 5'b00011) & ~M_jal);
        assign no_jal_setx_B = ~(M_jal | W_jal | M_setx_bp | W_setx_bp);

        tristate32 B_one(ALU_B_bypassed, B_stage_one, no_jal_setx_B);
        tristate32 Mjal(ALU_B_bypassed, PC1_M, M_jal);
        tristate32 Wjal(ALU_B_bypassed, PC1_W, W_jal);
        tristate32 Msetxbp(ALU_B_bypassed, ext_targ_M, M_setx_bp);
        tristate32 Wsetxbp(ALU_B_bypassed, ext_targ_W, W_setx_bp);
        

        //----------DATA BYPASSING--------------
        wire data_select;
        assign data_select = (rd_W == rd_M) & W_writes_rd & W_nonzero;
        assign data = data_select ? writeback : B_fromX;
        



        
        //-----------STALL-------------
        //load/addi stall
        wire PC_en, FD_en, DX_en, XM_en, MW_en;
        wire ctrl_DX_instr;

        wire normal_stall;
        assign ctrl_DX_instr = normal_stall;
        normal_stall staller(normal_stall, op_X, op_D, rs_D, rt_D, rd_X);

        //multdiv stall
        wire multdiv_stall;
        dffe_ref md_storer(multdiv_stall, is_multdiv, clock, 1'b1, multdiv_RDY);

        //selectors for enables:
            //normal_stall = load/addi case          stall PC and FD
            //multdiv_stall = multicycle multdiv     stall PC and FD
            //ctrl_exc = stall to insert setx        stall all latches
            //no_stall = no other stalls on          enable all latches
        
        //if no other stalls on
        wire no_stall = ~(normal_stall | multdiv_stall | ctrl_exc);
        //stall just PC and FD latches
        wire short_stall = ((normal_stall | ctrl_exc) & ~multdiv_stall);


        //---------PC ENABLE-----------
        tristate1 PC1(PC_en, 1'b1, no_stall);         //no stall
        tristate1 PC2(PC_en, 1'b0, short_stall);      //load or exception stall
        tristate1 PC3(PC_en, 1'b0, multdiv_stall);    //multdiv_stall

        //---------FD ENABLE-----------
        tristate1 FD1(FD_en, 1'b1, no_stall);         //no stall
        tristate1 FD2(FD_en, 1'b0, short_stall);      //load or exception stall
        tristate1 FD3(FD_en, 1'b0, multdiv_stall);    //multdiv_stall

        //---------DX ENABLE-----------
        tristate1 DX1(DX_en, 1'b1, ~multdiv_stall);   //no stall
        tristate1 DX2(DX_en, 1'b0,  multdiv_stall);   //multdiv_stall

        //---------XM ENABLE-----------
        tristate1 XM1(XM_en, 1'b1, ~multdiv_stall);   //no stall
        tristate1 XM2(XM_en, 1'b0,  multdiv_stall);   //multdiv_stall

        //---------MW ENABLE-----------
        tristate1 MW1(MW_en, 1'b1, ~multdiv_stall);   //no stall
        tristate1 MW2(MW_en, 1'b0,  multdiv_stall);   //multdiv_stall


	/* END CODE */

endmodule
