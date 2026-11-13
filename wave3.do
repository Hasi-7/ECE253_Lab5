vlib work 
vlog part3.sv
vsim -voptargs=+acc part3

log {/*}
add wave {/*}

#clock signal
force Clock 0, 1 1ns -r 2ns

#reset first
force Reset 1
force Go 0 
force Divisor 4'0000
force Dividend 4'0000
run 2ns
force reset 0 
run 1ns

force Dividend 4'0100
force Divisor 4'0010
force Go 1, 0 2ns
run 4ns