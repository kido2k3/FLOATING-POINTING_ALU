// the top module
`define INPUT_WIDTH 32
module FP_ALU (
    output reg [`INPUT_WIDTH - 1 : 0] out,
    output reg under_overflow,
    output reg zero,
    input [`INPUT_WIDTH - 1 : 0] para1,
    input [`INPUT_WIDTH - 1 : 0] para2,
    input [1:0] ALU_op
);
// initialize variables
wire [`INPUT_WIDTH - 1 : 0] add_result, multi_result, sub_result;
wire add_under_overflow, multi_under_overflow, sub_under_overflow;

AddOp add (.out(add_result), .under_overflow(add_under_overflow), .para1(para1), .para2(para2));
MultiOp multi (.out(multi_result), .under_overflow(multi_under_overflow), .para1(para1), .para2(para2));
SubOp sub (.out(sub_result), .under_overflow(sub_under_overflow), .para1(para1), .para2(para2));

// see more details in specification
always @(add_result, multi_result, sub_result, ALU_op) begin
    case (ALU_op)
        2'b00: begin
            out = add_result;
            under_overflow = add_under_overflow;
        end
        2'b01: begin
            out = sub_result;
            under_overflow = sub_under_overflow;
        end
        2'b10: begin
            out = multi_result;
            under_overflow = multi_under_overflow;
        end
        default: begin
            out = 32'd0;
            under_overflow = 1'b0;
        end
    endcase
    zero = ~|out;
end
endmodule