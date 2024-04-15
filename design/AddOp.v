// Addition operators between two floating-point numbers
`define INPUT_WIDTH 32
module AddOp (
    output reg [`INPUT_WIDTH - 1 : 0] out,
    output reg under_overflow,
    input [`INPUT_WIDTH - 1 : 0] para1,
    input [`INPUT_WIDTH - 1 : 0] para2
);
//parameters
localparam E_WIDTH = 8;         // The width of exponent parts
localparam F_WIDTH = 23;        // The width of fraction parts

// initialize variables
reg [`INPUT_WIDTH - 1 : 0] op1;  // the abs(op1) must be greater or equal than abs(op2)
reg [`INPUT_WIDTH - 1 : 0] op2;

reg [F_WIDTH : 0] S_op1; // the significand of op 24 bits
reg [F_WIDTH : 0] S_op2; 
reg [E_WIDTH - 1 : 0] E_op1; // the exponent of op 
reg [E_WIDTH - 1 : 0] E_op2;  
                                // sign of 2 op is the MSB bit
// variables for calculation
reg operator;       // 0: add (if signs of parameters are alike); 1: sub (if signs of parameters are different)
reg [F_WIDTH : 0] S_shifted_op2; 
wire [F_WIDTH + 1 : 0] ALU_result; // 25-bit result 
reg [F_WIDTH + 1 : 0] ALU_pos_result; // 25-bit positive result
wire [F_WIDTH - 1 : 0] normalized_result; // 23-bit normalized result
wire [4 : 0] shift_times;

reg add_with_zero;
reg is_result_zero;
// output
reg S_out; 
reg [E_WIDTH - 1 : 0] E_out; 
reg [F_WIDTH - 1 : 0] F_out;

//  determine op
always @(para1 or para2) begin
    operator = para1[`INPUT_WIDTH - 1] ^ para2[`INPUT_WIDTH - 1];

    {op1, op2} = (para1[`INPUT_WIDTH - 2 : 0] >= para2[`INPUT_WIDTH - 2 : 0])
                ? {para1, para2}
                : {para2, para1}; // compare 2 parameters without sign
    is_result_zero = (para1[`INPUT_WIDTH - 2 : 0] == para2[`INPUT_WIDTH - 2 : 0]) 
                    && (para1[`INPUT_WIDTH - 1] != para2[`INPUT_WIDTH - 1]);
    add_with_zero = ~|para1 | ~|para2;
end
//  separate op into sub-parts
always @(op1, op2) begin
    // 32-bit floating-point number format
    // sign     | exponent  | fraction
    // 1 bit    | 8 bits    | 23 bits
    //MSB                           LSB
    // the 24-bit significand is leading 1 bit fraction
    S_op1 = {1'b1, op1[F_WIDTH - 1 : 0]};
    S_op2 = {1'b1, op2[F_WIDTH - 1 : 0]};
    E_op1 = op1[`INPUT_WIDTH - 2 : F_WIDTH];
    E_op2 = op2[`INPUT_WIDTH - 2 : F_WIDTH];
end
// right shift the significand of lower number with the exponent differential 
// round if any
always @(E_op1, E_op2, S_op2) begin
    if(E_op1 - E_op2 != 1'b0) S_shifted_op2 =  (S_op2 >> (E_op1 - E_op2)) + S_op2[(E_op1 - E_op2) - 1]; 
    else S_shifted_op2 = S_op2;
end 

BigALU ALU(.out(ALU_result), .op1(S_op1), .op2(S_shifted_op2), .operator(operator));
// if alu is negative then 
always @(ALU_result) begin
    if(ALU_result[F_WIDTH + 1] == 1'b0) begin
        // negative ALU value
         ALU_pos_result = ~ALU_result + 1'b1;
    end
    else begin
        // positive ALU value
        ALU_pos_result = ALU_result;
    end
end
NormalizedDecoder normalized_decoder(.result(normalized_result), .shift_times(shift_times), .in(ALU_pos_result));

always @(*) begin
    S_out = op1[`INPUT_WIDTH - 1];
    if (is_result_zero) begin
        under_overflow = 0;
        {S_out, E_out, F_out} = 32'd0;
    end
    else if (add_with_zero) begin
        under_overflow = 0;
        S_out = op1[`INPUT_WIDTH - 1] | op2[`INPUT_WIDTH - 1];
        E_out = E_op1 | E_op2;
        F_out = op1[F_WIDTH - 1 : 0] | op2[F_WIDTH - 1 : 0];
    end
    else if (operator == 1'b0 && ALU_result[F_WIDTH + 1]) begin
        // add operator, need to normalize
        E_out = E_op1 + 1'b1;
        under_overflow = (E_out == 8'd255);
        F_out = (under_overflow) ? 23'd0 : ALU_result[F_WIDTH : 1] + ALU_result[0];
    end
    else if (operator == 1'b0) begin
        // add operator, not normalize
        E_out = E_op1;
        under_overflow = 0;
        F_out = ALU_result[F_WIDTH - 1 : 0];
    end
    else if(operator == 1'b1) begin
        // sub operator
        E_out = (E_op1 > shift_times) ? E_op1 - shift_times : 8'hff;
        under_overflow = ~(E_op1 > shift_times);
        F_out = (under_overflow) ? 23'd0 : normalized_result;
    end
    
end
always @(S_out, E_out, F_out) begin
    out = {S_out, E_out, F_out};
end
endmodule   