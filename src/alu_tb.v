module alu_test;


parameter DataWidth = 8;
parameter NumOpCodeBits = 5;
parameter ParamBits = 8;
parameter NumStatusBits = 6;

parameter CarryBit = 0;
parameter UnderflowBit = 1;
parameter ZeroBit = 2;
parameter EqualBit = 3;
parameter GreaterThanBit = 4;
parameter SmallerThanBit = 5;

parameter Op_NOP = 5'b0_0000;
parameter Op_ADD = 5'b0_0001;
parameter Op_SUB = 5'b0_0010;
parameter Op_AND = 5'b0_0011;
parameter Op_OR  = 5'b0_0100;
parameter Op_NOT = 5'b0_0101;
parameter Op_XOR = 5'b0_0110;
parameter Op_SHL = 5'b0_0111;
parameter Op_SHR = 5'b0_1000;
parameter Op_VAL = 5'b0_1001;
parameter Op_CMP = 5'b0_1010;
parameter Op_ADDC = 5'b0_1011;
parameter Op_SUBU = 5'b0_1100;

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
    #1
    assert(result_t === 4);
    assert(status_t[3:0] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 1); //smaller than
    #9 
    opcode_t = Op_ADD;
    operand1_t = 4;
    operand2_t = 6;
    #1
    assert(result_t === 10);
    assert(status_t[3:0] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 1); //smaller than
    #9
    opcode_t = Op_ADD;
    operand1_t = 255;
    operand2_t = 2;
    #1
    assert(result_t === 1);
    assert(status_t[CarryBit] === 1);
    assert(status_t[3:1] === 0);
    assert(status_t[GreaterThanBit] === 1);	//greater than
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_AND;
    operand1_t = 8'b1100_1100;
    operand2_t = 8'b1010_1010;
    #1
    assert(result_t === 8'b1000_1000);
    assert(status_t[3:0] === 0);
    assert(status_t[GreaterThanBit] === 1);	//greater than
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_AND;
    operand1_t = 8'b1100_1100;
    operand2_t = 8'b0011_0011;
    #1
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 0);
    assert(status_t[ZeroBit] === 1);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 1);	//greater than
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_ADD;
    operand1_t = 8'b1111_1111;
    operand2_t = 8'b0000_0001;
    #1 //Add 255 + 1 = 256 und somit Overflow Bit aber nicht Zero Bit
    assert(result_t === 8'b0000_0000);
    assert(status_t[CarryBit] === 1);
    assert(status_t[UnderflowBit] === 0);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 1);	//greater than
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_ADD;
    operand1_t = 8'b0000_0000;
    operand2_t = 8'b0000_0000;
    #1 //Add 0 + 0 = 0 und somit Zero Bit und Equal Bit gesetzt
    assert(result_t === 8'b0000_0000);
    assert(status_t[CarryBit] === 0);
    assert(status_t[UnderflowBit] === 0);
    assert(status_t[ZeroBit] === 1)
    assert(status_t[EqualBit] === 1); //equal
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_OR;
    operand1_t = 8'b1111_0000;
    operand2_t = 8'b0000_1111;
    #1
    assert(result_t === 8'b1111_1111);
    assert(status_t[3:0] === 0);
    assert(status_t[GreaterThanBit] === 1);	//greater than
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_OR;
    operand1_t = 8'b0101_1100;
    operand2_t = 8'b1010_1100;
    #1
    assert(result_t === 8'b1111_1100);
    assert(status_t[3:0] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 1);	//smaller than
    #9
    opcode_t = Op_OR;
    operand1_t = 8'b0000_0000;
    operand2_t = 8'b0000_0000;
    #1 //0 Or 0 = 0 und Zero Flag + EqualBit
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 0);
    assert(status_t[ZeroBit] === 1);
    assert(status_t[EqualBit] === 1);	//equal
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_NOT;
    operand1_t = 8'b1111_0000;
    operand2_t = 8'b0000_1111;
    #1
    assert(result_t === 8'b1111_0000);
    assert(status_t === 0);
    #9
    opcode_t = Op_NOT;
    operand1_t = 8'b0101_1100;
    operand2_t = 8'b1010_1100;
    #1
    assert(result_t === 8'b0101_0011);
    assert(status_t === 0);
    #9
    opcode_t = Op_NOT;
    operand1_t = 8'b0000_1111;
    operand2_t = 8'b1111_1111;
    #1  //Not 255 = 0 und Zero Flag
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 0);
    assert(status_t[ZeroBit] === 1);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_XOR;
    operand1_t = 8'b0000_1111;
    operand2_t = 8'b1111_1111;
    #1  //15 XOR 255 = 240 und kein Status-Flag gesetzt
    assert(result_t === 8'b1111_0000);
    assert(status_t[1:0] === 0);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 1);	//smaller than
    #9
    opcode_t = Op_XOR;
    operand1_t = 8'b1010_1111;
    operand2_t = 8'b0101_0101;
    #1  //b1010_111 XOR b01010_0101 = 250 und kein Status-Flag gesetzt
    assert(result_t === 8'b1111_1010);
    assert(status_t[1:0] === 0);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 1);	//greater than
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_XOR;
    operand1_t = 8'b1111_0000;
    operand2_t = 8'b1111_0000;
    #1  //140 XOR 240 = 0 und Zero-Flag + Equal Bit gesetzt
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 0);
    assert(status_t[ZeroBit] === 1);
    assert(status_t[EqualBit] === 1);	//equal
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_SUB;
    operand1_t = 8'b0011_1111;
    operand2_t = 8'b0000_1111;
    #1  //63 - 15 = 48 und kein Status-Flag gesetzt
    assert(result_t === 8'b0011_0000);
    assert(status_t[1:0] === 0);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 1);	//greater than
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_SUB;
    operand1_t = 8'b0000_1110;
    operand2_t = 8'b0000_1111;
    #1  //14 - 15 = 255 und Underflow-Flag gesetzt
    assert(result_t === 8'b1111_1111);
    assert(status_t[1:0] === 2'b10);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 1);	//smaller than
    #9
    opcode_t = Op_SUB;
    operand1_t = 8'b0111_1110;
    operand2_t = 8'b0111_1110;
    #1  //176 - 176 = 0 und Zero-Flag + Equal Bit gesetzt
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 1);
    assert(status_t[EqualBit] === 1);	//equal
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_SHL;
    operand1_t = 8'b0111_0110;
    operand2_t = 8'b0000_0000;
    param_t = 8'b0000_0001;
    #1  //0111_0110 << 1 = 1110_1100 und kein Status-Flag gesetzt
    assert(result_t === 8'b1110_1100);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_SHL;
    operand1_t = 8'b0000_0110;
    operand2_t = 8'b0000_0000;
    param_t = 8'b0000_0011;
    #1  //0000_0110 << 3 = 0110_0000 und kein Status-Flag gesetzt
    assert(result_t === 8'b0011_0000);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_SHL;
    operand1_t = 8'b1111_0110;
    operand2_t = 8'b0000_0000;
    param_t = 8'b0011_0011;
    #1  //1111_0110 << 8 = 0000_0000 und Zero-Bit gesetzt
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 1);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_SHR;
    operand1_t = 8'b0111_0110;
    operand2_t = 8'b0000_0000;
    param_t = 8'b0000_0001;
    #1  //0111_0110 >> 1 = 0011_1011 und kein Status-Flag gesetzt
    assert(result_t === 8'b0011_1011);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_SHR;
    operand1_t = 8'b0110_0110;
    operand2_t = 8'b0000_0000;
    param_t = 8'b0000_0100;
    #1  //0110_0110 >> 4 = 0000_0110 und kein Status-Flag gesetzt
    assert(result_t === 8'b0000_0110);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9    
    opcode_t = Op_SHR;
    operand1_t = 8'b1111_0110;
    operand2_t = 8'b0000_0000;
    param_t = 8'b0011_0011;
    #1  //1111_0110 >> 8 = 0000_0000 und Zero-Bit gesetzt
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 1);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_CMP;
    operand1_t = 8'b1111_0110;
    operand2_t = 8'b0000_0000;
    param_t = 8'b0000_0000;
    #1  //1111_0110 > 0 = 0000_0000 und Greater Than-Bit gesetzt
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 1);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_CMP;
    operand1_t = 8'b1111_0110;
    operand2_t = 8'b1111_0110;
    param_t = 8'b0000_0000;
    #1  //1111_0110 = 1111_0110 -> = 0000_0000 und Equal-Bit gesetzt
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 1);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 0);
    #9
    opcode_t = Op_CMP;
    operand1_t = 8'b0111_0110;
    operand2_t = 8'b1111_0110;
    param_t = 8'b0000_0000;
    #1  //0111_0110 < 1111_0110  = 0000_0000 und Smaller Than-Bit gesetzt
    assert(result_t === 8'b0000_0000);
    assert(status_t[1:0] === 2'b00);
    assert(status_t[ZeroBit] === 0);
    assert(status_t[EqualBit] === 0);
    assert(status_t[GreaterThanBit] === 0);
    assert(status_t[SmallerThanBit] === 1);
    #9
    
    $finish();
end


endmodule
