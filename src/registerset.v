module registerset(clk, res_n, wr_en, wr_sel, reg_in, reg_out_1, reg_out_2,
		rd_en1, rd_en2, rd_sel1, rd_sel2);
		
parameter DataWidth = 8;
parameter SEL_WIDTH = 2;	//n² Register koennen somit angesprochen werden
parameter NUM_REGiSTERS = 4;

input clk;
input res_n;
input wr_en;
input [SEL_WIDTH-1:0] wr_sel;
input [DataWidth-1:0] reg_in;
output [DataWidth-1:0] reg_out_1;
output [DataWidth-1:0] reg_out_2;
input rd_en1;
input rd_en2;
input [SEL_WIDTH-1:0] rd_sel1;
input [SEL_WIDTH-1:0] rd_sel2;

reg [DataWidth-1:0] Register [NUM_REGiSTERS-1:0];
integer i;


assign reg_out_1 = rd_en1 ? Register[rd_sel1] :0;

assign reg_out_2 = rd_en2 ? Register[rd_sel2] :0;


always @(posedge clk or negedge res_n)
begin
	if(!res_n)
	begin
		for(i = 0; i < NUM_REGiSTERS; i = i+1)
		begin
			Register[i] = 0;
		end
	end
	else begin
		if(wr_en) begin
			Register[wr_sel] <= reg_in;
		end
		
	end	
end

endmodule
