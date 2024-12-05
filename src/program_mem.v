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
		NVM[10] <= 16'b1000_1000_0000_0010;		//ifz 	Prüfe das Status Register auf Zero und überspringe die folgenden 2 Befehle, Zero Bit = 0 => kein Sprung
		NVM[11] <= 16'b0000_0000_0000_0000;		//nop
		NVM[12] <= 16'b0000_0000_0000_0000;		//nop
		NVM[13] <= 16'b0011_1001_0000_0010;		//shl	Bitweises Linksshiften von Register 1 um 2 Stellen und speichere den Wert in Register 1 => Reg1 = h3C
		NVM[14] <= 16'b0100_0010_0000_0100;		//shr	Bitweises Rechtsshiften von Register 2 um 4 Stellen und speichere den Wert in Register 2 => Reg2 = h01
		NVM[15] <= 16'b1001_0000_0000_0011;		//ifnz 	Prüfe das Status Register auf Zero und überspringe die folgenden 3 Befehle, Zero Bit = 0 =>  Sprung
		NVM[16] <= 16'b0000_0000_0000_0000;		//nop	wird übersprungen
		NVM[17] <= 16'b0000_0000_0000_0000;		//nop	wird übersprungen
		NVM[18] <= 16'b0000_0000_0000_0000;		//nop	wird übersprungen
		//Reg0 = h1F Reg1 = h3C, Reg2 = h01 Reg3 =hEB
		NVM[19] <= 16'b0001_0010_0001_0000;		//sub   Subtrahiere Register 2 mit 2 und speichere den Wert in Register 2 => Reg2 = h00, Zero Bit = 1
		NVM[20] <= 16'b1000_1000_0000_0001;		//ifz 	Prüfe das Status Register auf Zero und überspringe den folgenden Befehl, Zero Bit = 1 => Sprung
		NVM[21] <= 16'b0000_0000_0000_0000;		//nop	wird übersprungen
		NVM[22] <= 16'b1001_1000_0000_0001;		//ifeq 	Prüfe das Status Register auf Eq und überspringe den folgenden Befehl, Eq Bit = 1 => Sprung
		NVM[23] <= 16'b0000_0000_0000_0000;		//nop	wird übersprungen
		//Reg0 = h1F Reg1 = h3C, Reg2 = h00 Reg3 =hEB
		NVM[24] <= 16'b0000_1001_0001_0000;		//add  Addiere Register 1 mit 2 und speichere den Wert in Register 1 => Reg1 = h3C
		NVM[25] <= 16'b1001_1000_0000_0001;		//ifeq 	Prüfe das Status Register auf Eq und überspringe den folgenden Befehl, Eq Bit = 0 => kein Sprung
		NVM[26] <= 16'b0000_0000_0000_0000;		//nop	wird ausgefuehrt
		NVM[27] <= 16'b0101_0001_0000_0000;		//cmp   Vergleich Register 1 mit 0 Folgende Flags werden gesetzt: Greater Than Bit
		NVM[28] <= 16'b0101_0000_0000_1000;		//cmp   Vergleich Register 0 mit 1 Folgende Flags werden gesetzt: Smaller Than Bit
		NVM[29] <= 16'b1000_0000_0000_1000;		//goto Gehe zu Adresse NVM 8
		for (i=30; i < CMD_CNT; i=i+1)
		begin
			NVM[i] <= 0;
		end
	end 
	
end

assign ir = NVM[pc];

endmodule
