module Program_Counter(clk, res_n, wr_en, counteradress,pc);

parameter PC_WIDTH = 8;

input clk;
input res_n;
input wr_en;
input [PC_WIDTH-1:0] counteradress;
output reg  [PC_WIDTH-1:0] pc;

always @(posedge clk or negedge res_n)
begin
	if (!res_n)
	begin
		pc <= 8'hFF;
	end
	else if (wr_en)
	begin
		pc <= counteradress;
	end
	else
	begin
		pc <= pc+1;
	end
	
end

endmodule
