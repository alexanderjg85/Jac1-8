//`define Op_NOP 5'b0_0000
//`define Op_ADD 5'b0_0001 

//module ALU(clock, opcode, operand1, operand2, param, result, status);
module ALU_J(opcode, operand1, operand2, param, result, status);

parameter DataWidth = 8;
parameter NumOpCodeBits = 5;
parameter ParamBits = 8;
parameter NumStatusBits = 3;

//logic & arithmetic commands
parameter Op_NOP  = 5'b0_0000;
parameter Op_ADD  = 5'b0_0001; 
parameter Op_SUB  = 5'b0_0010;
parameter Op_AND  = 5'b0_0011;
parameter Op_OR   = 5'b0_0100;
parameter Op_NOT  = 5'b0_0101;
parameter Op_XOR  = 5'b0_0110;
parameter Op_SHL  = 5'b0_0111;
parameter Op_SHR  = 5'b0_1000;
parameter Op_VAL  = 5'b0_1001;
//reserved
parameter OP_RES1 = 5'b0_1010;
parameter OP_RES2 = 5'b0_1011;
parameter OP_RES3 = 5'b0_1100;
parameter OP_RES4 = 5'b0_1101;
parameter OP_RES5 = 5'b0_1110;
parameter OP_RES6 = 5'b0_1111;
//programm flow commands
parameter Op_GOTO = 5'b1_0000;
parameter Op_IFZ  = 5'b1_0001;
parameter Op_IFNZ = 5'b1_0010;
parameter Op_IFEQ = 5'b1_0011;
parameter Op_IFST = 5'b1_0100;
parameter Op_IFGT = 5'b1_0101;
//reserved
parameter OP_RES7 = 5'b1_0110;
parameter OP_RES8 = 5'b1_0111;
//Load & store commands
parameter OP_RES9 = 5'b1_1000;
parameter OP_RES10 = 5'b1_1001;
parameter OP_RES11 = 5'b1_1010;
parameter OP_RES12 = 5'b1_1011;
//IO commands
parameter OP_RES13 = 5'b1_1100;
parameter OP_RES14 = 5'b1_1101;
parameter OP_RES15 = 5'b1_1110;
parameter OP_RES16 = 5'b1_1111;

//input clock;
input [NumOpCodeBits-1:0] opcode;
input [DataWidth-1:0] operand1;
input [DataWidth-1:0] operand2;
input [ParamBits-1:0] param;
output reg[DataWidth-1:0] result;
output reg [NumStatusBits-1:0] status;  //Statussis: Zero, Underflow,  Carry
// 0 = Carry, 1 = Underflow, 2 = Zero

//reg [DataWidth:0] result_carry;
integer i;

always@(*) begin

case (opcode)
Op_NOP: begin  result <= 8'b0000_0000; status <= 3'b000; end
Op_ADD: begin  {status[0],result[DataWidth-1:0]} <= operand1 + operand2;
			 //result_carry = operand1 + operand2;
			 //status[0] = result_carry[DataWidth];  result = result_carry[DataWidth-1:0];
			 status[1] <= 0;
			 //auf Zero  prüfen
			 if(operand1 + operand2 === 0) begin
				status[2] <= 1;
			 end else begin
				status[2] <= 0;
			 end
		 end
Op_SUB: begin result = operand1 - operand2;
			status[0] = 0;
			if(operand2 > operand1) begin //Underflow, wenn Operand 2 groeßer als Operand1
				status[1] = 1;
			end else begin
				status[1] = 0;
			end
			//auf Zero  prüfen, wenn 2 gleiche Zahlen voneinander subtrahiert werden ist das Ergebnis 0
			 if(operand1 === operand2) begin
				status[2] <= 1;
			 end else begin
				status[2] <= 0;
			 end
		end
Op_AND: begin for (i=0; i < DataWidth; i=i+1)
			begin 
				result[i] <= operand1[i] & operand2[i];
			end
			if(result !== 0) begin
				status <= 3'b000;
			end else begin  //bei 0 Zero-Bit setzen, andere Statusbits können nicht auftreten
				status <= 3'b100;
			end
		end
Op_OR: begin for (i=0; i < DataWidth; i=i+1)
			begin 
				result[i] <= operand1[i] | operand2[i];
			end
			if(result !== 0) begin
				status <= 3'b000;
			end else begin  //bei 0 Zero-Bit setzen, andere Statusbits können nicht auftreten
				status <= 3'b100;
			end
		end
Op_NOT: begin for (i=0; i < DataWidth; i=i+1)
			begin 
				result[i] <= ~ operand2[i];
			end
			if(result !== 0) begin
				status <= 3'b000;
			end else begin  //bei 0 Zero-Bit setzen, andere Statusbits können nicht auftreten
				status <= 3'b100;
			end
		end
Op_XOR: begin
			for (i=0; i < DataWidth; i=i+1)
			begin
				result[i] <= operand1[i] ^ operand2[i];
			end
			if(result !== 0) begin
				status <= 3'b000;
			end else begin  //bei 0 Zero-Bit setzen, andere Statusbits können nicht auftreten
				status <= 3'b100;
			end
		end
Op_SHL: begin
			if (param >= DataWidth) begin
				result <= operand1 << DataWidth;
			end else begin
				result <= operand1 << param;
			end
			if(result !== 0) begin
				status <= 3'b000;
			end else begin  //bei 0 Zero-Bit setzen, andere Statusbits können nicht auftreten
				status <= 3'b100;
			end
		end
Op_SHR: begin
			if (param >= DataWidth) begin
				result <= operand1 >> DataWidth;
			end else begin
				result <= operand1 >> param;
			end
			if(result !== 0) begin
				status <= 3'b000;
			end else begin  //bei 0 Zero-Bit setzen, andere Statusbits können nicht auftreten
				status <= 3'b100;
			end
		end
//Op_VAL: No AlU Command


default: begin result <= 8'b0000_0000;  status <= 3'b000; end


endcase

end

endmodule


