module Status_reg (clk, res_n, status, sel_stat_in_alu_decoder, alu_status, dec_status, wr_en);

parameter NumStatusBits = 2;

input clk;
input res_n;
input sel_stat_in_alu_decoder;  //Selektion ob das Register durch ALU oder Decoder beschrieben wird, 1 = AlU, 0 = Decoder
output reg [NumStatusBits-1:0] status;
input [NumStatusBits-1:0] alu_status;  //statusbits, welche in einer ALU Operation gesetzt werden
input [NumStatusBits-1:0] dec_status;	//statusbits, welche in einer Decoder Operation gesetzt werden
input wr_en;	//Status soll nicht in jeder Operation geändert werden, sondern nur in Operationen welche Statusregister betreffen

always @(posedge clk or negedge res_n)
begin
	if(!res_n)
	begin
		status <= 2'b00;
	end
	else begin  //status changed by alu
		if(wr_en && sel_stat_in_alu_decoder)
		begin
			status <= alu_status;
		end
		else if (wr_en && !sel_stat_in_alu_decoder) // status changed by decoder
		begin
			status <= dec_status;
		end
		else begin //status not changed
			status <= status;
		end
	end
end

endmodule
