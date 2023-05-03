module master#(
	parameter	S_KEEP_WIDTH = 3,
					T_DATA_WIDTH = 1,
					M_KEEP_WIDTH = 2,
					BUF_OUT_ENTRY_SZ = (2 + T_DATA_WIDTH)* M_KEEP_WIDTH
)(
	input clk,
	output m_valid_o,
	input m_ready_i,
	output m_last_o,
	output reg [M_KEEP_WIDTH-1:0] m_keep_o,
	output reg [T_DATA_WIDTH-1:0] m_data_o [M_KEEP_WIDTH],
	input underflow,
	output wire master_entry_ready,
	input [BUF_OUT_ENTRY_SZ-1:0] master_entry
);

reg prev_underflow=1;
reg last=0;
reg [M_KEEP_WIDTH-1:0] lasts=0, keep, keepResult;
reg repetitive=0;
integer i, j;

assign m_valid_o = !(underflow & prev_underflow);
assign master_entry_ready = m_ready_i & !repetitive;
assign m_last_o = lasts>0;

always @*
begin
	for (i=0; i<M_KEEP_WIDTH; i=i+1)
	begin
		lasts[i] = master_entry[i*(2 + T_DATA_WIDTH)+1];
		keep[i] = master_entry[i*(2 + T_DATA_WIDTH)];
	end
	
	if (repetitive)
		keepResult=(lasts-1)&keep;
	else 
		keepResult=(~(lasts-1))&keep;
		
	
end

always @(posedge clk)
begin
	if (repetitive==1)
		repetitive<=0;
		
	prev_underflow<=underflow;
	
	if (last)
	begin
		if (!underflow)
		begin
			repetitive<=1;
		end
	end
	for (j=0; j<M_KEEP_WIDTH; j=j+1)
	begin : genr 
		m_data_o[j] <= master_entry[j*(2 + T_DATA_WIDTH)+T_DATA_WIDTH -: T_DATA_WIDTH];
	end
	
	m_keep_o<=keepResult;
end

endmodule