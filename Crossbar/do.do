vlib work
vmap work
vlog *.v
vsim work.t_swap
add wave sim:/t_swap/dut/w
add wave sim:/t_swap/dut/Resetn
add wave sim:/t_swap/dut/Clock
add wave sim:/t_swap/dut/RinExt
add wave sim:/t_swap/dut/Extern
add wave -radix hexadecimal sim:/t_swap/dut/Data 
add wave -radix hexadecimal sim:/t_swap/dut/R1
add wave -radix hexadecimal sim:/t_swap/dut/R2
add wave -radix hexadecimal sim:/t_swap/dut/R3
add wave -radix hexadecimal sim:/t_swap/dut/R4
add wave sim:/t_swap/dut/control/S

run 600 ns
wave zoom full