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
    #10
    reg_in = 255;
    wr_sel = 3;
    wr_en = 1;
    #10
    reg_in = 15;
    wr_sel = 2;
    #10
    reg_in = 128;
    wr_sel = 0;
    #10
    wr_en = 0;
    rd_en1 = 1;
    rd_sel1 = 3;
    #10
    rd_en1 = 0;
    rd_sel1 = 0;
    #10
    wr_en = 1;
    wr_sel = 1;
    reg_in = 3;
    rd_en2 = 1;
    #10
    wr_en = 0;
    rd_en1 = 1;
    rd_sel1 = 2;
    rd_sel2 =2;
    #10
    rd_sel1 = 1;
    rd_sel2 = 3;
    #10

	$finish();
end

always begin
	#5  clk =  !clk;
	end

endmodule
