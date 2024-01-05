
module forwarding_unit(Rs1E, Rs2E, RdE, RegWriteM, RegWriteW, RdM, RdW, ForwardA, ForwardB);
	
	input RegWriteM, RegWriteW;
	input [4:0] Rs1E, Rs2E, RdE, RdM, RdW;

	output [1:0] ForwardA, ForwardB;
	
	wire EX1_Hazard, EX2_Hazard, MEM1_Hazard, MEM2_Hazard;
		
	assign EX1_Hazard = (RegWriteM) & (RdM != 5'd0) & RdM == Rs1E;
	assign MEM1_Hazard = (RegWriteW) & (RdW != 5'd0) &  (~EX1_Hazard) & (RdW == Rs1E);
	
	assign EX2_Hazard = (RegWriteM) & (RdM != 5'd0) & RdM == Rs2E;
	assign MEM2_Hazard = (RegWriteW) & (RdW != 5'd0) &  (~EX2_Hazard) & (RdW == Rs2E);
	
	assign ForwardA = (EX1_Hazard) ? (2'b10) : (MEM1_Hazard) ? (2'b01) : (2'b00);
	assign ForwardB = (EX2_Hazard) ? (2'b10) : (MEM2_Hazard) ? (2'b01) : (2'b00);


endmodule
