vlib work 
vlog part3.sv
vsim -voptargs=+acc part3

log {/*}
add wave {/*}
add wave /part3/control/current_state
add wave /part3/control/next_state

#clock signal
force Clock 0, 1 1ns -r 2ns

#reset first
force Reset 1
force Go 0 
force Divisor 4'b0000
force Dividend 4'b0000
run 2ns
force Reset 0 
run 1ns

force Dividend 4'b0101
force Divisor 4'b0010
force Go 1, 0 2ns
run 100ns
