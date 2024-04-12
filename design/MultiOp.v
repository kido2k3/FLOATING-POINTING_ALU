// Multiplication operators between two floating-point numbers
`define INPUT_WIDTH 32  // The width of input (32 or 64 bits)
module MultiOp(
    output reg [`INPUT_WIDTH - 1 : 0] out,
    output reg under_overflow,
    input [`INPUT_WIDTH - 1 : 0] para1,
    input [`INPUT_WIDTH - 1 : 0] para2
);
    
localparam E_WIDTH = 8;         // The width of exponent parts
localparam F_WIDTH = 23;        // The width of fraction parts
localparam E_BIAS = 127;        // The bias of exponent parts
localparam MULTI_WIDTH = (F_WIDTH + 1) * 2; // The width of significand multiplication
// initialize variables
reg [F_WIDTH : 0] S_para1; // the significand of parameters 24 bits
reg [F_WIDTH : 0] S_para2; 
reg [E_WIDTH - 1 : 0] E_para1; // the exponent of parameters 
reg [E_WIDTH - 1 : 0] E_para2;  
                                // sign of 2 parameters is the MSB bit
//variables for fraction calculation
reg [MULTI_WIDTH - 1 : 0] multi_res; // result of significand multiplication
reg [F_WIDTH + 1 : 0] handled_multi_res; // result after removing redundant parts and rounding
reg is_normalized;
//variables for exponent calculation
reg [E_WIDTH : 0] add_res; // result of exponent addition
//output
reg [F_WIDTH - 1 : 0] F_out; // the fraction of output
reg [E_WIDTH - 1 : 0] E_out; // the exponent of output 
reg S_out;                   // the sign of output
reg overflow;
reg underflow;
//  separate parameters into sub-parts
always @(para1 or para2) begin
    // 32-bit floating-point number format
    // sign     | exponent  | fraction
    // 1 bit    | 8 bits    | 23 bits
    //MSB                           LSB
    // the 24-bit significand is leading 1 bit fraction
    S_para1 = {1'b1, para1[F_WIDTH - 1 : 0]};
    S_para2 = {1'b1, para2[F_WIDTH - 1 : 0]};
    E_para1 = para1[`INPUT_WIDTH - 2 : F_WIDTH];
    E_para2 = para2[`INPUT_WIDTH - 2 : F_WIDTH];
end
// multiply and normalize significand elements
always @(S_para1 or S_para2) begin
    multi_res = S_para1 * S_para2;
    // remove redundant part and round result
    // handled part | redundant part
    // 25 bits      | 23 bits
    // if MSB in redundant part is 1, handled part will be rounded
    handled_multi_res = multi_res[MULTI_WIDTH - 1 : F_WIDTH] + multi_res[F_WIDTH - 1];

    // if MSB of handled part is 1, need to normalize
    if (handled_multi_res[F_WIDTH + 1] == 1'b1) begin
        // normalizing and rounding case
        is_normalized = 1'b1;
        F_out = handled_multi_res[F_WIDTH : 1] + handled_multi_res[0];
    end 
    else begin
        // not normalizing case
        is_normalized = 1'b0;
        F_out = handled_multi_res[F_WIDTH - 1 : 0];
    end
end
//-------------------------------------------
// calculate exponent
always @(E_para1, E_para2, is_normalized) begin
    add_res = E_para1 + E_para2 + is_normalized;
    overflow = 1'b0;
    underflow = 1'b0;
    E_out = 8'd0;
    if (add_res >= 9'd255 + E_BIAS) begin
        // overflow case
        overflow = 1'b1;
    end
    else if (add_res >= E_BIAS) begin
        // normal case
        E_out = add_res - E_BIAS;
    end
    else begin
        // underflow case
        underflow = 1'b1;
    end
    
end
//--------------------------------------------
// determine the sign part 
always @(para1, para2) begin
    S_out = para1[`INPUT_WIDTH - 1] ^ para2[`INPUT_WIDTH - 1];
end
//--------------------------------------------
always @(underflow, overflow, S_out, E_out, F_out) begin
    under_overflow = underflow | overflow;
    if (underflow == 1'b1) begin
        // underflow case:
        out = 32'hff800000;
    end
    else if (overflow == 1'b1) begin
        out = 32'h7f800000;
    end
    else begin
        out = {S_out, E_out, F_out};
    end
end
endmodule