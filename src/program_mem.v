module Program_Mem(clk, res_n, pc, ir);

parameter PC_WIDTH = 8;
parameter IRWidth = 16;
parameter CMD_CNT = 64;

input clk;
input res_n;
input [PC_WIDTH-1:0] pc;
output  [IRWidth-1:0] ir;

reg [IRWidth-1:0] NVM [0:CMD_CNT-1];
integer i;

always @(posedge clk or negedge res_n)
begin
	if(!res_n)
	begin	//Opcode 15:11,  Op1 9:8, Op2 4:3, Param 7:0
		NVM[0] <= 16'b0100_1001_0000_0011;		//val  Lade Register 1 mit Wert 3
		NVM[1] <= 16'b0100_1010_0001_0100;		//val  Lade Register 2 mit Wert 20
		NVM[2] <= 16'b0100_1011_1111_0000;		//val  Lade Register 3 mit Wert 240
		NVM[3] <= 16'b0000_1001_0001_0000;		//add  Addiere Register 1 mit 2 und speichere den Wert in Register 1 => Reg1 = 23
		NVM[4] <= 16'b0001_1001_0001_1000;		//and  Bitweises And Register 1 mit 3 und speichere den Wert in Register 1 => Reg1 = h10
		NVM[5] <= 16'b0100_1000_0000_1111;		//val  Lade Register 0 mit Wert 15
		NVM[6] <= 16'b0010_0000_0000_1000;		//or   Bitweises or Register 0 mit 1 und speichere den Wert in Register 0 => Reg0 = h1F
		NVM[7] <= 16'b0010_1001_0001_1000;		//not   Bitweises not Register 3 und speichere den Wert in Register 1 => Reg1 = h0F
		//Reg0 = h1F Reg1 = h0F, Reg2 = h14 Reg3 =hF0
		NVM[8] <= 16'b0011_0011_0000_1000;		//xor   Bitweises xor Register 3 mit 1 und speichere den Wert in Register 3 => Reg3 = hFF
		NVM[9] <= 16'b0001_0011_0000_1000;		//sub   Subtrahiere Register 3 mit 2 und speichere den Wert in Register 3 => Reg3 = hEB
		NVM[10] <= 16'b0000_0000_0000_0000;		//nop
		NVM[11] <= 16'b0000_0000_0000_0000;		//nop
		NVM[12] <= 16'b0011_1001_0000_0010;		//shl	Bitweises Linksshiften von Register 1 um 2 Stellen und speichere den Wert in Register 1 => Reg1 = h3C
		NVM[13] <= 16'b0100_0010_0000_0100;		//shr	Bitweises Rechtsshiften von Register 2 um 4 Stellen und speichere den Wert in Register 2 => Reg2 = h01
		//Reg0 = h1F Reg1 = h3C, Reg2 = h01 Reg3 =hEB
		NVM[14] <= 16'b1000_0000_0000_1000;		//goto Gehe zu Adresse NVM 8
		for (i=15; i < CMD_CNT; i=i+1)
		begin
			NVM[i] <= 0;
		end
	end 
	
end

assign ir = NVM[pc];

endmodule
