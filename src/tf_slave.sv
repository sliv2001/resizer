`timescale 1 ns / 100 ps

module tf_slave;

parameter	S_KEEP_WIDTH = 3, T_DATA_WIDTH = 1,	BUF_IN_ENTRY_SZ = (2 + T_DATA_WIDTH)* S_KEEP_WIDTH;

reg clk=0, s_valid_i=0, s_last_i=0;
reg [S_KEEP_WIDTH-1:0] s_keep_i=0;
reg [T_DATA_WIDTH-1:0] s_data_i [S_KEEP_WIDTH];
wire s_ready_o;
reg en=1;
wire slave_entry_valid;
wire [BUF_IN_ENTRY_SZ-1:0] slave_entry;

slave uut(
	.clk(clk),
	.s_valid_i(s_valid_i),
	.s_last_i(s_last_i),
	.s_keep_i(s_keep_i),
	.s_data_i(s_data_i),
	.s_ready_o(s_ready_o),
	.en(en),
	.slave_entry_valid(slave_entry_valid),
	.slave_entry(slave_entry)
);

always
begin
	clk=~clk;
	#2;
end

initial
begin
	#100;
	s_valid_i=1;
	s_keep_i=3'b111;
	s_data_i[0]=1;
	s_data_i[1]=0;
	s_data_i[2]=1;
end

endmodule