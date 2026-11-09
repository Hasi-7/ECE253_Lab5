vlib work 
vlog part1.sv
vsim -voptargs=+acc part1

log {/*}
add wave {/*}
radix signal sim:/part1/y_Q symbolic
radix signal sim:/part1/Y_D symbolic

#clock signal
force Clock 0, 1 5ns -r 10ns

#reset first
force Reset 1
run 10ns
force Reset 0

force w 1
run 10ns
# y_Q = B, Y_D = C, z = 0

force w 1
run 10ns
# y_Q = C, Y_D = D, z = 0

force w 1
run 10ns
# y_Q = D, Y_D = F, z = 0

force w 1
run 10ns
# y_Q = F, Y_D = F, z = 1

force -freeze y_Q C
force w 0
run 10ns
# y_Q = C, Y_D = E, z = 0

noforce y_Q
run 10ns
# y_Q = E, Y_D = A, z = 0

force w 1
run 10ns
# y_Q = G, Y_D = C, z = 1

force w 0
run 10ns
# y_Q = A, Y_D = A, z = 0

force Reset 0

force -freeze y_Q A
force w 0
run 10ns
# y_Q = A, Y_D = A, z = 0
force w 1
run 10ns
# y_Q = A, Y_D = B, z = 0

force -freeze y_Q B
force w 0
run 10ns
# y_Q = B, Y_D = A, z = 0
force w 1
run 10ns
# y_Q = B, Y_D = C, z = 0

force -freeze y_Q C
force w 0
run 10ns
# y_Q = C, Y_D = E, z = 0
force w 1
run 10ns
# y_Q = C, Y_D = D, z = 0

force -freeze y_Q D
force w 0
run 10ns
# y_Q = D, Y_D = E, z = 0
force w 1
run 10ns
# y_Q = D, Y_D = F, z = 0

force -freeze y_Q E
force w 0
run 10ns
# y_Q = E, Y_D = A, z = 0
force w 1
run 10ns
# y_Q = E, Y_D = G, z = 0

force -freeze y_Q F
force w 0
run 10ns
# y_Q = F, Y_D = E, z = 1
force w 1
run 10ns
# y_Q = F, Y_D = F, z = 1

force -freeze y_Q G
force w 0
run 10ns
# y_Q = G, Y_D = A, z = 1
force w 1
run 10ns
# y_Q = G, Y_D = C, z = 1

