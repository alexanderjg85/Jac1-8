module Program_Counter_test;

parameter PC_WIDTH = 8;

reg clk;
reg res_n;
reg wr_en;
wire [PC_WIDTH-1:0] program_counter;
reg [PC_WIDTH-1:0] counteradress;

Program_Counter uut(.clk(clk), .res_n(res_n), .pc(program_counter),
 .wr_en(wr_en), .counteradress(counteradress) );

initial begin
    $dumpfile("progcount.vcd");
    $dumpvars(0,Program_Counter_test);
    clk = 0;
    res_n = 0;
    counteradress = 0;
    wr_en = 0;
    #10
    res_n = 1;
    #10
    counteradress = 32;
    assert(program_counter === 0);
    #10
    assert(program_counter === 1);
    #10
    wr_en = 1;
    assert(program_counter === 2);
    #10
    wr_en = 0;
    assert(program_counter === 32);
    #10
    assert(program_counter === 33);
    #10

	$finish();
end

always begin
	#5  clk =  !clk;
	end

endmodule
