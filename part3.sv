module control_path(
    input logic Clock,
    input logic Reset, 
    input logic Go, 
    output logic AddIn, SubIn, ShiftIn, MvIn, LoadIn, done
); 

logic [1:0] iterations;

// control FSM states
typedef enum logic[2:0]
{
    C0 = 'd0,
    C1 = 'd1, 
    C2 = 'd2,
    C3 = 'd3, 
    C4 = 'd4, 
    C5 = 'd5
} statetype;

statetype current_state, next_state;

// control FSM state table
always_comb begin
    case(current_state)
        C0: next_state = Go? C1:C0;
        C1: next_state = C2;
        C2: next_state = C3;
        C3: next_state = C4;
        C4: next_state = C5;
        C5: next_state = done ? C0 : C1;
        default: next_state = C0;
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
    LoadIn = 1'b0;

    case(current_state)
        C0: LoadIn = Go;
        C1:
        begin
            LoadIn = 1'b0;
            ShiftIn = 1'b1;
        end 
        C2:
        begin
            SubIn = 1'b1;
            ShiftIn = 1'b0;
        end
        C3:
        begin
            AddIn = 1'b1;
            SubIn = 1'b0;
        end
        C4:
        begin
            MvIn = 1'b1;
            AddIn = 1'b0;
        end
        C5:
        begin
            done = (iterations == 2'd3);
        end
    endcase 
end

// control FSM FlipFlop
always_ff @(posedge Clock) begin
    if(Reset)
    begin
        iterations <= '0;
        current_state <= C0;
    end
    else
    begin
       current_state <= next_state;

       if (current_state == C0)
            iterations <= '0;
        else if (current_state == C5)
            iterations <= iterations + 1'b1;
    end
end
endmodule

module datapath(
    input logic Clock, 
    input logic Reset,
    input logic AddIn, SubIn, MvIn, ShiftIn, done, LoadIn,
    input logic [3:0] Divisor, Dividend,
    output logic [3:0] Quotient, Remainder,
    output logic ResultValid);

logic a4;
logic [4:0] RegA;
logic [3:0] divisor;
logic [4:0] SubTemp;
logic [3:0] dividend;

assign SubTemp = RegA - {1'b0, divisor};

always_ff @(posedge Clock) begin
    if (Reset) begin
        dividend <= '0;
        divisor <= '0;
        Quotient <= '0;
        Remainder <= '0;
        RegA <= '0;
        a4 <= '0;
        ResultValid <= 1'b0;
    end
    else begin
        if (LoadIn) begin
            dividend <= Dividend;
            divisor <= Divisor;
            RegA <= '0;
            a4 <= '0;
            ResultValid <= 1'b0;
        end

        if (ShiftIn) begin
            {RegA, dividend} <= {RegA, dividend} << 1;
        end

        if (SubIn) begin
            RegA <= SubTemp;
            a4 <= SubTemp[4];
        end

        if (AddIn && a4) begin
            RegA <= RegA + {1'b0, divisor};
        end

        if (MvIn) begin
            dividend[0] <= !a4;
        end

        if (done) begin
            Quotient <= dividend;
            Remainder <= RegA[3:0];
            ResultValid <= 1'b1;
        end
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

logic AddIn, SubIn, ShiftIn, MvIn, LoadIn, done;

control_path control(
   .Clock(Clock),
   .Reset(Reset), 
   .Go(Go), 
   .AddIn(AddIn), 
   .SubIn(SubIn), 
   .ShiftIn(ShiftIn), 
   .MvIn(MvIn), 
   .done(done),
   .LoadIn(LoadIn)
);

datapath data(
    .Clock(Clock),
    .Reset(Reset),
    .AddIn(AddIn),
    .SubIn(SubIn),
    .ShiftIn(ShiftIn),
    .MvIn(MvIn),
    .done(done),
    .LoadIn(LoadIn),
    .Divisor(Divisor),
    .Dividend(Dividend), 
    .Quotient(Quotient),
    .Remainder(Remainder),
    .ResultValid(ResultValid)
);

endmodule

