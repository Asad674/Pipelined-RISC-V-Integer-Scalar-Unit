
module decode_stage(clk, rst, stall, InstrD, PCD, PCPlus4D, PCE, ALUSrcE, ALUOpE, RegWriteE, MemReadE, MemWriteE, MemToRegE, BranchE, BNEE, JMPE, WriteAddrE, 
						ReadData1_E, ReadData2_E, ImmOut_E, func7E, func3E, Rs1E, Rs2E, RdE, RegWriteW, RDW, ResultW);
	
	//inputs
	input clk, rst, RegWriteW, stall;
	input [4:0] RDW;
	input [31:0] InstrD, PCD, PCPlus4D, ResultW;
	
	//interim outputs
	wire [31:0] ReadData1_D, ReadData2_D, ImmOut_D;
	wire [1:0] ALUOpD;
	wire ALUSrcD, MemReadD, MemToRegD, MemWriteD, BranchD, BNED, RegWriteD, JMPD;

	
	//pipeline registers
	reg ALUSrcD_reg, BranchD_reg, BNED_reg, JMPD_reg, RegWriteD_reg, MemReadD_reg, MemWriteD_reg, MemToRegD_reg;
	reg [1:0] ALUOpD_reg;
	reg [4:0] WriteAddrD_reg, Rs1D_reg, Rs2D_reg, RdD_reg;
	reg [31:0] ReadData1_D_reg, ReadData2_D_reg, ImmOut_D_reg, PCD_reg; 
	reg [6:0] func7D_reg;
	reg [2:0] func3D_reg;
	
	//output signals
	output ALUSrcE, BranchE, BNEE, JMPE, RegWriteE, MemReadE, MemWriteE, MemToRegE;
	output [1:0] ALUOpE;
	output [4:0] WriteAddrE, Rs1E, Rs2E, RdE;
	output [31:0] ReadData1_E, ReadData2_E, ImmOut_E, PCE;
	output [6:0] func7E;
	output [2:0] func3E;
	
	Control ControlUnit(.InstrD (InstrD[6:0]),
							  .func3 (InstrD[14:12]),
							  .RegWrite (RegWriteD),
							  .ALUOp (ALUOpD),
							  .ALUSrc (ALUSrcD),
							  .MemRead (MemReadD),
							  .MemToReg (MemToRegD),
							  .MemWrite (MemWriteD),
							  .Branch (BranchD),
							  .BNE (BNED),
							  .JMP (JMPD)
							  );
							  
	 
	RegFile RegisterFile(.clk (clk), 
								.rst (rst), 
								.RA1 (InstrD[19:15]), 
								.RA2 (InstrD[24:20]), 
								.RD1 (ReadData1_D), 
								.RD2 (ReadData2_D), 
								.WA (RDW), 
								.WD (ResultW), 
								.RegWrite(RegWriteW)
								);
								
	ImmGen ImmediateGeneration(.instruction (InstrD), 
										.immediate (ImmOut_D));
										
										
										
	always @(posedge clk or negedge rst)begin
		
		if (!rst )begin
			ALUSrcD_reg <= 0;
			ALUOpD_reg <= 0;
			BranchD_reg <= 0; 
			RegWriteD_reg <= 0;
			MemReadD_reg <= 0;
			MemWriteD_reg <= 0; 
			MemToRegD_reg <= 0;
			PCD_reg <= 0;
			WriteAddrD_reg <= 4'd0;
			ReadData1_D_reg <= 31'd0;
			ReadData2_D_reg <= 31'd0;
			ImmOut_D_reg <= 31'd0; 
			func7D_reg <= 7'd0;
			func3D_reg <= 3'd0;
			Rs1D_reg <= 5'd0;
			Rs2D_reg <= 5'd0;
			BNED_reg <= 0;
			JMPD_reg <= 0;
		end
		else if (stall)begin
			ALUSrcD_reg <= 0;
			ALUOpD_reg <= 0;
			BranchD_reg <= 0; 
			RegWriteD_reg <= 0;
			MemReadD_reg <= 0;
			MemWriteD_reg <= 0; 
			MemToRegD_reg <= 0;	
			BNED_reg <= 0;
			JMPD_reg <= 0;	
			PCD_reg <= PCD;
			WriteAddrD_reg <= InstrD[11:7];
			ReadData1_D_reg <= ReadData1_D;
			ReadData2_D_reg <= ReadData2_D;
			ImmOut_D_reg <= ImmOut_D; 	
			func7D_reg <= InstrD[31:25];
			func3D_reg <= InstrD[14:12];
			Rs1D_reg <= InstrD[19:15];
			Rs2D_reg <= InstrD[24:20];		

		end
		else begin
			ALUSrcD_reg <= ALUSrcD;
			ALUOpD_reg <= ALUOpD;
			BranchD_reg <= BranchD; 
			RegWriteD_reg <= RegWriteD;
			MemReadD_reg <= MemReadD;
			MemWriteD_reg <= MemWriteD; 
			MemToRegD_reg <= MemToRegD;
			PCD_reg <= PCD;
			WriteAddrD_reg <= InstrD[11:7];
			ReadData1_D_reg <= ReadData1_D;
			ReadData2_D_reg <= ReadData2_D;
			ImmOut_D_reg <= ImmOut_D; 	
			func7D_reg <= InstrD[31:25];
			func3D_reg <= InstrD[14:12];
			Rs1D_reg <= InstrD[19:15];
			Rs2D_reg <= InstrD[24:20];	
			RdD_reg <= InstrD[11:7];
			BNED_reg <= BNED;
			JMPD_reg <= JMPD;
		end
	end
	
