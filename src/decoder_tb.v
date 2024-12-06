module Decoder_test;

parameter DataWidth = 8;
parameter SEL_WIDTH = 2;	//n² Register koennen somit angesprochen werden
parameter NUM_REGiSTERS = 4;
parameter PC_WIDTH = 8;
parameter PROGRAM_DataWidth = 16;
parameter NumOpCodeBits = 5;
parameter ParamBits = 8;
parameter NumStatusBits = 6;

parameter CarryBit = 0;
parameter UnderflowBit = 1;
parameter ZeroBit = 2;
parameter EqualBit = 3;
parameter GreaterThanBit = 4;
parameter SmallerThanBit = 5;

//logic & arithmetic commands
parameter Op_NOP  = 5'b0_0000;
parameter Op_ADD  = 5'b0_0001; 
parameter Op_SUB  = 5'b0_0010;
parameter Op_AND  = 5'b0_0011;
parameter Op_OR   = 5'b0_0100;
parameter Op_NOT  = 5'b0_0101;
parameter Op_XOR  = 5'b0_0110;
parameter Op_SHL  = 5'b0_0111;
parameter Op_SHR  = 5'b0_1000;
parameter Op_VAL  = 5'b0_1001;
parameter Op_CMP = 5'b0_1010;	//Compare 2 Registers and set the appropriate status flags
parameter Op_ADDC = 5'b0_1011;
parameter Op_SUBU = 5'b0_1100;
//reserved
parameter OP_RES4 = 5'b0_1101;
parameter OP_RES5 = 5'b0_1110;
parameter OP_RES6 = 5'b0_1111;
//programm flow commands
parameter Op_GOTO = 5'b1_0000;
parameter Op_IFZ  = 5'b1_0001;
parameter Op_IFNZ = 5'b1_0010;
parameter Op_IFEQ = 5'b1_0011;
parameter Op_IFST = 5'b1_0100;
parameter Op_IFGT = 5'b1_0101;
//reserved
parameter OP_RES7 = 5'b1_0110;
parameter OP_RES8 = 5'b1_0111;
//Load & store commands
parameter OP_RES9 = 5'b1_1000;
parameter OP_RES10 = 5'b1_1001;
parameter OP_RES11 = 5'b1_1010;
parameter OP_RES12 = 5'b1_1011;
//IO commands
parameter OP_RES13 = 5'b1_1100;
parameter OP_RES14 = 5'b1_1101;
parameter OP_RES15 = 5'b1_1110;
parameter OP_RES16 = 5'b1_1111;

parameter SEL_ALU = 1'b1;
parameter SEL_DECODER = 1'b0;

parameter OP1_BIT_POS = 9;
parameter OP2_BIT_POS = 4;


wire wr_en;
wire rd_en1;
wire rd_en2;
wire [SEL_WIDTH-1:0] rd_sel1;
wire [SEL_WIDTH-1:0] rd_sel2;
wire [SEL_WIDTH-1:0] wr_sel;
reg [PROGRAM_DataWidth-1:0] instruction;
wire [NumOpCodeBits-1:0] opcode;
wire [ParamBits-1:0] param;
wire [DataWidth-1:0] literal_adr;
reg [NumStatusBits-1:0] status;
wire  sel_reg_in_alu_decoder;
wire  cnt_wr_en;
wire stat_wr_en;
wire stat_reg_in_alu_decoder;
wire [NumStatusBits-1:0] status_out;
wire add_offset;

	
decoder uut(.instruction(instruction), .opcode(opcode), .param(param), .literal_adr(literal_adr), 
	.status(status), .rd_sel1(rd_sel1), .rd_sel2(rd_sel2), .rd_en1(rd_en1), .rd_en2(rd_en2), 
	.wr_en(wr_en), .wr_sel(wr_sel), .sel_reg_in_alu_decoder(sel_reg_in_alu_decoder), .add_offset(add_offset),
	.cnt_wr_en(cnt_wr_en), .stat_wr_en(stat_wr_en), .stat_reg_in_alu_decoder(stat_reg_in_alu_decoder), .status_out(status_out));

