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
    #6
    assert(instruction === 16'b0100_1001_0000_0011);
    #4
    program_counter = 1;
    #6
    assert(instruction === 16'b0100_1010_0001_0100);
    #4
    program_counter = 2;
    #6
    assert(instruction === 16'b0100_1011_1111_0000);
    #4 
    program_counter = 3;
	#6
    assert(instruction === 16'b0000_1001_0001_0000);
    #4 
	program_counter = 4;
    #6
    assert(instruction === 16'b0001_1001_0001_1000);
    #4  
    program_counter = 5;
	#6
    assert(instruction === 16'b0100_1000_0000_1111);
    #4
	program_counter = 6;
	#6
    assert(instruction === 16'b0010_0000_0000_1000);
    #4
	program_counter = 7;
	#6
    assert(instruction === 16'b0010_1001_0001_1000);
    #4
	program_counter = 8;
	#6
    assert(instruction === 16'b0011_0011_0000_1000);
    #4
	program_counter = 9;
	#6
    assert(instruction === 16'b0001_0011_0000_1000);
    #4
    program_counter = 10;
    #6
    assert(instruction === 16'b1000_1000_0000_0010);
    #4
	program_counter = 11;
	#6
    assert(instruction === 16'b0000_0000_0000_0000);
    #4
    program_counter = 12;
	#6
    assert(instruction === 16'b0000_0000_0000_0000);
    #4
    program_counter = 13;
	#6
    assert(instruction === 16'b0011_1001_0000_0010);
    #4
    program_counter = 14;
	#6
    assert(instruction === 16'b0100_0010_0000_0100);
    #4
    program_counter = 15;
	#6
    assert(instruction === 16'b1001_0000_0000_0011);
    #4
    program_counter = 16;
	#6
    assert(instruction === 16'b0000_0000_0000_0000);
    #4
    program_counter = 17;
	#6
    assert(instruction === 16'b0000_0000_0000_0000);
    #4
    program_counter = 18;
	#6
    assert(instruction === 16'b0000_0000_0000_0000);
    #4
    program_counter = 19;
	#6
    assert(instruction === 16'b0001_0010_0001_0000);
    #4
    program_counter = 20;
	#6
    assert(instruction === 16'b1000_1000_0000_0001);
    #4
    program_counter = 21;
	#6
    assert(instruction === 16'b0000_0000_0000_0000);
    #4
    program_counter = 22;
	#6
    assert(instruction === 16'b1001_1000_0000_0001);
    #4
    program_counter = 23;
	#6
    assert(instruction === 16'b0000_0000_0000_0000);
    #4
    program_counter = 24;
	#6
    assert(instruction === 16'b0000_1001_0001_0000);
    #4
    program_counter = 25;
	#6
    assert(instruction === 16'b1001_1000_0000_0001);
    #4
    program_counter = 26;
	#6
    assert(instruction === 16'b0000_0000_0000_0000);
    #4
    program_counter = 27;
	#6
    assert(instruction === 16'b0101_0001_0000_0000);
    #4
    program_counter = 28;
	#6
    assert(instruction === 16'b0101_0000_0000_1000);
    #4
    program_counter = 29;
	#6
    assert(instruction === 16'b1000_0000_0000_1000);
    #4
	
	 $finish();
end

always begin
	#5  clk =  !clk;
	end


endmodule
