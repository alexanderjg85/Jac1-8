module Registerset_test;

parameter DataWidth = 8;
parameter SEL_WIDTH = 2;	//n² Register koennen somit angesprochen werden
parameter NUM_REGiSTERS = 4;

reg clk;
reg res_n;
reg wr_en;
reg rd_en1;
reg rd_en2;
reg [SEL_WIDTH-1:0] rd_sel1;
reg [SEL_WIDTH-1:0] rd_sel2;
reg [SEL_WIDTH-1:0] wr_sel;
wire [DataWidth-1:0] reg_out_1;
wire [DataWidth-1:0] reg_out_2;
reg [DataWidth-1:0] reg_in;

registerset uut(.clk(clk), .res_n(res_n), .wr_en(wr_en), .wr_sel(wr_sel), .reg_in(reg_in),
	.reg_out_1(reg_out_1), .reg_out_2(reg_out_2), .rd_en1(rd_en1), .rd_en2(rd_en2), 
	.rd_sel1(rd_sel1), .rd_sel2(rd_sel2)); 

initial begin
    $dumpfile("registertest.vcd");
    $dumpvars(0,Registerset_test);
    clk = 0;
    res_n = 0;
    rd_en1 = 0;
    rd_en2 = 0;
    wr_en = 0;
    rd_sel1 = 0;
    rd_sel2 = 0;
    wr_sel = 0;
    reg_in = 0;
    #10
    res_n = 1;
    #6 //Nach dem Reset soll 0 in den Ausgangsregistern stehen
    assert(reg_out_1 === 0);
    assert(reg_out_2 === 0);
    #4 //Schreibe 255 in R3, => R0 = 0, R1 = 0, R2 = 0, R3 = 255
    reg_in = 255;
    wr_sel = 3;
    wr_en = 1;
    #6 //Ausgang darf sich nicht verändern
    assert(reg_out_1 === 0);
    assert(reg_out_2 === 0);
    #4  //Schreibe 15 in R2, => R0 = 0, R1 = 0, R2 = 15, R3 = 255
    reg_in = 15;
    wr_sel = 2;
    #6 //Ausgang darf sich nicht verändern
    assert(reg_out_1 === 0);
    assert(reg_out_2 === 0);
    #4  //Schreibe 128 in R0, => R0 = 128, R1 = 0, R2 = 15, R3 = 255
    reg_in = 128;
    wr_sel = 0;
    #6 //Ausgang darf sich nicht verändern
    assert(reg_out_1 === 0);
    assert(reg_out_2 === 0);
    #4  //Lese R3 = 255, => R0 = 128, R1 = 0, R2 = 15, R3 = 255
    wr_en = 0;
    rd_en1 = 1;
    rd_sel1 = 3;
    #6 //Reg_out 1 = R3 = 255
    assert(reg_out_1 === 255);
    assert(reg_out_2 === 0);
    #4 //NOP - Lese und Schreibe nichts, Ausgänge müssen 0 sein
    rd_en1 = 0;
    rd_sel1 = 0;
    #6
    assert(reg_out_1 === 0);
    assert(reg_out_2 === 0);
    #4 //Schreibe 3 in R1 und Lese R1 an Out2 = 128, => R0 = 128, R1 = 3, R2 = 15, R3 = 255
    wr_en = 1;
    wr_sel = 1;
    reg_in = 3;
    rd_en2 = 1;
    #6 //Ausgang 2 muss 128 sein
    assert(reg_out_1 === 0);
    assert(reg_out_2 === 128);
    #4 //Lese R2 an Out1 = 15 und Lese R2 an Out2 = 15, => R0 = 128, R1 = 3, R2 = 15, R3 = 255
    wr_en = 0;
    rd_en1 = 1;
    rd_sel1 = 2;
    rd_sel2 =2;
    #6 //Ausgang 1 und 2 müssem 15 sein
    assert(reg_out_1 === 15);
    assert(reg_out_2 === 15);
    #4 //Lese R1 an Out1 = 3 und Lese R3 an Out2 = 255, => R0 = 128, R1 = 3, R2 = 15, R3 = 255
    rd_sel1 = 1;
    rd_sel2 = 3;
    #6
    assert(reg_out_1 === 3);
    assert(reg_out_2 === 255);
    #4

	$finish();
end

always begin
	#5  clk =  !clk;
	end

endmodule
