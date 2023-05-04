module tf_master();

parameter	M_KEEP_WIDTH=2, T_DATA_WIDTH=1,
				BUF_OUT_ENTRY_SZ = (2 + T_DATA_WIDTH)* M_KEEP_WIDTH;

reg clk=0;
wire m_valid_o;
reg m_ready_i=0;
wire m_last_o;
wire [M_KEEP_WIDTH-1:0] m_keep_o;
wire [T_DATA_WIDTH-1:0] m_data_o[M_KEEP_WIDTH];
reg underflow=1;
wire master_entry_ready;
reg [BUF_OUT_ENTRY_SZ-1:0] master_entry;

master uut(
	.clk(clk),
	.m_valid_o(m_valid_o),
	.m_ready_i(m_ready_i),
	.m_last_o(m_last_o),
	.m_keep_o(m_keep_o),
	.m_data_o(m_data_o),
	.underflow(underflow),
	.master_entry_ready(master_entry_ready),
	.master_entry(master_entry)
);

always
begin
	clk=~clk;
	#2;
end

initial
begin
	#99;
	m_ready_i=1;
	underflow=0;
	master_entry=6'b101100;
	#4;
	underflow=1;
	master_entry=6'b110000;
	#8;
	underflow=0;
	master_entry=6'b101101;
	#4;
	master_entry=6'b011001;
	#4;
	underflow=1;
end

endmodule