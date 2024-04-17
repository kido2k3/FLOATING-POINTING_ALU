// the top module
`define INPUT_WIDTH 32
module FP_ALU_SYN (
    output reg [`INPUT_WIDTH - 1 : 0] out,
    output reg under_overflow,
    output reg zero,
    input [`INPUT_WIDTH - 1 : 0] para1,
    input [`INPUT_WIDTH - 1 : 0] para2,
    input [1:0] ALU_op, 
    input clk
);
// initialize variables
reg [`INPUT_WIDTH - 1 : 0] out_ff;
reg under_overflow_ff, zero_ff;
reg [`INPUT_WIDTH - 1 : 0] para1_ff;
reg [`INPUT_WIDTH - 1 : 0] para2_ff;
reg [1:0] ALU_op_ff;

wire [`INPUT_WIDTH - 1 : 0] add_result, multi_result, sub_result;
wire add_under_overflow, multi_under_overflow, sub_under_overflow;

always @(posedge clk) begin
    para1_ff <= para1;
    para2_ff <= para2;
    ALU_op_ff <= ALU_op;
end


AddOp add (.out(add_result), .under_overflow(add_under_overflow), .para1(para1_ff), .para2(para2_ff));
MultiOp multi (.out(multi_result), .under_overflow(multi_under_overflow), .para1(para1_ff), .para2(para2_ff));
SubOp sub (.out(sub_result), .under_overflow(sub_under_overflow), .para1(para1_ff), .para2(para2_ff));

// see more details in specification
always @(add_result, multi_result, sub_result, ALU_op_ff) begin
    case (ALU_op_ff)
        2'b00: begin
            out_ff = add_result;
            under_overflow_ff = add_under_overflow;
        end
        2'b01: begin
            out_ff = sub_result;
            under_overflow_ff = sub_under_overflow;
        end
        2'b10: begin
            out_ff = multi_result;
            under_overflow_ff = multi_under_overflow;
        end
        default: begin
            out_ff = 32'd0;
            under_overflow_ff = 1'b0;
        end
    endcase
    zero_ff = ~|out_ff;
end

always @(posedge clk) begin
    out <= out_ff;
    zero <= zero_ff;
    under_overflow <= under_overflow_ff;
end

endmodule