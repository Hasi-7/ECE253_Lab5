module control_path(
    input logic Clock,
    input logic Reset, 
    input logic Go, 
    output logic AddIn, SubIn, ShiftIn, MvIn, done
); 

// control FSM states
typedef enum logic[1:0]
{
    C0 = 'd0,
    C1 = 'd1, 
    C2 = 'd2, 
    C3 = 'd3
} statetype;

statetype current_state, next_state;

// control FSM state table
always_comb begin
    case(current_state)
        C0: next_state = Go? C1:C0;
        C1: next_state = done? C0:C2;
        C2: next_state = C3;
        C3: next_state = C0;
    endcase
end

// output logic i.e: datapath control signals
always_comb begin
    // by default, make all our signals 0
    AddIn = 1'b0;
    SubIn = 1'b0; 
    ShiftIn = 1'b0;
    MvIn = 1'b0;
    done = 1'b0;

    case(current_state)
        C0:
        begin
            Go = 1'b1;
            ShiftIn = 1'b1;
        end
        C1:
        begin
            SubIn = 1'b1;
            ShiftIn = 1'b0;
        end 
        C2:
        begin
            AddIn = 1'b1;
            SubIn = 1'b0;
        end
        C3:
        begin
            MvIn = 1'b1;
            AddIn = 1'b0;
            done = 1'b1;
        end
    endcase 
end

// control FSM FlipFlop
always_ff @(posedge clk) begin
    if(reset)
        current_state <= C0;
    else
       current_state <= next_state;
end
endmodule

module datapath(
    input logic Clock, 
    input logic Reset,
    input logic AddIn, SubIn, MvIn, ShiftIn, done,
    input logic [3:0] Divisor, Dividend,
    output logic [3:0] Quotient, Remainder
    output logic []
);

logic a4;
logic [7:0] ShiftTemp;

always_comb
begin
    if (Divisor == 4'b0) ResultValid = 0;
    else ResultValid = 1; 
end

always_ff @(posedge clk) begin
    if(reset)
    begin
        Divisor <= 4'b0;
        Dividend <= 4'b0;
        Quotient <= 4'b0;
        Remainder <= 4'b0;
    end
    else
    begin
        if(ShiftIn) 
        begin
            ShiftTemp <= {Remainder, Dividend} << 1;
            Remainder <= ShiftTemp[7:4];
            Dividend <= ShiftTemp[3:0];
        end
        if(SubIn) 
        begin
            Remainder = Remainder - Divisor;
            a4 = Remainder[3];
        end
        if(AddIn) Remainder = Remainder + Divisor;
        if(MvIn) Dividend[0] = a4;
    end
end
endmodule

module part3(
input logic Clock,
input logic Reset,
input logic Go,
input logic [3:0] Divisor,
input logic [3:0] Dividend,
output logic [3:0] Quotient,
output logic [3:0] Remainder,
output logic ResultValid
);

logic AddIn, SubIn, ShiftIn, MvIn, done;

control_path control(
   .Clock(Clock)
   .Reset(Reset), 
   .Go(Go), 
   .AddIn(AddIn), 
   .SubIn(SubIn), 
   .ShiftIn(ShiftIn), 
   .MvIn(MvIn), 
   .done(done)
);

datapath data(
    .Clock(Clock)
    .Reset(Reset),
    .Go(Go),
    .AddIn(AddIn),
    .SubIn(SubIn),
    .ShiftIn(ShiftIn),
    .MvIn(MvIn),
    .done(done),
    .Divisor(Divisor),
    .Dividend(Dividend) 
    .Quotient(Quotient),
    .Remainder(Remainder),
    .r(r_out)
);

endmodule