//output signals

	assign ALUSrcE = ALUSrcD_reg;
	assign ALUOpE = ALUOpD_reg;
	assign BranchE = BranchD_reg; 
	assign RegWriteE = RegWriteD_reg;
	assign MemReadE = MemReadD_reg;
	assign MemWriteE = MemWriteD_reg; 
	assign MemToRegE = MemToRegD_reg;
	assign PCE = PCD_reg;
	assign WriteAddrE = WriteAddrD_reg;
	assign ReadData1_E = ReadData1_D_reg;
	assign ReadData2_E = ReadData2_D_reg;
	assign ImmOut_E = ImmOut_D_reg; 	
	assign func7E = func7D_reg;
	assign func3E = func3D_reg;
	assign  Rs1E = Rs1D_reg;
	assign  Rs2E = Rs2D_reg;
	assign  RdE = RdD_reg;
	assign  BNEE = BNED_reg;
	assign  JMPE = JMPD_reg;
	endmodule
	
	
	module Control(InstrD, func3, RegWrite, ALUOp, ALUSrc, MemRead, MemToReg, MemWrite, Branch, BNE, JMP);
	
	input [6:0] InstrD;
	input [2:0] func3;
	output RegWrite, ALUSrc, MemRead, MemToReg, MemWrite, Branch, BNE, JMP;
	output [1:0] ALUOp;
	
	assign ALUSrc = (InstrD == 7'b0000011 | InstrD == 7'b0010011) ? 1'b1 : 1'b0;
	assign MemToReg = (InstrD == 7'b0000011) ? 1'b1 : 1'b0;
	assign RegWrite = (InstrD == 7'b0110011 | InstrD == 7'b0010011 | InstrD == 7'b0000011) ? 1'b1 : 1'b0; 
	assign MemRead = (InstrD == 7'b0000011) ? 1'b1 : 1'b0;
	assign MemWrite = (InstrD == 7'b0100011) ? 1'b1 : 1'b0;
	assign Branch = (InstrD == 7'b1100011 & func3 == 3'b000) ? 1'b1 : 1'b0;
	assign BNE = (InstrD == 7'b1100011 & func3 == 3'b001) ? 1'b1 : 1'b0;
	assign JMP = (InstrD == 7'b1101111) ? 1'b1 : 1'b0;
	assign ALUOp[1] = (InstrD == 7'b0110011) ? 1'b1 : 1'b0;
	assign ALUOp[0] = (InstrD == 7'b1100011) ? 1'b1 : 1'b0;
	
	endmodule
	
	
	module RegFile(clk, rst, RA1, RA2, RD1, RD2, WA, WD, RegWrite);
		input clk, rst, RegWrite;
		input [4:0] RA1, RA2, WA; 
		input [31:0] WD;
		output [31:0] RD1, RD2;
	
		reg [31:0] Registers [31:0];
		
		integer i;
		
		initial begin
			for (i = 0; i < 32; i = i + 1) begin
				Registers[i] = 32'd0;
			end
		end
		
		always@(negedge clk)begin
		if (RegWrite==1 && WA != 5'd0)
			Registers[WA] <= WD;
		else 
			Registers[WA] <= Registers[WA];
		end
		
		assign RD1 = (!rst) ? 32'd0 : Registers[RA1];
		assign RD2 = (!rst) ? 32'd0 : Registers[RA2];
		
		
	endmodule
	
	
	module ImmGen(instruction, immediate);
		
		input [31:0] instruction;
		output reg [31:0] immediate;
		
		always @ (instruction)
		begin
			//I-Type and Load
			if (instruction [6:0] == 7'b0000011 || instruction [6:0] == 7'b0010011)

			begin
				immediate [11:0] = instruction[31:20];
				immediate [31:12] = {20{instruction[31]}};
			end
			
			// (S-Type) Store
			else 	if (instruction [6:0] == 7'b0100011)
			begin
				immediate [4:0] = instruction[11:7];
				immediate [11:5] = instruction[31:25];
				immediate [31:12] = {20{instruction[31]}};
			end
	
			// (SB-Type)Condition Branch
			else 	if (instruction [6:0] == 7'b1100011)
			begin
				immediate [0] = 1'b0;
				immediate [11] = instruction[7];
				immediate [4:1] = instruction[11:8];
				immediate [10:5] = instruction[30:25];
				immediate [31:12] = {20{instruction[31]}};
			end
			//UJ-Type
			else 	if (instruction [6:0] == 7'b1101111)
			begin
				immediate [0] = 1'b0;
				immediate [19:12] = instruction[19:12];
				immediate [11] = instruction[20];
				immediate [10:1] = instruction[30:21];
				immediate [31:20] = {12{instruction[31]}};
			end
			//U-Type
			else
			begin
				immediate [31:12] = instruction[31:12];
				immediate [11:0] = 0;
			end
	
	
		end


endmodule 

	


