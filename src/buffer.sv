// почему размер буфера пропорционален BUF_IN_ENTRY_SZ*BUF_OUT_ENTRY_SZ*?
//      а если размер данных будет, к примеру, 32 бита? в таком случае мы получим огромный буфер
//

module buffer #(
	parameter	S_KEEP_WIDTH = 3,
					T_DATA_WIDTH = 1,
					M_KEEP_WIDTH = 2,
					BUF_IN_ENTRY_SZ = (2 + T_DATA_WIDTH)* S_KEEP_WIDTH,
					BUF_OUT_ENTRY_SZ = (2 + T_DATA_WIDTH)* M_KEEP_WIDTH,
					MULTIPLIER=2
)(
	// а какой тип данных у входных значений?
	input clk,
	input slave_entry_valid, 
	input [BUF_IN_ENTRY_SZ-1:0] slave_entry,
	input master_entry_ready,
	output reg [BUF_OUT_ENTRY_SZ-1:0] master_entry,
	output reg overflow=0, // почему синтаксис (= ...) для выходного порта?
	output reg underflow=1
);

// почему регистры объявляются и сразу определяются через такой синтаксис (= ...)? как это соотносится с аппаратной реализацией (в железе)?  
reg underflowReg=1;
reg prevUnderflowReg=1;
reg [7:0] waddr=0, raddr=0; // ширина 8 бит — почему?
reg [7:0] n_waddr=0, n_raddr=0;
wire [BUF_OUT_ENTRY_SZ-1:0] dout;

reg [BUF_IN_ENTRY_SZ*BUF_OUT_ENTRY_SZ*2-1:0] storage=0; // MULTIPLIER?

always @*
begin
	
	n_waddr = waddr+BUF_IN_ENTRY_SZ;
	n_raddr = raddr+BUF_OUT_ENTRY_SZ;
	if (slave_entry_valid && !overflow)
	begin
		if (n_waddr>=BUF_IN_ENTRY_SZ*BUF_OUT_ENTRY_SZ*MULTIPLIER)
			n_waddr=0;
	end
	if (master_entry_ready && !underflowReg)
	begin
		if (n_raddr>=BUF_IN_ENTRY_SZ*BUF_OUT_ENTRY_SZ*MULTIPLIER)
			n_raddr=0;
	end
end

always @(posedge clk)
begin
	if (master_entry_ready)
		master_entry = storage[raddr+BUF_OUT_ENTRY_SZ-1 -: BUF_OUT_ENTRY_SZ];
	
	if (slave_entry_valid & ~overflow)
		storage[waddr+BUF_IN_ENTRY_SZ-1 -: BUF_IN_ENTRY_SZ] = slave_entry;
		
	if (slave_entry_valid && !overflow) // почему "!" (а выше "~")?
	begin
		underflowReg=0;
		if (n_raddr-n_waddr<=BUF_IN_ENTRY_SZ && waddr<raddr)
			overflow=1; // overflow использует в своей логики присванивания "!overflow" — петля зависимости?
	end
	if (master_entry_ready && !underflowReg)
	begin
		if (!(n_raddr-n_waddr<=BUF_IN_ENTRY_SZ && waddr<raddr))
			overflow=0;
		if (n_waddr-n_raddr<=BUF_OUT_ENTRY_SZ && waddr>=raddr && waddr!=0)
			underflowReg=1;
	end;
	

	if (!underflowReg)
	begin
		if (slave_entry_valid && !overflow)
			waddr<= (M_KEEP_WIDTH>=S_KEEP_WIDTH)? 0: n_waddr;
		if (master_entry_ready)
			raddr<=(waddr!=raddr)? n_raddr: 0;
	end
	else
	begin
		overflow=0; // у нас блок чувствительный на posedge clk, а здесь блокирующее присваивание
		underflowReg=1;
		waddr<=0;
		raddr<=0;
	end
	
	prevUnderflowReg<=underflowReg;
	
	underflow=M_KEEP_WIDTH>S_KEEP_WIDTH? 1: prevUnderflowReg||underflowReg;
end

initial begin
	$monitor("raddr %d; waddr %d", raddr, waddr);
end

endmodule
