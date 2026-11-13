# Datapath correction context

- Scope: apply the discussed fixes to [[part2.sv]] without changing other existing work.
- Problem: registered mux/ALU introduce extra cycles, the immediate is cleared when disabled, and the result register never loads.
- Changes: combinational mux and ALU; independently enabled registers; sign-extended 12-bit immediate; assert move completion in C1.
- Preserve: module interfaces, instruction encoding, existing arithmetic FSM timing, and simulation scripts.
- Validation: compile and run the existing `wave-1.do` if a simulator is available. Expected sequence: r0 = 8, then 16; r1 = 16'hFFF0.
- Constraint: external INSTRin must remain stable while executing because the controller decodes it directly.
