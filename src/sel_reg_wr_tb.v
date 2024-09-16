module Sel_reg_wr_test;

parameter DataWidth = 8;

reg [DataWidth-1:0] literal_adr;
reg sel_reg_in_alu_decoder; //Selektion ob das Register durch ALU oder Decoder beschrieben wird, 1 = AlU, 0 = Decoder
reg [DataWidth-1:0] result;
wire [DataWidth-1:0] reg_val; //Wert der ins Register geschrieben wird

SEL_REG_WR_ALU_DECODER uut(.literal_adr(literal_adr), .result(result), 
	.sel_reg_in_alu_decoder(sel_reg_in_alu_decoder), .reg_val(reg_val)); 

initial begin
    $dumpfile("Selregwrtest.vcd");
    $dumpvars(0,Sel_reg_wr_test);
    
    sel_reg_in_alu_decoder = 1;
    literal_adr = 8'h00;
    result = 8'h00;
    //Test Write Value from ALU    
    #1
    assert(reg_val === 8'h00 );
    #9		
    result = 8'h44;
    
    //Test Write Value from Decoder
    #1
    assert(reg_val === 8'h44 );
    #9   
    sel_reg_in_alu_decoder = 0;
    literal_adr = 8'hF3;
    result = 8'h00;
    #1
    assert(reg_val === 8'hF3 );
    #9
    

	$finish();
end


endmodule
