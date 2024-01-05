
module hazard_detection(Branch_is, InstrD, MemReadE, RdE, Rs1D, Rs2D, stall, IF_flush);

	input MemReadE, Branch_is;
	input [4:0] RdE, Rs1D, Rs2D;
	input [31:0] InstrD;
	output stall, IF_flush;
	
	assign stall = (((MemReadE) & ((RdE == Rs1D) | (RdE == Rs2D)))) & (Branch_is);
	assign IF_flush = (Branch_is);
	
endmodule
