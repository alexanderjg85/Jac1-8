module Program_Counter(clk, res_n, wr_en, counteradress,pc, add_offset);

parameter PC_WIDTH = 8;

input clk;
input res_n;
input wr_en;
input add_offset;
input [PC_WIDTH-1:0] counteradress;
output reg  [PC_WIDTH-1:0] pc;

always @(posedge clk or negedge res_n)
begin
	if (!res_n)
	begin
		pc <= 8'hFF;
	end
	else if (wr_en && (!add_offset)) //Goto Command - Jump to address
	begin
		pc <= counteradress;
	end
	else if (wr_en && add_offset) //Program Flow Command - Add Offset to PC
	begin
		pc <= pc + counteradress + 1; //without adding 1 pc incremts 1 step to less
	end
	else
	begin
		pc <= pc+1;		//Normal program flow
	end
	
end

endmodule
