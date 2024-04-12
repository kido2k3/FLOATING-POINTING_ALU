// Subtraction operators between two floating-point numbers
module SubOp (
    output [31:0] out,
    output under_overflow,
    input [31:0] para1,
    input [31:0] para2
);
//parameter
parameter SIGN = 31;
parameter EXPO = 30;
parameter EXPO_LENGTH = 7;
parameter SIGNI = 23;

// initialize variables
reg [SIGNI: 0] signiPara1 = {1, para1[SIGNI - 1: 0]};
reg [SIGNI: 0] signiPara2 = {1, para2[SIGNI - 1: 0]};
reg [SIGNI: 0] significand = 0;
reg [EXPO_LENGTH: 0] expo1 = para1[EXPO: EXPO - EXPO_LENGTH];
reg [EXPO_LENGTH: 0] expo2 = para2[EXPO: EXPO - EXPO_LENGTH];
reg sign = 0;
reg dis = 0;
reg Cout = 0;

if(expo1 < expo2) begin
    assign dis = expo2 - expo1;
    assign expo1 = expo2;
    assign signiPara1 = signiPara1 >> dis;
    assign sign = para2[SIGN];
end
else begin
    assign dis = expo1 - expo2;
    assign expo2 = expo1;
    assign signiPara2 = signiPara2 >> dis;
    assign sign = para1[SIGN];
end

assign dis = 0;

if(para2[SIGN] == para1[SIGN]) begin
    assign {Cout, significand} = signiPara1 + signiPara2;
end
else begin
    if(signiPara1 < signiPara2) begin
        assign {Cout, significand} = signiPara1 - signiPara2;    
    end
    else assign {Cout, significand} = signiPara2 - signiPara1;
end

if(Cout == 1) begin
    assign significand = significand >> 1;
    assign significand[SIGNI] = 1;
end

for(;significand[SIGNI] == 0;) begin
    assign significand = significand << 1;
    assign expo1 -= 1;
end

assign out = {sign, expo1, significand[SIGNI - 1: 0]};

if(expo1 == 255 && significand[SIGNI - 1: 0] == 0) begin
    assign under_overflow = 1;
end
else assign under_overflow = 0;

endmodule