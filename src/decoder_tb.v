module Decoder_test;

parameter DataWidth = 8;
parameter SEL_WIDTH = 2;	//n² Register koennen somit angesprochen werden
parameter NUM_REGiSTERS = 4;
parameter PC_WIDTH = 8;
parameter PROGRAM_DataWidth = 16;
parameter NumOpCodeBits = 5;
parameter ParamBits = 8;
parameter NumStatusBits = 3;

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
//reserved
parameter OP_RES1 = 5'b0_1010;
parameter OP_RES2 = 5'b0_1011;
parameter OP_RES3 = 5'b0_1100;
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

	
decoder uut(.instruction(instruction), .opcode(opcode), .param(param), .literal_adr(literal_adr), 
	.status(status), .rd_sel1(rd_sel1), .rd_sel2(rd_sel2), .rd_en1(rd_en1), .rd_en2(rd_en2), 
	.wr_en(wr_en), .wr_sel(wr_sel), .sel_reg_in_alu_decoder(sel_reg_in_alu_decoder),
	.cnt_wr_en(cnt_wr_en)); 

initial begin
    $dumpfile("Decodertest.vcd");
    $dumpvars(0,Decoder_test);
    
    instruction = 0;
    status = 0;
    //Test ADD    
    #10		
    instruction[15:11] = Op_ADD;
    instruction[OP1_BIT_POS:OP1_BIT_POS-1] = 2'b01;
    instruction[OP2_BIT_POS:OP2_BIT_POS-1] = 2'b10;
    #1
    assert(opcode === Op_ADD);
    assert(rd_sel1 === 2'b01);
    assert(rd_sel2 === 2'b10);
    assert(rd_en1 === 1);
    assert(rd_en2 === 1);
    assert(sel_reg_in_alu_decoder === 1);
    assert(wr_en === 1);
    assert(wr_sel === 2'b01);
    #9
    //ToDO Test Op_SUB
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
    assert(sel_reg_in_alu_decoder === 1);
    assert(wr_en === 1);
    assert(wr_sel === 2'b11);
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
    assert(sel_reg_in_alu_decoder === 1);
    assert(wr_en === 1);
    assert(wr_sel === 2'b00);
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
    assert(sel_reg_in_alu_decoder === 1);
    assert(wr_en === 1);
    assert(wr_sel === 2'b10);
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
    assert(sel_reg_in_alu_decoder === 0);
    assert(wr_en === 1);
    assert(wr_sel === 2'b11);
    assert(param === 8'hA5);
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
    assert(sel_reg_in_alu_decoder === 0);
    assert(wr_en === 0);
    assert(wr_sel === 2'b00);
    assert(cnt_wr_en === 1 );
    assert(literal_adr === 8'h3F);
    #9
  //  #10
  //  #10

	$finish();
end


endmodule
