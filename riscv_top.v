
module riscv_top(clk, rst);
	input clk, rst;
	wire PCSrcM, stall, ALUSrcE, BranchE, BNEE, JMPE, RegWriteE, MemReadE, MemWriteE, MemToRegE;
	wire RegWriteM, MemReadM, MemWriteM, BranchM, BNEM, JMPM, ZeroM, MemToRegM, MemToRegW, RegWriteW, IF_flush;
	wire [1:0] ForwardA, ForwardB, ALUOpE;
	wire [4:0] WriteAddrW, WriteAddrE, WriteAddrM, Rs1E, Rs2E, RdE;
	wire [6:0] func7E;
	wire [2:0] func3E;
	
	wire [31:0] InstrD, PCD, PCE, PCPlus4D, ReadData1_E, ReadData2_E, ImmOut_E;
	wire [31:0] ReadData2_M, ALUResultM, PCTargetM, MemOutW, ALUResultW, ResultW;
	
	

	fetch_stage FetchCycle(.stall (stall), 
					.clk (clk), 
					.rst (rst), 
					.PCSrcM (PCSrcM), 
					.PCTargetM (PCTargetM), 
					.InstrD (InstrD), 
					.PCD (PCD), 
					.PCPlus4D (PCPlus4D),
					.IF_flush (IF_flush)
					);

	decode_stage DecodeCycle(.clk (clk), 
					 .rst (rst), 
					 .stall (stall), 
					 .InstrD (InstrD), 
					 .PCD (PCD), 
					 .PCPlus4D (PCPlus4D), 
					 .PCE (PCE),
					 .ALUSrcE (ALUSrcE),
					 .ALUOpE (ALUOpE), 
					 .RegWriteE (RegWriteE), 
					 .MemReadE (MemReadE), 
					 .MemWriteE (MemWriteE), 
					 .MemToRegE (MemToRegE), 
					 .BranchE (BranchE), 
					 .BNEE (BNEE),
					 .JMPE (JMPE),
					 .WriteAddrE (WriteAddrE), 
					 .ReadData1_E (ReadData1_E), 
					 .ReadData2_E (ReadData2_E), 
					 .ImmOut_E (ImmOut_E), 
					 .func7E (func7E), 
					 .func3E (func3E), 
					 .Rs1E (Rs1E),
					 .Rs2E (Rs2E),
					 .RdE (RdE),
					 .RegWriteW (RegWriteW), 
					 .RDW (WriteAddrW), 
					 .ResultW (ResultW)
					 );
					 
	execute_stage ExecuteCycle(.clk (clk), 
					  .rst (rst),
					  .stall (stall), 
					  .PCE (PCE), 
					  .ALUSrcE (ALUSrcE), 
					  .ALUOpE (ALUOpE), 
					  .RegWriteE (RegWriteE), 
					  .MemReadE (MemReadE), 
					  .MemWriteE (MemWriteE), 
					  .MemtoRegE (MemToRegE), 
					  .BranchE (BranchE), 
					  .BNEE (BNEE),
					  .JMPE (JMPE),
					  .ReadData1_E (ReadData1_E), 
					  .ReadData2_E (ReadData2_E), 
					  .WriteAddr_E (WriteAddrE), 
					  .ImmOut_E (ImmOut_E), 
					  .func7E (func7E), 
					  .func3E (func3E), 
					  .PCTargetM (PCTargetM), 
					  .RegWriteM (RegWriteM), 
					  .MemReadM (MemReadM), 
					  .MemWriteM (MemWriteM), 
					  .MemtoRegM (MemToRegM), 
					  .BranchM (BranchM), 
					  .BNEM (BNEM),
					  .JMPM (JMPM),
					  .ZeroM (ZeroM), 
					  .ReadData2_M (ReadData2_M), 
					  .ALUResultM (ALUResultM), 
					  .WriteAddr_M (WriteAddrM), 
					  .ResultW (ResultW), 
					  .ForwardA (ForwardA), 
					  .ForwardB (ForwardB)
					  );
					  
	memory_stage MemoryCycle(.clk (clk), 
					 .rst (rst), 
					 .PCSrcM (PCSrcM), 
					 .RegWriteM (RegWriteM), 
					 .MemReadM (MemReadM), 
					 .MemWriteM (MemWriteM), 
					 .MemToRegM (MemToRegM), 
					 .BranchM (BranchM), 
					 .BNEM (BNEM),
					 .JMPM (JMPM),					 
					 .ZeroM (ZeroM), 
					 .ReadData2_M (ReadData2_M), 
					 .ALUResult_M (ALUResultM), 
					 .WriteAddr_M (WriteAddrM), 
					 .MemOutW (MemOutW), 
					 .MemToRegW (MemToRegW), 
					 .WriteAddr_W (WriteAddrW), 
					 .ALUResult_W (ALUResultW),
					 .RegWriteW (RegWriteW)
					 );
	
	writeback_stage WritebackCycle(.MemOutW (MemOutW), 
						 .MemToRegW (MemToRegW), 
						 .ResultW (ResultW),
						 .ALUResult_W (ALUResultW)
						 );
						 
	forwarding_unit ForwardingUnit(.Rs1E (Rs1E), 
						 .Rs2E (Rs2E), 
						 .RdE (RdE),
						 .RegWriteM (RegWriteM), 
						 .RegWriteW (RegWriteW), 
						 .RdM (WriteAddrM), 
						 .RdW (WriteAddrW), 
						 .ForwardA (ForwardA), 
						 .ForwardB (ForwardB)
						 );
						 
	hazard_detection HazardDetection(.MemReadE (MemReadE), 
						  .RdE (WriteAddrE), 
						  .Rs1D (InstrD[19:15]), 
						  .Rs2D (InstrD[24:20]), 
						  .stall(stall),
						  .IF_flush (IF_flush),
						  .InstrD (InstrD),
						  .Branch_is (PCSrcM)
						  );

endmodule
