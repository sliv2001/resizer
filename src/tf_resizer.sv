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

logic reset=1;
int vect=0;

/*Test data*/
localparam TEST_LEN = 3+S_KEEP_WIDTH*(1+T_DATA_WIDTH)  +  3+M_KEEP_WIDTH*(1+T_DATA_WIDTH)+1;
logic [TEST_LEN-1:0] tv [0:1000];

reg m_valid_o_exp;
reg m_last_o_exp;
reg s_ready_o_exp;
reg [M_KEEP_WIDTH-1:0] m_keep_o_exp;
reg [T_DATA_WIDTH-1:0] m_data_o_exp [M_KEEP_WIDTH];
reg care=1;

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
	$readmemb("../test/normal.tv", tv);
	#11;
	reset=0;
end

always @(negedge clk)
begin

	if (!reset)
	begin

		{care, s_valid_i, s_last_i, s_keep_i, s_data_i[0], s_data_i[1], s_data_i[2],
			m_ready_i, s_ready_o_exp, m_valid_o_exp, m_last_o_exp, 
			m_keep_o_exp, m_data_o_exp[0], m_data_o_exp[1]} = tv[vect];

		#1;
		
		if (care &&
			s_ready_o != s_ready_o_exp ||
			m_valid_o != m_valid_o_exp ||
			m_last_o != m_last_o_exp	||
			m_keep_o != m_keep_o_exp	||
			m_data_o != m_data_o_exp)
		begin
			$error("Error at time %0t", $time);
		end
		vect = vect+1;
		if (tv[vect] === {TEST_LEN'('bx)}) 
		begin
			$display("%3d tests completed", vect);
			$stop;
		end
	end
end

endmodule