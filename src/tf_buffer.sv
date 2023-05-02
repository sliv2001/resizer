`timescale 1 ns / 100 ps

module tf_buffer;

parameter	S_KEEP_WIDTH = 3, T_DATA_WIDTH = 1,	BUF_IN_ENTRY_SZ = (2 + T_DATA_WIDTH)* S_KEEP_WIDTH;
parameter	M_KEEP_WIDTH = 2;
parameter	BUF_OUT_ENTRY_SZ = (2 + T_DATA_WIDTH)* M_KEEP_WIDTH;

reg clk=0, slave_entry_valid=0, master_entry_ready=0;
reg [BUF_IN_ENTRY_SZ-1:0] slave_entry=0;
wire [BUF_OUT_ENTRY_SZ-1:0] master_entry;
wire overflow, underflow;

buffer uut(
	.clk(clk),
	.slave_entry_valid(slave_entry_valid),
	.master_entry_ready(master_entry_ready),
	.slave_entry(slave_entry),
	.master_entry(master_entry),
	.overflow(overflow),
	.underflow(underflow)
);

always
begin
	clk=~clk;
	#2;
end

initial
begin
	#99;
	slave_entry_valid=1;
	master_entry_ready=1;
	slave_entry=9'b101100111;
end

endmodule