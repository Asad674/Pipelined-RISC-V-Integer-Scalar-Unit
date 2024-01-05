

module execute_stage(clk, rst, stall, PCE, ALUSrcE, ALUOpE, RegWriteE, MemReadE, MemWriteE, MemtoRegE, BranchE, BNEE, JMPE, ReadData1_E, ReadData2_E, WriteAddr_E, ImmOut_E, 
							func7E, func3E, PCTargetM, RegWriteM, MemReadM, MemWriteM, MemtoRegM, BranchM, BNEM, JMPM, ZeroM, ReadData2_M, ALUResultM, WriteAddr_M, 
							ResultW, ForwardA, ForwardB);

	input clk, rst, stall;
	input ALUSrcE, RegWriteE, MemReadE, MemWriteE, MemtoRegE, BranchE, BNEE, JMPE;
	input [31:0] ReadData1_E, ReadData2_E, ImmOut_E, ResultW, PCE;
	input [6:0] func7E; 
	input [2:0] func3E;
	input [4:0] WriteAddr_E;
	input [1:0] ForwardA, ForwardB, ALUOpE;
	
	wire ZeroE;
	wire [3:0] ALU_opsel;
	wire [31:0] ALUSrc1, ALUSrc2, ALUSrc2_Imm, ALUResultE, PCTargetE;
	
	reg [4:0] WriteAddr_E_reg;
	reg RegWriteE_reg, MemReadE_reg, MemWriteE_reg, MemtoRegE_reg, BranchE_reg, BNEE_reg, JMPE_reg, ZeroE_reg;
	reg [31:0] ReadData2_E_reg, ALUResultE_reg, PCTargetE_reg;
	
	output [4:0] WriteAddr_M;
	output RegWriteM, MemReadM, MemWriteM, MemtoRegM, BranchM, BNEM, JMPM, ZeroM;
	output [31:0] ReadData2_M, ALUResultM, PCTargetM;
	
	// source for jump instructions
	assign PCTargetE = PCE + ImmOut_E;
	
	Imm_ALUSrcMux Imm_ALUSrcMux(.in1 (ALUSrc2), 
										 .in2 (ImmOut_E), 
										 .sel (ALUSrcE),
										 .out (ALUSrc2_Imm)
										); 
						 
	Fwd_ALUSrcMux Fwd_ALUMuxSrc1(.in1 (ReadData1_E), 
								.in2 (ResultW),
								.in3 (ALUResultM),
								.sel (ForwardA),
								.out (ALUSrc1)
								);
								
	Fwd_ALUSrcMux Fwd_ALUMuxSrc2(.in1 (ReadData2_E), 
								.in2 (ResultW),
								.in3 (ALUResultM),
								.sel (ForwardB),
								.out (ALUSrc2)
								); 
	
   ALU_Control ALUControl(.func7 (func7E),
								  .func3 (func3E),
								  .ALUOp (ALUOpE),
								  .cont_out (ALU_opsel)
								  );
							 
	ALU ALU (
		.in1(ALUSrc1),
		.in2(ALUSrc2_Imm),
		.zero(ZeroE),
		.out(ALUResultE),
		.ALUControl(ALU_opsel)
		);

	
	always @(posedge clk or negedge rst)begin
	
		if (!rst)begin
			RegWriteE_reg <= 0;
			MemReadE_reg <= 0;
			MemWriteE_reg <=0; 
			MemtoRegE_reg <=0; 
			BranchE_reg <=0; 
			BNEE_reg <= 0;
			JMPE_reg <= 0;
			ZeroE_reg <=0;
			WriteAddr_E_reg <= 5'd0;
			ALUResultE_reg <= 32'd0;
			ReadData2_E_reg <= 32'd0;
			PCTargetE_reg <= 32'd0;
		end
		
		else if (stall)begin
			RegWriteE_reg <= 0;
			MemReadE_reg <= 0;
			MemWriteE_reg <=0; 
			MemtoRegE_reg <=0; 
			BranchE_reg <=0; 
			BNEE_reg <= 0;
			JMPE_reg <= 0;
			ZeroE_reg <= ZeroE;
			WriteAddr_E_reg <= WriteAddr_E;
			ALUResultE_reg <= ALUResultE;
			ReadData2_E_reg <= ReadData2_E;
			PCTargetE_reg <= PCTargetE;
		
		end
		else begin
			RegWriteE_reg <= RegWriteE;
			MemReadE_reg <= MemReadE;
			MemWriteE_reg <= MemWriteE; 
			MemtoRegE_reg <= MemtoRegE; 
			BranchE_reg <= BranchE; 
			BNEE_reg <= BNEE;
			JMPE_reg <= JMPE;
			ZeroE_reg <= ZeroE;
			WriteAddr_E_reg <= WriteAddr_E;
			ALUResultE_reg <= ALUResultE;
			ReadData2_E_reg <= ReadData2_E;
			PCTargetE_reg <= PCTargetE;
		end
	end
	
	assign RegWriteM = RegWriteE_reg;
	assign MemReadM = MemReadE_reg;
	assign MemWriteM = MemWriteE_reg;
	assign MemtoRegM = MemtoRegE_reg;
	assign BranchM = BranchE_reg;
	assign BNEM = BNEE_reg;
	assign JMPM = JMPE_reg;
	assign ZeroM = ZeroE_reg;
	assign WriteAddr_M = WriteAddr_E_reg;
	assign ALUResultM = ALUResultE_reg;
	assign ReadData2_M = ReadData2_E_reg;
	assign PCTargetM = PCTargetE_reg;
	
	
endmodule


module ALU(in1, in2, zero, out, ALUControl);
	
	input [31:0] in1, in2;
	input [3:0] ALUControl;
	
	output zero;
	output reg [31:0] out;
	
	assign zero = ~(|(out));
	
	always @(*) begin
    case(ALUControl)
        4'b0000: out = in1 & in2;
        4'b0001: out = in1 | in2;
        4'b0010: out = in1 + in2;
        4'b0110: out = in1 - in2;
        4'b0111: out = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0;
        4'b1100: out = ~(in1 | in2);
        default: out = 32'd0;
    endcase
	end
					
	
endmodule


module Imm_ALUSrcMux (in1, in2, sel, out);

	input [31:0] in1, in2;
	input sel;
	output [31:0] out;
	
	assign out = (!sel) ? in1 : in2;
	
endmodule

module Fwd_ALUSrcMux (in1, in2, in3, sel, out);

	input [31:0] in1, in2, in3;
	input [1:0] sel;
	output reg [31:0] out;
	
	always @(*)begin
		case(sel)
			2'b00: out = in1;
			2'b01: out = in2;
			2'b10: out = in3;
		default: out = 32'd0;
	endcase
	end
endmodule


module ALU_Control(func7, func3, ALUOp, cont_out); 

	input [6:0] func7;
	input [2:0] func3;
	input [1:0] ALUOp;
	output reg [3:0] cont_out;

	wire [11:0] instr_comb;
	assign instr_comb = {ALUOp, func7, func3};

	always @(*) begin
		case (instr_comb)
        12'b000000000000, 12'b001111111111 : cont_out = 4'b0010;
        12'b010000000000, 12'b011111111111 : cont_out = 4'b0110;
        12'b100000000000, 12'b110000000000 : cont_out = 4'b0010;
        12'b100100000000, 12'b110100000000 : cont_out = 4'b0110;
        12'b100000000111, 12'b110000000111 : cont_out = 4'b0000;
        12'b000000000110, 12'b100000000110 : cont_out = 4'b0001;
        default : cont_out = 4'b0000;
    endcase
	end

endmodule
