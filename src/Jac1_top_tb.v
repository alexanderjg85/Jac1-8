module JAC1_top_test;

parameter DataWidth = 8;

reg clk;
reg sys_res_n;
wire [DataWidth-1:0] reg_val;


JAC1_Top uut(.clk(clk), .sys_res_n(sys_res_n), .reg_val(reg_val));
	

initial begin
    $dumpfile("Jac1toptest.vcd");
    $dumpvars(0,JAC1_top_test);
    clk = 0;
    sys_res_n = 0;
    #10
    sys_res_n = 1;
    #10    
    #10
    #10
    #10
    #10
    #10
    #10
    #10
    sys_res_n = 0;
    #10
    
	$finish();
end

always begin
	#5  clk =  !clk;
	end

endmodule
