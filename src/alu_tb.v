module alu_test;


parameter DataWidth = 8;
parameter NumOpCodeBits = 5;
parameter ParamBits = 8;
parameter NumStatusBits = 2;

parameter Op_NOP = 5'b0_0000;
parameter Op_ADD = 5'b0_0001;
parameter Op_SUB = 5'b0_0010;
parameter Op_AND = 5'b0_0011;
parameter Op_OR  = 5'b0_0100;
parameter Op_NOT = 5'b0_0101;
parameter Op_SHL = 5'b0_0110;
parameter Op_SHR = 5'b0_0111;
parameter Op_VAL = 5'b0_1000;

reg[NumOpCodeBits-1:0] opcode_t;
reg [DataWidth-1:0] operand1_t;
reg [DataWidth-1:0] operand2_t;
reg [ParamBits-1:0] param_t;
wire [DataWidth-1:0] result_t;
wire [NumStatusBits-1:0] status_t;

ALU_J uut(.opcode(opcode_t), .operand1(operand1_t), .operand2(operand2_t),
 .param(param_t), .result(result_t), .status(status_t));
//inverter uut(a,y);

initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0,alu_test);

    opcode_t = Op_NOP;
    operand1_t = 0;
    operand2_t = 0;
    param_t = 0;
    
    #10
    opcode_t = Op_ADD;
    operand1_t = 1;
    operand2_t = 3;
    #10 
    opcode_t = Op_ADD;
    operand1_t = 4;
    operand2_t = 6;
    #10
    opcode_t = Op_ADD;
    operand1_t = 255;
    operand2_t = 2;
    #10
    opcode_t = Op_AND;
    operand1_t = 8'b1100_1100;
    operand2_t = 8'b1010_1010;
    #10
    opcode_t = Op_OR;
    operand1_t = 8'b1111_0000;
    operand2_t = 8'b0000_1111;
    #10
    opcode_t = Op_OR;
    operand1_t = 8'b0101_1100;
    operand2_t = 8'b1010_1100;
    #10
    opcode_t = Op_NOT;
    operand1_t = 8'b1111_0000;
    operand2_t = 8'b0000_1111;
    #10
    opcode_t = Op_NOT;
    operand1_t = 8'b0101_1100;
    operand2_t = 8'b1010_1100;
    #10
    $finish();
end


endmodule