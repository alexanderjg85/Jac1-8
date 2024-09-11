module JAC1_Top (clk, sys_res_n, reg_val);

parameter DataWidth = 8;
parameter SEL_WIDTH = 2;	//n² Register koennen somit angesprochen werden
parameter NumOpCodeBits = 5;
parameter ParamBits = 8;
parameter NumStatusBits = 2;
parameter PC_WIDTH = 8;
parameter IRWidth = 16;

input clk;
input sys_res_n;
output [DataWidth-1:0] reg_val;

wire cnt_wr_en;
wire [PC_WIDTH-1:0] program_counter;
wire [PC_WIDTH-1:0] counteradress;

Program_Counter PC_I_1(.clk(clk), .res_n(sys_res_n), .pc(program_counter),
 .wr_en(cnt_wr_en), .counteradress(counteradress) );
 

wire[IRWidth-1:0] instruction;

Program_Mem PNVM_I_1(.clk(clk), .res_n(sys_res_n), .pc(program_counter),
 .ir(instruction) );

wire wr_en;
wire rd_en1;
wire rd_en2;
wire [SEL_WIDTH-1:0] rd_sel1;
wire [SEL_WIDTH-1:0] rd_sel2;
wire [SEL_WIDTH-1:0] wr_sel;
wire [NumOpCodeBits-1:0] opcode;
wire [ParamBits-1:0] param;
wire [DataWidth-1:0] literal_adr;
wire [NumStatusBits-1:0] status;
wire  sel_reg_in_alu_decoder;  //Selektion ob das Register durch ALU oder Decoder beschrieben wird, 1 = AlU, 0 = Decoder

	
decoder decoder_I_1(.instruction(instruction), .opcode(opcode), .param(param), .literal_adr(literal_adr), 
	.status(status), .rd_sel1(rd_sel1), .rd_sel2(rd_sel2), .rd_en1(rd_en1), .rd_en2(rd_en2), 
	.wr_en(wr_en), .wr_sel(wr_sel), .sel_reg_in_alu_decoder(sel_reg_in_alu_decoder),
	.cnt_wr_en(cnt_wr_en)); 

 
wire [DataWidth-1:0] result;
//wire [DataWidth-1:0] reg_val; //Wert der ins Register geschrieben wird

SEL_REG_WR_ALU_DECODER sel_reg_wr_I_1(.literal_adr(literal_adr), .result(result), 
	.sel_reg_in_alu_decoder(sel_reg_in_alu_decoder), .reg_val(reg_val)); 

	
wire [DataWidth-1:0] reg_out_1;
wire [DataWidth-1:0] reg_out_2;

registerset register_I_1(.clk(clk), .res_n(sys_res_n), .wr_en(wr_en), .wr_sel(wr_sel), .reg_in(reg_val),
	.reg_out_1(reg_out_1), .reg_out_2(reg_out_2), .rd_en1(rd_en1), .rd_en2(rd_en2), 
	.rd_sel1(rd_sel1), .rd_sel2(rd_sel2)); 



ALU_J alu_I_1(.opcode(opcode), .operand1(reg_out_1), .operand2(reg_out_2),
 .param(param), .result(result), .status(status));

endmodule
