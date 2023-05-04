module tf_resizer;

parameter	S_KEEP_WIDTH = 3,
				T_DATA_WIDTH = 4,
				M_KEEP_WIDTH = 2,
				BUF_IN_ENTRY_SZ = (2 + T_DATA_WIDTH)* S_KEEP_WIDTH,
				BUF_OUT_ENTRY_SZ = (2 + T_DATA_WIDTH)* M_KEEP_WIDTH,
				MULTIPLIER=2;

reg clk=0;

/*slave part*/
reg s_valid_i=0;
reg s_last_i=0;
reg [S_KEEP_WIDTH-1:0] s_keep_i=0;
reg [T_DATA_WIDTH-1:0] s_data_i [S_KEEP_WIDTH];
wire s_ready_o;
	
/*master part*/
wire m_valid_o;
reg m_ready_i=1;
wire m_last_o;
wire [M_KEEP_WIDTH-1:0] m_keep_o;
wire [T_DATA_WIDTH-1:0] m_data_o [M_KEEP_WIDTH];

/*debug part*/
wire overflow;
wire underflow;
wire slave_entry_valid;
wire [BUF_IN_ENTRY_SZ-1:0] slave_entry;
wire master_entry_ready;
wire [BUF_OUT_ENTRY_SZ-1:0] master_entry;

resizer #(.S_KEEP_WIDTH(S_KEEP_WIDTH), .T_DATA_WIDTH(T_DATA_WIDTH), .M_KEEP_WIDTH(M_KEEP_WIDTH))
rs(
	.clk(clk),
	.s_valid_i(s_valid_i),
	.s_last_i(s_last_i),
	.s_keep_i(s_keep_i),
	.s_data_i(s_data_i),
	.s_ready_o(s_ready_o),
	.m_valid_o(m_valid_o),
	.m_ready_i(m_ready_i),
	.m_last_o(m_last_o),
	.m_keep_o(m_keep_o),
	.m_data_o(m_data_o),
	.overflow(overflow),
	.underflow(underflow),
	.slave_entry_valid(slave_entry_valid),
	.slave_entry(slave_entry),
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
	s_valid_i=1;
	s_last_i=0;
	s_keep_i=3'b111;
	s_data_i[0]=1;
	s_data_i[1]=0;
	s_data_i[2]=1;
	#4;
	s_valid_i=0;
	#16;
	s_data_i[0]=1;
	s_data_i[1]=2;
	s_data_i[2]=3;
	s_valid_i=1;
	#4;
	s_data_i[0]=4;
	s_data_i[1]=5;
	s_data_i[2]=6;
	#4;
	s_data_i[0]=7;
	s_data_i[1]=8;
	s_data_i[2]=9;
	#4;
	s_data_i[0]=10;
	s_data_i[1]=11;
	s_data_i[2]=12;
	s_last_i=1;
	#4;
	s_valid_i=0;
end

endmodule