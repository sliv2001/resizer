// без комментариев очень трудно читать и понимать исходный код
// не все комментарии могут быть точными, так как где-то я мог ошибиться в понимании конкретной логики, стоит учесть это
// почему реализация использует конвейер? почему нельзя сразу писать в буфер?
// не понял часть про "инвертировать биты keep этого же пакета; отправить" в pdf
// есть ли оценка пропускной способности полученного дизайна?
// есть ли результаты синтеза в ПЛИС?
//     - есть ли оценка частоты полученного дизайна? некоторые используемые конструкции выглядят достаточно нагруженными
// схема устройства в pdf — это визаулизированный top модуля (resizer.sv) и в целом это можно понять и из исходного кода; это не микроархитектурные диаграммы (в определенной степени точности)

module resizer #(
	parameter	S_KEEP_WIDTH = 3,
					T_DATA_WIDTH = 1,
					M_KEEP_WIDTH = 2,
					BUF_IN_ENTRY_SZ = (2 + T_DATA_WIDTH)* S_KEEP_WIDTH,
					BUF_OUT_ENTRY_SZ = (2 + T_DATA_WIDTH)* M_KEEP_WIDTH,
					MULTIPLIER=2
)(
	input clk,
	
	/*slave part*/
	input s_valid_i,
	input s_last_i,
	input [S_KEEP_WIDTH-1:0] s_keep_i,
	input [T_DATA_WIDTH-1:0] s_data_i [S_KEEP_WIDTH],
	output wire s_ready_o,
	
	/*master part*/
	output reg m_valid_o,
	input m_ready_i,
	output reg m_last_o,
	output reg [M_KEEP_WIDTH-1:0] m_keep_o,
	output reg [T_DATA_WIDTH-1:0] m_data_o [M_KEEP_WIDTH],
	
	/*debug part*/
	output overflow,
	output underflow,
	output slave_entry_valid,
	output [BUF_IN_ENTRY_SZ-1:0] slave_entry,
	output master_entry_ready,
	output [BUF_OUT_ENTRY_SZ-1:0] master_entry
);
/*
wire overflow;
wire underflow;
wire slave_entry_valid;
wire [BUF_IN_ENTRY_SZ-1:0] slave_entry;
wire master_entry_ready;
wire [BUF_OUT_ENTRY_SZ-1:0] master_entry;*/

slave #(.S_KEEP_WIDTH(S_KEEP_WIDTH), .T_DATA_WIDTH(T_DATA_WIDTH))
d0(
	.clk(clk),
	.s_valid_i(s_valid_i),
	.s_last_i(s_last_i),
	.s_keep_i(s_keep_i),
	.s_data_i(s_data_i),
	.s_ready_o(s_ready_o),
	.en(~overflow),
	.slave_entry_valid(slave_entry_valid),
	.slave_entry(slave_entry)
);

buffer #(.S_KEEP_WIDTH(S_KEEP_WIDTH), .T_DATA_WIDTH(T_DATA_WIDTH), .M_KEEP_WIDTH(M_KEEP_WIDTH))
d1(
	.clk(clk),
	.slave_entry_valid(slave_entry_valid),
	.slave_entry(slave_entry),
	.master_entry_ready(master_entry_ready),
	.master_entry(master_entry),
	.overflow(overflow),
	.underflow(underflow)
);

master #(.S_KEEP_WIDTH(S_KEEP_WIDTH), .T_DATA_WIDTH(T_DATA_WIDTH), .M_KEEP_WIDTH(M_KEEP_WIDTH))
d2(
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

endmodule
