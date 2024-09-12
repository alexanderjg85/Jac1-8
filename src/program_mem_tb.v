module progmem_test;

parameter PC_WIDTH = 8;
parameter DataWidth = 16;
parameter CMD_CNT = 64;

reg clk;
reg res_n;
reg [PC_WIDTH-1:0] program_counter;
wire[DataWidth-1:0] instruction;

Program_Mem uut(.clk(clk), .res_n(res_n), .pc(program_counter),
 .ir(instruction) );

initial begin
    $dumpfile("progmem.vcd");
    $dumpvars(0,progmem_test);

    clk = 0;
    res_n = 0;
    program_counter = 0;
    #10
    res_n = 1;
    #10
    program_counter = 1;
    #10
    program_counter = 2;
    #10 
    program_counter = 3;
	#10
	program_counter = 4;
    #10 
    program_counter = 5;
	#10
	program_counter = 6;
	#10
	program_counter = 7;
	#10
	program_counter = 8;
	#10
	program_counter = 9;
	#10
	program_counter = 10;
	#10
	
	 $finish();
end

always begin
	#5  clk =  !clk;
	end


endmodule
