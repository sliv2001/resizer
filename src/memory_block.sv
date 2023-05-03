module memory_block # (
	parameter	S_KEEP_WIDTH = 3,
					T_DATA_WIDTH = 1,
					M_KEEP_WIDTH = 2,
					BUF_IN_ENTRY_SZ = (2 + T_DATA_WIDTH)* S_KEEP_WIDTH,
					BUF_OUT_ENTRY_SZ = (2 + T_DATA_WIDTH)* M_KEEP_WIDTH,
					MULTIPLIER=6
)(
	output [BUF_OUT_ENTRY_SZ-1:0] dout, 
	input [BUF_IN_ENTRY_SZ-1:0] din, 
	input clk,
	input en, 
	input [MULTIPLIER-1:0] wptr,
	input [MULTIPLIER-1:0] rptr);  
	
reg [BUF_IN_ENTRY_SZ*BUF_OUT_ENTRY_SZ*2-1:0] storage=0;

assign dout = storage[rptr+BUF_OUT_ENTRY_SZ-1 -: BUF_OUT_ENTRY_SZ];

always @(posedge clk)  
begin  
	if(en)   
		storage[wptr+BUF_IN_ENTRY_SZ-1 -: BUF_IN_ENTRY_SZ] = din;  
	end  

endmodule  