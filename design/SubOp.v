// Subtraction operators between two floating-point numbers
`define INPUT_WIDTH 32
module SubOp (
    output [`INPUT_WIDTH - 1 : 0] out,
    output under_overflow,
    input [`INPUT_WIDTH - 1 : 0] para1,
    input [`INPUT_WIDTH - 1 : 0] para2
);
// in general a - b = a + (-b)
wire [`INPUT_WIDTH - 1 : 0] inverse_para2;
assign inverse_para2 = {!para2[`INPUT_WIDTH - 1], para2[`INPUT_WIDTH - 2 : 0]};

AddOp add (.out(out), .under_overflow(under_overflow), .para1(para1), .para2(inverse_para2));
endmodule