module SEL_REG_WR_ALU_DECODER (literal_adr, sel_reg_in_alu_decoder, result, reg_val);

parameter DataWidth = 8;

input [DataWidth-1:0] literal_adr;
input sel_reg_in_alu_decoder; //Selektion ob das Register durch ALU oder Decoder beschrieben wird, 1 = AlU, 0 = Decoder
input [DataWidth-1:0] result; //Ergebniswert der ALU
output [DataWidth-1:0] reg_val; //Wert der ins Register geschrieben wird

assign reg_val = sel_reg_in_alu_decoder ? result : literal_adr;

endmodule
