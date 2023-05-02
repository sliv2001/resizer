module slave #(
	parameter	S_KEEP_WIDTH = 3,
					T_DATA_WIDTH = 1,
					BUF_IN_ENTRY_SZ = (2 + T_DATA_WIDTH)* S_KEEP_WIDTH
)(
	input clk,
	input s_valid_i,
	input s_last_i,
	input [S_KEEP_WIDTH-1:0] s_keep_i,
	input [T_DATA_WIDTH-1:0] s_data_i [S_KEEP_WIDTH],
	output wire s_ready_o,
	input en,
	output reg slave_entry_valid,
	output reg [BUF_IN_ENTRY_SZ-1:0] slave_entry
	
);

assign s_ready_o = en;

reg [BUF_IN_ENTRY_SZ-1:0] packet;

genvar i;
generate
for (i=0; i<S_KEEP_WIDTH; i=i+1)
begin : gen
	always @*
	begin
		packet[i*(2 + T_DATA_WIDTH)]=s_keep_i[i];
		if (i==S_KEEP_WIDTH-1 && s_last_i==1)
			packet[i*(2 + T_DATA_WIDTH)+1]=1;
		else
			packet[i*(2 + T_DATA_WIDTH)+1]=0;
		packet[i*(2 + T_DATA_WIDTH)+1+T_DATA_WIDTH:i*(2 + T_DATA_WIDTH)+2]=s_data_i[i];
	end 
end
endgenerate

always @(posedge clk)
begin
	slave_entry_valid <= s_valid_i;
	slave_entry <= packet;
end

endmodule