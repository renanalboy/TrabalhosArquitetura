vlib work
vmap work work
vlog *.sv
vlog *.v
vsim testbench

#add wave -radix hexadecimal sim:/testbench/dut/vd/*
add wave -radix hexadecimal sim:/testbench/dut/mips/*
#add wave -radix hexadecimal sim:/testbench/dut/mips/c/*
#add wave -radix hexadecimal sim:/testbench/dut/mips/c/md/*
add wave -radix hexadecimal sim:/testbench/dut/mips/dp/*
#add wave -radix hexadecimal sim:/testbench/dut/mem/RAM
#add wave -radix hexadecimal sim:/testbench/dut/mips/dp/rf/*
#add wave -radix hexadecimal sim:/testbench/dut/mips/dp/rf/rf


run 1000 ns