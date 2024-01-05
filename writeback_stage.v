
module writeback_stage(MemOutW, MemToRegW, ResultW, ALUResult_W);
	
	input MemToRegW;
	input [31:0] ALUResult_W, MemOutW;
	
	output [31:0] ResultW;
	
	assign ResultW = (MemToRegW) ? (MemOutW) : ALUResult_W;
	
endmodule





