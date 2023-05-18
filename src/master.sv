module master#(
	parameter	S_KEEP_WIDTH = 3,
					T_DATA_WIDTH = 1,
					M_KEEP_WIDTH = 2,
					BUF_OUT_ENTRY_SZ = (2 + T_DATA_WIDTH)* M_KEEP_WIDTH
)(
	input clk,
	output reg m_valid_o,
	input m_ready_i,
	output reg m_last_o,
	output reg [M_KEEP_WIDTH-1:0] m_keep_o,
	output reg [T_DATA_WIDTH-1:0] m_data_o [M_KEEP_WIDTH],
	input underflow,
	output wire master_entry_ready,
	input [BUF_OUT_ENTRY_SZ-1:0] master_entry
);

reg prev_underflow=1;
reg [M_KEEP_WIDTH-1:0] lasts=0, keep, keepResult, prevKeepResult;
reg repetitive=0;
integer i, j;

assign master_entry_ready = m_ready_i & !repetitive;

always @*
begin
	for (i=0; i<M_KEEP_WIDTH; i=i+1)
	begin
		lasts[i] = master_entry[i*(2 + T_DATA_WIDTH)+1];
		keep[i] = master_entry[i*(2 + T_DATA_WIDTH)];
	end
	
	if (lasts!=0) // может быть несколько lasts в одном такте? нельзя улучшить данную подсхему сравнения?
	begin
		if (repetitive)
			keepResult= ~prevKeepResult;
		else 
			keepResult=((lasts-1)|lasts)&keep;
	end
	else
		keepResult=keep;
	
end

always @(negedge clk) //Quite unreliable
begin
	if (repetitive==1)
		repetitive<=0;
		
	prev_underflow<=underflow;
	
	if (lasts!=0  && lasts[M_KEEP_WIDTH-1]==0)
	begin
		if (!underflow && !repetitive)
		begin
			repetitive<=1; // а если "repetitive==1" и "lasts!=0  && lasts[M_KEEP_WIDTH-1]==0" ветки сработают в один такт? что будет писаться в repetitive? я вижу, что во второй ветке в логике есть "!repetitive", но это неявное понимание перекладывается на плечи умного(!) компилятора/синтезатора
		end
	end
	for (j=0; j<M_KEEP_WIDTH; j=j+1) // не генвар (многие тулы смогут разобраться, но не все)
	begin : genr 
		m_data_o[j] <= master_entry[j*(2 + T_DATA_WIDTH)+1+T_DATA_WIDTH -: T_DATA_WIDTH]; // точно по выборке битов правильно? 
	end
	
	m_keep_o<=keepResult;
	m_valid_o <= !(underflow & prev_underflow) & keepResult!=0;
	m_last_o <= repetitive?0:lasts>0;
	prevKeepResult<=keepResult;
end

endmodule
