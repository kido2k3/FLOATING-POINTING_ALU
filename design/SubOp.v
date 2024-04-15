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
reg [SIGNI: 0] signiPara1 = 0;
reg [SIGNI: 0] signiPara2 = 0;
reg [SIGNI: 0] significand = 24'hFFFFFF;

reg [EXPO_LENGTH: 0] dis = 0;
reg [EXPO_LENGTH: 0] expo = 0;
reg [EXPO_LENGTH: 0] expo_normalize = 0;


reg [4: 0] dif = 0;
reg sign = 0;
reg Cout = 0;

always @(signiPara1, signiPara2) begin
    if(para1[EXPO: EXPO - EXPO_LENGTH] < para2[EXPO: EXPO - EXPO_LENGTH]) begin
        assign dis = para2[EXPO: EXPO - EXPO_LENGTH] - para1[EXPO: EXPO - EXPO_LENGTH];
        assign expo = para2[EXPO: EXPO - EXPO_LENGTH];
        assign signiPara1 = {1'b1, para1[SIGNI - 1: 0]} >> dis;
        assign signiPara2 = {1'b1, para2[SIGNI - 1: 0]};
        assign sign = !para2[SIGN];
    end
    else begin
        assign dis = para1[EXPO: EXPO - EXPO_LENGTH] - para2[EXPO: EXPO - EXPO_LENGTH];
        assign expo = para1[EXPO: EXPO - EXPO_LENGTH];
        assign signiPara1 = {1'b1, para1[SIGNI - 1: 0]};
        assign signiPara2 = {1'b1, para2[SIGNI - 1: 0]} >> dis;
        assign sign = para1[SIGN];
    end    

    assign expo_normalize = expo;
end

always @(signiPara1, signiPara2) begin
    if(para1[SIGN] == !para2[SIGN]) begin
        assign {Cout, significand} = signiPara1 + signiPara2;
    end
    else begin
        if(signiPara1 < signiPara2) begin
            assign {Cout, significand} = signiPara2 - signiPara1;    
        end
        else assign {Cout, significand} = signiPara1 - signiPara2;
    end

    if(Cout == 1) begin
        assign significand = (significand >>> 1) + (1 <<< SIGNI);
        assign expo_normalize = expo_normalize + 1;
        assign Cout = 0;
    end    
    else significand = significand;
    
    assign dif = SIGNI - $clog2(significand) + 1;
end

always @(dif) begin
    if(dif != 0) begin        
        assign significand = significand << dif;
        assign expo_normalize = expo_normalize - dif;
    end    
end

assign out = {sign, expo_normalize, significand[SIGNI - 1: 0]};

assign under_overflow = (expo_normalize == 255 && significand[SIGNI - 1: 0] == 0) ? 1 : 0;

endmodule