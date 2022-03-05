module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	//outputs from each register
	wire [31:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25,
				r26, r27, r28, r29, r30, r31;

	//wires from write enable/select ands
	wire a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25,
		 a26, a27, a28, a29, a30, a31;

	output [31:0] data_readRegA, data_readRegB;

//~~~~~~~~~~~~~~~~~~~~~~~~write decoder~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
	wire [31:0] write_select;
	decoder32 write_decoder(write_select, ctrl_writeReg);

//~~~~~~~~~~~~~~~~~~~~~~~~readA decoder~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
	wire [31:0] readA_select;
	decoder32 readA_decoder(readA_select, ctrl_readRegA);

//~~~~~~~~~~~~~~~~~~~~~~~~readB decoder~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
	wire [31:0] readB_select;
	decoder32 readB_decoder(readB_select, ctrl_readRegB);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~ands~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

	and writer0 (a0, write_select[0], ctrl_writeEnable);
	and writer1 (a1, write_select[1], ctrl_writeEnable);
	and writer2 (a2, write_select[2], ctrl_writeEnable);
	and writer3 (a3, write_select[3], ctrl_writeEnable);
	and writer4 (a4, write_select[4], ctrl_writeEnable);
	and writer5 (a5, write_select[5], ctrl_writeEnable);
	and writer6 (a6, write_select[6], ctrl_writeEnable);
	and writer7 (a7, write_select[7], ctrl_writeEnable);
	and writer8 (a8, write_select[8], ctrl_writeEnable);
	and writer9 (a9, write_select[9], ctrl_writeEnable);
	and writer10(a10, write_select[10], ctrl_writeEnable);
	and writer11(a11, write_select[11], ctrl_writeEnable);
	and writer12(a12, write_select[12], ctrl_writeEnable);
	and writer13(a13, write_select[13], ctrl_writeEnable);
	and writer14(a14, write_select[14], ctrl_writeEnable);
	and writer15(a15, write_select[15], ctrl_writeEnable);
	and writer16(a16, write_select[16], ctrl_writeEnable);
	and writer17(a17, write_select[17], ctrl_writeEnable);
	and writer18(a18, write_select[18], ctrl_writeEnable);
	and writer19(a19, write_select[19], ctrl_writeEnable);
	and writer20(a20, write_select[20], ctrl_writeEnable);
	and writer21(a21, write_select[21], ctrl_writeEnable);
	and writer22(a22, write_select[22], ctrl_writeEnable);
	and writer23(a23, write_select[23], ctrl_writeEnable);
	and writer24(a24, write_select[24], ctrl_writeEnable);
	and writer25(a25, write_select[25], ctrl_writeEnable);
	and writer26(a26, write_select[26], ctrl_writeEnable);
	and writer27(a27, write_select[27], ctrl_writeEnable);
	and writer28(a28, write_select[28], ctrl_writeEnable);
	and writer29(a29, write_select[29], ctrl_writeEnable);
	and writer30(a30, write_select[30], ctrl_writeEnable);
	and writer31(a31, write_select[31], ctrl_writeEnable);

//~~~~~~~~~~~~~~~~~~~~~~~~~~registers~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

	one_register reg0(r0, 32'b00000000000000000000000000000000, clock, ctrl_reset, 1'b0);
	one_register reg1(r1, data_writeReg, clock, ctrl_reset, a1);
	one_register reg2(r2, data_writeReg, clock, ctrl_reset, a2);
	one_register reg3(r3, data_writeReg, clock, ctrl_reset, a3);
	one_register reg4(r4, data_writeReg, clock, ctrl_reset, a4);
	one_register reg5(r5, data_writeReg, clock, ctrl_reset, a5);
	one_register reg6(r6, data_writeReg, clock, ctrl_reset, a6);
	one_register reg7(r7, data_writeReg, clock, ctrl_reset, a7);
	one_register reg8(r8, data_writeReg, clock, ctrl_reset, a8);
	one_register reg9(r9, data_writeReg, clock, ctrl_reset, a9);
	one_register reg10(r10, data_writeReg, clock, ctrl_reset, a10);
	one_register reg11(r11, data_writeReg, clock, ctrl_reset, a11);
	one_register reg12(r12, data_writeReg, clock, ctrl_reset, a12);
	one_register reg13(r13, data_writeReg, clock, ctrl_reset, a13);
	one_register reg14(r14, data_writeReg, clock, ctrl_reset, a14);
	one_register reg15(r15, data_writeReg, clock, ctrl_reset, a15);
	one_register reg16(r16, data_writeReg, clock, ctrl_reset, a16);
	one_register reg17(r17, data_writeReg, clock, ctrl_reset, a17);
	one_register reg18(r18, data_writeReg, clock, ctrl_reset, a18);
	one_register reg19(r19, data_writeReg, clock, ctrl_reset, a19);
	one_register reg20(r20, data_writeReg, clock, ctrl_reset, a20);
	one_register reg21(r21, data_writeReg, clock, ctrl_reset, a21);
	one_register reg22(r22, data_writeReg, clock, ctrl_reset, a22);
	one_register reg23(r23, data_writeReg, clock, ctrl_reset, a23);
	one_register reg24(r24, data_writeReg, clock, ctrl_reset, a24);
	one_register reg25(r25, data_writeReg, clock, ctrl_reset, a25);
	one_register reg26(r26, data_writeReg, clock, ctrl_reset, a26);
	one_register reg27(r27, data_writeReg, clock, ctrl_reset, a27);
	one_register reg28(r28, data_writeReg, clock, ctrl_reset, a28);
	one_register reg29(r29, data_writeReg, clock, ctrl_reset, a29);
	one_register reg30(r30, data_writeReg, clock, ctrl_reset, a30);
	one_register reg31(r31, data_writeReg, clock, ctrl_reset, a31);

//~~~~~~~~~~~~~~~~~~~~~~~~~~A tristates~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

	mytristate trizeroA(data_readRegA, r0, readA_select[0]);
    mytristate trioneA(data_readRegA, r1, readA_select[1]);
    mytristate tri2A(data_readRegA, r2, readA_select[2]);
	mytristate tri3A(data_readRegA, r3, readA_select[3]);
	mytristate tri4A(data_readRegA, r4, readA_select[4]);
	mytristate tri5A(data_readRegA, r5, readA_select[5]);
	mytristate tri6A(data_readRegA, r6, readA_select[6]);
	mytristate tri7A(data_readRegA, r7, readA_select[7]);
	mytristate tri8A(data_readRegA, r8, readA_select[8]);
	mytristate tri9A(data_readRegA, r9, readA_select[9]);
	mytristate tri10A(data_readRegA, r10, readA_select[10]);
	mytristate tri11A(data_readRegA, r11, readA_select[11]);
	mytristate tri12A(data_readRegA, r12, readA_select[12]);
	mytristate tri13A(data_readRegA, r13, readA_select[13]);
	mytristate tri14A(data_readRegA, r14, readA_select[14]);
	mytristate tri15A(data_readRegA, r15, readA_select[15]);
	mytristate tri16A(data_readRegA, r16, readA_select[16]);
	mytristate tri17A(data_readRegA, r17, readA_select[17]);
	mytristate tri18A(data_readRegA, r18, readA_select[18]);
	mytristate tri19A(data_readRegA, r19, readA_select[19]);
	mytristate tri20A(data_readRegA, r20, readA_select[20]);
	mytristate tri21A(data_readRegA, r21, readA_select[21]);
	mytristate tri22A(data_readRegA, r22, readA_select[22]);
	mytristate tri23A(data_readRegA, r23, readA_select[23]);
	mytristate tri24A(data_readRegA, r24, readA_select[24]);
	mytristate tri25A(data_readRegA, r25, readA_select[25]);
	mytristate tri26A(data_readRegA, r26, readA_select[26]);
	mytristate tri27A(data_readRegA, r27, readA_select[27]);
	mytristate tri28A(data_readRegA, r28, readA_select[28]);
	mytristate tri29A(data_readRegA, r29, readA_select[29]);
	mytristate tri30A(data_readRegA, r30, readA_select[30]);
	mytristate tri31A(data_readRegA, r31, readA_select[31]);

//~~~~~~~~~~~~~~~~~~~~~~~~~~B tristates~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

	mytristate trizeroB(data_readRegB, r0, readB_select[0]);
    mytristate trioneB(data_readRegB, r1, readB_select[1]);
    mytristate tri2B(data_readRegB, r2, readB_select[2]);
	mytristate tri3B(data_readRegB, r3, readB_select[3]);
	mytristate tri4B(data_readRegB, r4, readB_select[4]);
	mytristate tri5B(data_readRegB, r5, readB_select[5]);
	mytristate tri6B(data_readRegB, r6, readB_select[6]);
	mytristate tri7B(data_readRegB, r7, readB_select[7]);
	mytristate tri8B(data_readRegB, r8, readB_select[8]);
	mytristate tri9B(data_readRegB, r9, readB_select[9]);
	mytristate tri10B(data_readRegB, r10, readB_select[10]);
	mytristate tri11B(data_readRegB, r11, readB_select[11]);
	mytristate tri12B(data_readRegB, r12, readB_select[12]);
	mytristate tri13B(data_readRegB, r13, readB_select[13]);
	mytristate tri14B(data_readRegB, r14, readB_select[14]);
	mytristate tri15B(data_readRegB, r15, readB_select[15]);
	mytristate tri16B(data_readRegB, r16, readB_select[16]);
	mytristate tri17B(data_readRegB, r17, readB_select[17]);
	mytristate tri18B(data_readRegB, r18, readB_select[18]);
	mytristate tri19B(data_readRegB, r19, readB_select[19]);
	mytristate tri20B(data_readRegB, r20, readB_select[20]);
	mytristate tri21B(data_readRegB, r21, readB_select[21]);
	mytristate tri22B(data_readRegB, r22, readB_select[22]);
	mytristate tri23B(data_readRegB, r23, readB_select[23]);
	mytristate tri24B(data_readRegB, r24, readB_select[24]);
	mytristate tri25B(data_readRegB, r25, readB_select[25]);
	mytristate tri26B(data_readRegB, r26, readB_select[26]);
	mytristate tri27B(data_readRegB, r27, readB_select[27]);
	mytristate tri28B(data_readRegB, r28, readB_select[28]);
	mytristate tri29B(data_readRegB, r29, readB_select[29]);
	mytristate tri30B(data_readRegB, r30, readB_select[30]);
	mytristate tri31B(data_readRegB, r31, readB_select[31]);


endmodule
