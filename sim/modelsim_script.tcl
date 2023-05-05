vlib work
vlog  ../src/*.sv
vsim -voptargs=+acc work.tf_resizer

add wave -position insertpoint  \
sim:/tf_resizer/clk \
sim:/tf_resizer/s_valid_i \
sim:/tf_resizer/s_last_i \
sim:/tf_resizer/s_keep_i \
sim:/tf_resizer/s_data_i \
sim:/tf_resizer/s_ready_o \
sim:/tf_resizer/m_valid_o \
sim:/tf_resizer/m_ready_i \
sim:/tf_resizer/m_last_o \
sim:/tf_resizer/m_keep_o \
sim:/tf_resizer/m_data_o

run -all
wave zoom full