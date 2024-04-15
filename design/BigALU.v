// for AddOp
`define INPUT_WIDTH 24
module BigALU(
    output reg [`INPUT_WIDTH : 0] out, // 25-bit result after operation
    input [`INPUT_WIDTH - 1 : 0] op1,
    input [`INPUT_WIDTH - 1 : 0] op2,
    input operator      // if 0 then add else sub
);
reg [`INPUT_WIDTH - 1 : 0] neg_op2;
always @(op1, op2, operator) begin
    if(!operator) begin
        out = op1 + op2;
        neg_op2 = 0;
    end
    else begin
        neg_op2 = ~op2 + 1'b1;
        out = op1 + neg_op2;
        //out = {1'b0, ~op2};
    end
end
endmodule