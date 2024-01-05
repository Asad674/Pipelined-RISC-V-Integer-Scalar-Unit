
module fetch_stage(stall, clk, rst, PCSrcM, PCTargetM, InstrD, PCD, PCPlus4D, IF_flush);
	input clk, rst, PCSrcM, stall, IF_flush;
	input [31:0] PCTargetM;
	output [31:0] InstrD, PCD, PCPlus4D;
	
	wire [31:0] PC_F, PCF, PCPlus4F, InstrF;
	
	//pipelining registers (shift to top module)
	reg [31:0] InstrF_reg;
	reg [31:0] PCF_reg, PCPlus4F_reg;
	
	
	// PC mux
	mux PC_Mux (.a(PCPlus4F), .b(PCTargetM), .c(PC_F), .sel(PCSrcM));
	
	//PC counter
	PC_mod PC( .clk(clk), .rst(rst), .PCWrite(stall), .PC(PCF), .PC_next(PC_F));

	//Instruction memory
	inst_mem InstructionMemory(.rst(rst), .A(PCF), .inst_out(InstrF));
	
	assign PCPlus4F = PCF + 4;
	

	always@(posedge clk or negedge rst or posedge IF_flush)begin
		 if(!rst)begin
			InstrF_reg <= 32'd0;
			PCF_reg <= 32'd0;
			PCPlus4F_reg <= 32'd0;
		 end
		 else if(IF_flush)begin
		 	InstrF_reg <= 32'd0;
			PCF_reg <= 32'd0;
			PCPlus4F_reg <= 32'd0;
		 end
		 else if (stall & !PCSrcM)begin
			InstrF_reg <= InstrF_reg;
			PCF_reg <= PCF_reg;
			PCPlus4F_reg <= PCPlus4F_reg;
		 end
		  else begin
			InstrF_reg <= InstrF;
			PCF_reg <= PCF;
			PCPlus4F_reg <= PCPlus4F;
		  end
		end
		
	assign InstrD = (!rst) ? 32'd0 : InstrF_reg;
	assign PCD = (!rst) ? 32'd0 : PCF_reg;
	assign PCPlus4D = (!rst) ? 32'd0 : PCPlus4F_reg;
	
endmodule

module mux(a, b, c, sel);
input [31:0] a,b;
input sel;
output [31:0] c;

assign c = (sel) ? b : a;



endmodule


module PC_mod(clk, rst, PCWrite, PC, PC_next);
	input clk, rst, PCWrite;
	input [31:0] PC_next;
	output reg [31:0] PC;

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			PC <= 32'd0;
		else if (PCWrite)
			PC <= PC;
		else 
			PC <= PC_next;
	end


endmodule

module inst_mem(rst, A, inst_out);
	input rst;
	input [31:0] A;
	output [31:0] inst_out;

	reg [31:0] mem [1023:0];
	
	initial begin
		
    mem[0] = 32'b00000000000000000000010010010011;
	 mem[1] = 32'b00000001100000000000100100010011;
	 mem[2] = 32'b00000000001000000000001010010011;
    mem[3] = 32'b00000000010110010010000000100011;
    mem[4] = 32'b00000000000100000000001010010011;
    mem[5] = 32'b00000000010110010010001000100011;
    mem[6] = 32'b00000000000100000000001010010011;
    mem[7] = 32'b00000000010110010010010000100011;
    mem[8] = 32'b00000000010100000000001010010011;
    mem[9] = 32'b00000000010110010010011000100011;
    mem[10] = 32'b00000000000000000000110010010011;
    mem[11] = 32'b00000000000000000000110100010011;
    mem[12] = 32'b00000000101000000000111000010011;
    mem[13] = 32'b00000000011000000000111010010011;
    mem[14] = 32'b00000000001000000000111100010011;
    mem[15] = 32'b00000000010000000000001100010011;
    mem[16] = 32'b00000000000010010010101010000011;
    mem[17] = 32'b00000000010010010010101100000011;
    mem[18] = 32'b00000000100010010010101110000011;
    mem[19] = 32'b00000000110010010010110000000011;
    mem[20] = 32'b00000001010101001010000000100011;
    mem[21] = 32'b00000001011001001010001000100011;
    mem[22] = 32'b00000001011101001010010000100011;
    mem[23] = 32'b00000001100001001010011000100011;
    mem[24] = 32'b00000001100101001010100000100011;
    mem[25] = 32'b00000001101001001010101000100011;
    mem[26] = 32'b00000000000111010000110100010011;
    mem[27] = 32'b00000101110011010001101001100011;
    mem[28] = 32'b00000000000111001000110010010011;
    mem[29] = 32'b00000000000111001000110010010011;
	 mem[30] = 32'b00000101110111001001111101100011;
    mem[31] = 32'b00000000000111000000110000010011;
    mem[32] = 32'b00000000000000000000110010010011;
    mem[33] = 32'b00000111110011000001010001100011;
    mem[34] = 32'b00000000000110111000101110010011;
    mem[35] = 32'b00000000000000000000110000010011;
    mem[36] = 32'b00000111110110111001100101100011;
    mem[37] = 32'b00000000000110110000101100010011;
    mem[38] = 32'b00000000000000000000101110010011;
    mem[39] = 32'b00000111110010110001111001100011;
    mem[40] = 32'b00000000000110101000101010010011;
    mem[41] = 32'b00000000000000000000101100010011;
    mem[42] = 32'b00001001111010101001011001100011;
    mem[43] = 32'b00001000011010110001011001100011;
    mem[44] = 32'b00000000000000000000101010010011;
    mem[45] = 32'b00000000000000000000101100010011;
    mem[46] = 32'b00000010000000000000100001100011;

	end

	assign inst_out = (!rst) ? (32'd0) : mem[A[31:2]];

endmodule




