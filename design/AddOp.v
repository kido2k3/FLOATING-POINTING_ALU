// Addition operators between two floating-point numbers
// module AddOp (
//     output [31:0] out,
//     output under_overflow,
//     input [31:0] para1,
//     input [31:0] para2
// );
// //parameter
// parameter SIGN = 31;
// parameter EXPO = 30;
// parameter EXPO_LENGTH = 7;
// parameter SIGNI = 23;

// // initialize variables
// reg [SIGNI: 0] signiPara1 = 0;
// reg [SIGNI: 0] signiPara2 = 0;
// reg [SIGNI: 0] significand = 0;
// reg [EXPO_LENGTH: 0] expo1 = 0;
// reg [EXPO_LENGTH: 0] expo2 = 0;
// reg sign = 0;
// reg dis = 0;
// reg Cout = 0;
// reg flag = 0;

// always begin
//     signiPara1 = {1'b1, para1[SIGNI - 1: 0]};
//     signiPara2 = {1'b1, para2[SIGNI - 1: 0]};
//     expo1 = para1[EXPO: EXPO - EXPO_LENGTH];
//     expo2 = para2[EXPO: EXPO - EXPO_LENGTH];

//     if(expo1 < expo2) begin
//         assign dis = expo2 - expo1;
//         assign expo1 = expo2;
//         assign signiPara1 = signiPara1 >> dis;
//         assign sign = para2[SIGN];
//     end
//     else begin
//         assign dis = expo1 - expo2;
//         assign expo2 = expo1;
//         assign signiPara2 = signiPara2 >> dis;
//         assign sign = para1[SIGN];
//     end    

//     assign dis = 0;

//     if(para2[SIGN] == para1[SIGN]) begin
//         assign {Cout, significand} = signiPara1 + signiPara2;
//     end

//     if(Cout == 1) begin
//         assign significand = significand >> 1;
//         significand[SIGNI] = 1;
//     end    
//     else significand = significand;

//     if(expo1 == 255 && significand[SIGNI - 1: 0] == 0) begin
//         assign flag = 1;
//     end
//     else assign flag = 0;
// end

// always @(significand[SIGNI]) begin
//     if(significand[SIGNI] == 0) begin
//         assign significand = significand << 1;
//         assign expo1 = expo1 - 1;
//     end    
// end



// assign out = {sign, expo1, significand[SIGNI - 1: 0]};



// assign under_overflow = flag;

// endmodule


// Addition operators between two floating-point numbers
module AddOp (
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
reg [SIGNI: 0] significand = 0;
// reg [SIGNI + 1: 0] significand_sum = 0;
reg [EXPO_LENGTH: 0] expo = 0;
reg [EXPO_LENGTH: 0] expo_normalize = 0;
// reg [EXPO_LENGTH: 0] expo2 = 0;
reg [3:0] normalize = 0;
reg sign = 0;
reg [EXPO_LENGTH: 0] dis = 0;
reg Cout = 0;
reg flag = 0;

always @(*) begin
    signiPara1 = {1'b1, para1[SIGNI - 1: 0]};
    signiPara2 = {1'b1, para2[SIGNI - 1: 0]};
    // expo1 = para1[EXPO: EXPO - EXPO_LENGTH];
    // expo2 = para2[EXPO: EXPO - EXPO_LENGTH];

    if(para1[EXPO: EXPO - EXPO_LENGTH] < para2[EXPO: EXPO - EXPO_LENGTH]) begin
        assign dis = para2[EXPO: EXPO - EXPO_LENGTH] - para1[EXPO: EXPO - EXPO_LENGTH];
        assign expo = para2[EXPO: EXPO - EXPO_LENGTH];
        assign signiPara1 = signiPara1 >> dis;
        assign sign = para2[SIGN];
    end
    else begin
        assign dis = para1[EXPO: EXPO - EXPO_LENGTH] - para2[EXPO: EXPO - EXPO_LENGTH];
        assign expo = para1[EXPO: EXPO - EXPO_LENGTH];
        assign signiPara2 = signiPara2 >> dis;
        assign sign = para1[SIGN];
    end    

    // assign dis = 0;
end

always @(signiPara1, signiPara2) begin
    assign expo_normalize = expo;

    if(para2[SIGN] == para1[SIGN]) begin
        assign {Cout, significand} = signiPara1 + signiPara2;
    end

    if(Cout == 1) begin
        assign significand = significand >> 1;
        assign significand = significand + 2**SIGNI;
        assign expo_normalize = expo_normalize + 1;
    end    
    else significand = significand;

    
end

// assign out = {Cout, significand};

always @(significand[SIGNI], expo_normalize) begin
    if(significand[SIGNI] == 0) begin
        assign significand = significand << 1;
        assign expo_normalize = expo_normalize - 1;
    end
    // if(significand[SIGNI] == 0) begin
    //     assign significand = significand << 1;
    //     assign expo = expo - 1;
    // end    
end

// assign out = {significand[SIGNI - 1: 0]};

assign out = {sign, expo_normalize, significand[SIGNI - 1: 0]};

// always @(expo_normalize, significand) begin
//     if(expo_normalize == 255 && significand[SIGNI - 1: 0] == 0) begin
//         assign flag = 1;
//     end
//     else assign flag = 0;    
// end

assign under_overflow = (expo_normalize == 255 && significand[SIGNI - 1: 0] == 0) ? 1 : 0;

endmodule