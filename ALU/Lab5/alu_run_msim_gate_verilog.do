transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {alu.vo}

vlog -sv -work work +incdir+C:/altera/13.0sp1/../../Users/Win7/Desktop/Lab5 {C:/altera/13.0sp1/../../Users/Win7/Desktop/Lab5/talu.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L cycloneii_ver -L gate_work -L work -voptargs="+acc"  talu

add wave *
view structure
view signals
run -all
