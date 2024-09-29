module decoder (instruction, opcode, param, literal_adr, status, rd_sel1, rd_sel2,
				rd_en1, rd_en2, wr_en, wr_sel, sel_reg_in_alu_decoder, cnt_wr_en,
				stat_wr_en, stat_reg_in_alu_decoder, status_out);
				
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
parameter Op_NOT  = 5'b0_0101; //bei Not werden 2 Operanden angegeben Op1 ist Ziel und Op2 die Eingabe, Op1 und Op2 dürfen gleich sein
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

input [PROGRAM_DataWidth-1:0] instruction;
output [NumOpCodeBits-1:0] opcode;
output [ParamBits-1:0] param;  //z.B Anzahl der Bits um die nach rechts oder links geschiftet werden soll
output [DataWidth-1:0] literal_adr;  //literal um Wert in Register zu schreiben oder neue PC Adresse
input [NumStatusBits-1:0] status;
output reg [SEL_WIDTH-1:0] rd_sel1;
output reg [SEL_WIDTH-1:0] rd_sel2;
output reg rd_en1;
output reg rd_en2;
output reg wr_en;
output reg[SEL_WIDTH-1:0] wr_sel;
output reg sel_reg_in_alu_decoder; //Selektion ob das Register durch ALU oder Decoder beschrieben wird, 1 = AlU, 0 = Decoder
output reg cnt_wr_en;	//write enable fuer PC, wenn nicht aktiv wird fröhlich immer eins hochgezählt
output reg stat_wr_en;	//write enable fuer Status Reg
output stat_reg_in_alu_decoder;  //Selektion ob das Status Register durch ALU oder Decoder beschrieben wird, 1 = ALU, 0 Decoder
output [NumStatusBits-1:0] status_out;

assign opcode = instruction[15:11];
assign param = instruction[7:0];
assign literal_adr = instruction[7:0];

assign stat_reg_in_alu_decoder = 1; //Status Register wird aktuell immer durch die ALU beschrieben
assign status_out = 3'b000;

always @(instruction)
begin
	case (opcode)
	//logic & arithmetic commands
	Op_NOP: begin  	rd_sel1 <= 2'b00; rd_sel2 <= 2'b00; wr_sel <= 2'b00;
					rd_en1 <= 0; rd_en2 <= 0; wr_en <= 0; cnt_wr_en <= 0;
					sel_reg_in_alu_decoder <= SEL_DECODER;
					stat_wr_en <= 0;  //Status wird durch NOP nicht veraendert
			end
			
	Op_ADD: begin  	rd_sel1 <= instruction[OP1_BIT_POS:OP1_BIT_POS-1]; 
					rd_sel2 <= instruction[OP2_BIT_POS:OP2_BIT_POS-1]; 
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 1; rd_en2 <= 1; wr_en <= 1; cnt_wr_en <= 0;
					sel_reg_in_alu_decoder <= SEL_ALU;
					stat_wr_en <= 1;
			end
	Op_SUB: begin	rd_sel1 <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_sel2 <= instruction[OP2_BIT_POS:OP2_BIT_POS-1];
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 1; rd_en2 <= 1; wr_en <= 1; cnt_wr_en <= 0;
					sel_reg_in_alu_decoder <= SEL_ALU;
					stat_wr_en <= 1;
			end
	Op_AND: begin  	rd_sel1 <= instruction[OP1_BIT_POS:OP1_BIT_POS-1]; 
					rd_sel2 <= instruction[OP2_BIT_POS:OP2_BIT_POS-1]; 
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 1; rd_en2 <= 1; wr_en <= 1; 
					cnt_wr_en <= 0; sel_reg_in_alu_decoder <= SEL_ALU;
					stat_wr_en <= 1;
			end
	Op_OR:	begin  	rd_sel1 <= instruction[OP1_BIT_POS:OP1_BIT_POS-1]; 
					rd_sel2 <= instruction[OP2_BIT_POS:OP2_BIT_POS-1]; 
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 1; rd_en2 <= 1; wr_en <= 1; 
					cnt_wr_en <= 0; sel_reg_in_alu_decoder <= SEL_ALU;
					stat_wr_en <= 1;
			end
	Op_NOT:	begin  	rd_sel1 <= 2'b00; 
					rd_sel2 <= instruction[OP2_BIT_POS:OP2_BIT_POS-1]; 
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 0; rd_en2 <= 1; wr_en <= 1; 
					cnt_wr_en <= 0; sel_reg_in_alu_decoder <= SEL_ALU;
					stat_wr_en <= 1;
			end
	Op_XOR: begin  rd_sel1 <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_sel2 <= instruction[OP2_BIT_POS:OP2_BIT_POS-1];
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 1; rd_en2 <= 1; wr_en <= 1;
					cnt_wr_en <= 0; sel_reg_in_alu_decoder <= SEL_ALU;
					stat_wr_en <= 1;
			end
	Op_SHL: begin
					rd_sel1 <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_sel2 <= 2'b00;
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 1; rd_en2 <= 0; wr_en <= 1;
					cnt_wr_en <= 0; sel_reg_in_alu_decoder <= SEL_ALU;
					stat_wr_en <= 1;
			end
	Op_SHR: begin
					rd_sel1 <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_sel2 <= 2'b00;
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 1; rd_en2 <= 0; wr_en <= 1;
					cnt_wr_en <= 0; sel_reg_in_alu_decoder <= SEL_ALU;
					stat_wr_en <= 1;
			end
	Op_VAL: begin  	rd_sel1 <= 2'b00; 
					rd_sel2 <= 2'b00; 
					wr_sel <= instruction[OP1_BIT_POS:OP1_BIT_POS-1];
					rd_en1 <= 0; rd_en2 <= 0; wr_en <= 1; 
					cnt_wr_en <= 0; sel_reg_in_alu_decoder <= SEL_DECODER;
					stat_wr_en <= 0;  //Status Register wird durch VAL Cmd nicht verändert
			end
			
	//programm flow commands
	Op_GOTO: begin  rd_sel1 <= 2'b00; 
					rd_sel2 <= 2'b00; 
					wr_sel <= 2'b00;
					rd_en1 <= 0; rd_en2 <= 0; wr_en <= 0; 
					cnt_wr_en <= 1; sel_reg_in_alu_decoder <= SEL_DECODER;
					stat_wr_en <= 0;  //Status Register wird durch GOTO nicht verändert
			end
	//Todo	Op_IFZ  begin end
	//Todo	Op_IFNZ begin end
	//Todo	Op_IFEQ begin end
	//Todo	Op_IFST begin end	
	//Todo	Op_IFGT begin end
	
	default: begin  rd_sel1 <= 2'b00; rd_sel2 <= 2'b00; wr_sel <= 2'b00;
					rd_en1 <= 0; rd_en2 <= 0; wr_en <= 0; cnt_wr_en <= 0;
					sel_reg_in_alu_decoder <= SEL_DECODER;
					stat_wr_en <= 0; //Im Default Zweig wird das Status Register nicht verändert
			end
	
	endcase
end

endmodule