initial begin
    $dumpfile("Decodertest.vcd");
    $dumpvars(0,Decoder_test);
    
    instruction = 0;
    status = 0;
    #1
    assert(stat_wr_en === 0);
    assert(status_out === 6'b000000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    //Test ADD    
    #9
    instruction[15:11] = Op_ADD;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b01;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b10;
    #1
    assert(opcode === Op_ADD);
    assert(rd_sel1 === 2'b01);
    assert(rd_sel2 === 2'b10);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b01);
    assert(status_out === 6'b000000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Test Op_SUB
    instruction[15:11] = Op_SUB;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b10;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b01;
    #1
    assert(opcode === Op_SUB);
    assert(rd_sel1 === 2'b10);
    assert(rd_sel2 === 2'b01);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b10);
    assert(status_out === 6'b000000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Test Op_AND
    instruction[15:11] = Op_AND;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b11;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b10;
    #1
    assert(opcode === Op_AND);
    assert(rd_sel1 === 2'b11);
    assert(rd_sel2 === 2'b10);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b11);
    assert(status_out === 6'b000000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Test Op_OR
    instruction[15:11] = Op_OR;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b01;
    #1
    assert(opcode === Op_OR);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b01);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b000000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Test Op_NOT
    instruction[15:11] = Op_NOT;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b10;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b00;
    #1
    assert(opcode === Op_NOT);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b10);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Test Op_VAL
    instruction[15:11] = Op_VAL;
    instruction[ParamBits-1:0] = 8'hA5;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b11;
    #1
    assert(opcode === Op_VAL);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 1);
    assert(wr_sel === 2'b11);
    assert(param === 8'hA5);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 0);
    #9
    //Test Op_GOTO
    instruction[15:11] = Op_GOTO;
    instruction[ParamBits-1:0] = 8'h3F;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    #1
    assert(opcode === Op_GOTO);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(cnt_wr_en === 1 );
    assert(literal_adr === 8'h3F);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 0);
    #9
	//Test Op_XOR
    instruction[15:11] = Op_XOR;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b11;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b10;
    #1
    assert(opcode === Op_XOR);
    assert(rd_sel1 === 2'b11);
    assert(rd_sel2 === 2'b10);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b11);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Test Op_SHL
    instruction[15:11] = Op_SHL;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b01;
    instruction[ParamBits-1:0] = 8'h05;
    #1
    assert(opcode === Op_SHL);
    assert(rd_sel1 === 2'b01);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 1);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b01);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Test Op_SHR
    instruction[15:11] = Op_SHR;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b10;
    instruction[ParamBits-1:0] = 8'h02;
    #1
    assert(opcode === Op_SHR);
    assert(rd_sel1 === 2'b10);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 1);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b10);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Op_IFZ   Zero Flag nicht gesetzt, kein relativer Sprung
    instruction[15:11] = Op_IFZ;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h08;
    #1
    assert(opcode === Op_IFZ);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 0);
    assert(cnt_wr_en === 0 );
    #9
    //Op_IFZ   Zero Flag gesetzt, relativer Sprung
    instruction[15:11] = Op_IFZ;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h09;
    status[ZeroBit] = 1;
    #1
    assert(opcode === Op_IFZ);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 1);
    assert(cnt_wr_en === 1 );
    #9
    //Op_IFNZ   Zero Flag gesetzt, kein relativer Sprung
    instruction[15:11] = Op_IFNZ;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h0A;
    #1
    assert(opcode === Op_IFNZ);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 0);
    assert(cnt_wr_en === 0 );
    #9
    //Op_IFNZ   Zero Flag nicht gesetzt, relativer Sprung
    instruction[15:11] = Op_IFNZ;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h0B;
    status[ZeroBit] = 0;
    #1
    assert(opcode === Op_IFNZ);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 1);
    assert(cnt_wr_en === 1 );
    #9
	//Op_IFEQ   Equal Flag gesetzt, relativer Sprung
    instruction[15:11] = Op_IFEQ;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h0C;
    status[EqualBit] = 1;
    #1
    assert(opcode === Op_IFEQ);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 1);
    assert(cnt_wr_en === 1 );
    #9
    //Op_IFEQ   Equal Flag nicht gesetzt, kein relativer Sprung
    instruction[15:11] = Op_IFEQ;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h0D;
    status[EqualBit] = 0;
    #1
    assert(opcode === Op_IFEQ);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 0);
    assert(cnt_wr_en === 0 );
    #9
    //Op_IFST   Smaller Than Flag gesetzt, relativer Sprung
    instruction[15:11] = Op_IFST;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h0E;
    status[SmallerThanBit] = 1;
    #1
    assert(opcode === Op_IFST);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 1);
    assert(cnt_wr_en === 1 );
    #9
    //Op_IFST   Smaller Than Flag nicht gesetzt, kein relativer Sprung
    instruction[15:11] = Op_IFST;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h0E;
    status[SmallerThanBit] = 0;
    #1
    assert(opcode === Op_IFST);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 0);
    assert(cnt_wr_en === 0 );
    #9
    //Op_CMP
    instruction[15:11] = Op_CMP;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b10;
    #1
    assert(opcode === Op_CMP);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b10);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    assert(cnt_wr_en === 0 );
    #9
    //Test ADDC
    #9
    instruction[15:11] = Op_ADDC;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b11;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b10;
    #1
    assert(opcode === Op_ADDC);
    assert(rd_sel1 === 2'b11);
    assert(rd_sel2 === 2'b10);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b11);
    assert(status_out === 6'b000000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Test Op_SUBU
    instruction[15:11] = Op_SUBU;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b01;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b10;
    #1
    assert(opcode === Op_SUBU);
    assert(rd_sel1 === 2'b01);
    assert(rd_sel2 === 2'b10);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === SEL_ALU);
    assert(wr_en === 1);
    assert(wr_sel === 2'b01);
    assert(status_out === 6'b000000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 1);
    assert(add_offset === 0);
    #9
    //Op_IFGT   Greater Than Flag gesetzt, relativer Sprung
    instruction[15:11] = Op_IFGT;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h06;
    status[GreaterThanBit] = 1;
    #1
    assert(opcode === Op_IFGT);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 1);
    assert(cnt_wr_en === 1 );
    #9
    //Op_IFGT   Greater Than Flag nicht gesetzt, kein relativer Sprung
    instruction[15:11] = Op_IFGT;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b00;
    instruction[ParamBits-1:0] = 8'h06;
    status[GreaterThanBit] = 0;
    #1
    assert(opcode === Op_IFGT);
    assert(rd_sel1 === 2'b00);
    assert(rd_sel2 === 2'b00);
    assert(rd_en1 === 0);
    assert(rd_en2 === 0);
    assert(sel_reg_in_alu_decoder === SEL_DECODER);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(status_out === 6'b00_0000);
    assert(stat_reg_in_alu_decoder === SEL_ALU);
    assert(stat_wr_en === 0);
    assert(add_offset === 0);
    assert(cnt_wr_en === 0 );

	$finish();
end


endmodule
