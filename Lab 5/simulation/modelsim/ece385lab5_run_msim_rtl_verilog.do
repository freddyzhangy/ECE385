transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy {C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy/adder.sv}
vlog -sv -work work +incdir+C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy {C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy/shiftreg.sv}
vlog -sv -work work +incdir+C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy {C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy/control.sv}
vlog -sv -work work +incdir+C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy {C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy {C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy/synchronizer.sv}
vlog -sv -work work +incdir+C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy {C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy/multiplier.sv}
vlog -sv -work work +incdir+C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy {C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy/lab5_toplevel.sv}

vlog -sv -work work +incdir+C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy {C:/Users/FZ/Downloads/ECE-385-Freddy/ECE-385-Freddy/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
