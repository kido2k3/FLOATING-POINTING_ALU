// for AddOp
`define INPUT_WIDTH 25
module NormalizedDecoder (
    output reg [`INPUT_WIDTH - 3 : 0] result,// input 23-bit fraction
    output reg [4 : 0] shift_times,
    input [`INPUT_WIDTH - 1 : 0] in     // input 25-bit significand without normalizing
);
    reg [`INPUT_WIDTH - 1 : 0] shifted_value;
    always @(in) begin
        casex (in)
            25'b1_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd0;
                shifted_value = in;
            end
            25'b1_01xx_xxxx_xxxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd1;
                shifted_value = in << 1;
            end
            25'b1_001x_xxxx_xxxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd2;
                shifted_value = in << 2;
            end
            25'b1_0001_xxxx_xxxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd3; 
                shifted_value = in << 3;
            end
            25'b1_0000_1xxx_xxxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd4;
                shifted_value = in << 4;
            end
            25'b1_0000_01xx_xxxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd5;
                shifted_value = in << 5;
            end
            25'b1_0000_001x_xxxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd6; 
                shifted_value = in << 6;
            end
            25'b1_0000_0001_xxxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd7; 
                shifted_value = in << 7;
            end
            25'b1_0000_0000_1xxx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd8; 
                shifted_value = in << 8;
            end
            25'b1_0000_0000_01xx_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd9; 
                shifted_value = in << 9;
            end
            25'b1_0000_0000_001x_xxxx_xxxx_xxxx: begin 
                shift_times = 5'd10; 
                shifted_value = in << 10;
            end
            25'b1_0000_0000_0001_0xxx_xxxx_xxxx: begin 
                shift_times = 5'd11; 
                shifted_value = in << 11;
            end
            25'b1_0000_0000_0000_10xx_xxxx_xxxx: begin 
                shift_times = 5'd12; 
                shifted_value = in << 12;
            end
            25'b1_0000_0000_0000_01xx_xxxx_xxxx: begin 
                shift_times = 5'd13; 
                shifted_value = in << 13;
            end
            25'b1_0000_0000_0000_001x_xxxx_xxxx: begin 
                shift_times = 5'd14; 
                shifted_value = in << 14;
            end
            25'b1_0000_0000_0000_0001_xxxx_xxxx: begin 
                shift_times = 5'd15; 
                shifted_value = in << 15;
            end
            25'b1_0000_0000_0000_0000_1xxx_xxxx: begin 
                shift_times = 5'd16; 
                shifted_value = in << 16;
            end
            25'b1_0000_0000_0000_0000_01xx_xxxx: begin 
                shift_times = 5'd17; 
                shifted_value = in << 17;
            end
            25'b1_0000_0000_0000_0000_001x_xxxx: begin 
                shift_times = 5'd18; 
                shifted_value = in << 18;
            end
            25'b1_0000_0000_0000_0000_0001_xxxx: begin 
                shift_times = 5'd19; 
                shifted_value = in << 19;
            end
            25'b1_0000_0000_0000_0000_0000_1xxx: begin 
                shift_times = 5'd20; 
                shifted_value = in << 20;
            end
            25'b1_0000_0000_0000_0000_0000_01xx: begin 
                shift_times = 5'd21; 
                shifted_value = in << 21;
            end
            25'b1_0000_0000_0000_0000_0000_001x: begin 
                shift_times = 5'd22; 
                shifted_value = in << 22;
            end
            25'b1_0000_0000_0000_0000_0000_0001: begin 
                shift_times = 5'd23; 
                shifted_value = in << 23;
            end
            25'b1_0000_0000_0000_0000_0000_0000: begin 
                shift_times = 5'd24; 
                shifted_value = in | 25'h1800000;
            end
            default: begin
                shifted_value = ~in + 1'b1;
                shift_times = 5'd0;
            end
        endcase
        result = shifted_value[`INPUT_WIDTH - 3 : 0];
    end

endmodule