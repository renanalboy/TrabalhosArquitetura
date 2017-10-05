vlib work
vmap work work
vlog *.sv
vsim testbench
add wave -radix hexadecimal sim:/testbench/dut/*
add wave sim:/testbench/dut/mips/c/md/*
add wave sim:/testbench/dut/mips/dp/jr
add wave sim:/testbench/dut/mips/dp/result
add wave sim:/testbench/dut/mips/dp/writereg
add wave sim:/testbench/dut/mips/dp/pcnext

run 600ps
