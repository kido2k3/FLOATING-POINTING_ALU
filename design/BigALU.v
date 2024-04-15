// for AddOp
`define INPUT_WIDTH 24
module BigALU(
    output reg [`INPUT_WIDTH : 0] out, // 25-bit result after operation
    input [`INPUT_WIDTH - 1 : 0] op1,
    input [`INPUT_WIDTH - 1 : 0] op2,
    input operator      // if 0 then add else sub
);
always @(op1, op2, operator) begin
    if(!operator) begin
        out = op1 + op2;
    end
    else begin
        out = op1 + (~op2 + 1'b1);
    end
end
endmodule