vlib work
vmap work work
vlog *.sv
vsim testbench
add wave -radix hexadecimal sim:/testbench/dut/*
add wave -radix hexadecimal sim:/testbench/dut/mips/c/md/*
run -a