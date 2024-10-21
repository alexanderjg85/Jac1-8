module status_test;

parameter NumStatusBits = 6;

reg clk;
reg res_n;
reg sel_stat_in_alu_decoder;  //Selektion ob das Register durch ALU oder Decoder beschrieben wird, 1 = AlU, 0 = Decoder
wire [NumStatusBits-1:0] status;
reg [NumStatusBits-1:0] alu_status;  //statusbits, welche in einer ALU Operation gesetzt werden
reg [NumStatusBits-1:0] dec_status;	//statusbits, welche in einer Decoder Operation gesetzt werden
reg wr_en;	//Status soll nicht in jeder Operation geändert werden, sondern nur in Operationen welche Statusregister betreffen

Status_reg uut(.clk(clk), .res_n(res_n), .status(status), .wr_en(wr_en),
 .alu_status(alu_status), .dec_status(dec_status), .sel_stat_in_alu_decoder(sel_stat_in_alu_decoder) );
 
 

initial begin
    $dumpfile("statustest.vcd");
    $dumpvars(0,status_test);

    clk = 0;
    res_n = 0;
    sel_stat_in_alu_decoder = 0;
    alu_status = 0;
    dec_status = 0;
    wr_en = 0;    
    #10
    res_n = 1;
    assert(status === 6'b00_0000);
    #10			//Alu darf Status schreiben
	wr_en = 1;
	sel_stat_in_alu_decoder = 1;
	alu_status = 6'b00_0001;
    dec_status = 6'b00_0011;
    #6
    assert(status === 6'b00_0001);
	#4
	alu_status = 6'b00_0010;
	#6
	assert(status === 6'b00_0010);
	#4
	alu_status = 4'b0000;
	#6
	assert(status === 6'b00_0000);
	#4   //keiner darf schreiben
	wr_en = 0;
	alu_status = 6'b00_0001;
	#6
	assert(status === 6'b00_0000);
	#14 //decoder darf schreiben
	sel_stat_in_alu_decoder = 0;
	wr_en = 1;
	#6
	assert(status === 6'b00_0011);
	#4
	
	 $finish();
end

always begin
	#5  clk =  !clk;
	end


endmodule
