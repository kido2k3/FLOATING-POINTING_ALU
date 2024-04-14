`timescale 1ns / 1ps

module SubOp_tb;

    reg [31:0] para1, para2;
    wire [31:0] out;
    wire under_overflow;

    SubOp uut(.para1(para1), .para2(para2), .out(out), .under_overflow(under_overflow));
    
    initial begin
        $monitor("At time %t : para1 = %h - para2 = %h = out = %h - unter_overflow = %b ", $time, para1, para2, out, under_overflow);
    end

    initial begin
    para1 = 32'h41480000; // 12.5
    para2 = 32'h40A80000; // 5.25
    //out = 32'h40E80000; // 7.25
    #1
    para1 = 32'h40A80000; // 5.25
    para2 = 32'h41480000; // 12.5
    //out = 32'hC0E80000; // -7.25
    #1
    para1 = 32'h41A20000; // 20.25
    para2 = 32'h414C0000; // 12.75
    //out = 32'h40F00000; // 7.5    
    #1
    para1 = 32'h41A20000; // 20.25
    para2 = 32'hC14C0000; // -12.75
    //out = 32'h42040000; // 33
    #1
    para1 = 32'hC1A20000; // -20.25
    para2 = 32'hC14C0000; // -12.75
    //out = 32'hC0F00000; // -7.5
    #1
    para1 = 32'hC1A20000; // -20.25
    para2 = 32'h414C0000; // 12.75
    //out = 32'hC2040000; // -33
    #1
    para1 = 32'h41A7EB85; // 20.99
    para2 = 32'h414FD70A; // 12.99
    //out = 32'h41000000; // 8
    #1
    para1 = 32'h42FB147B; // 125.54
    para2 = 32'h41C7EB85; // 24.99
    //out = 32'h42C9199A; // 100.55
    #1
    para1 = 32'h4504D8B4; // 2125.544
    para2 = 32'h461B13F8; // 9924.992
    //out = 32'hC5F3BB96; // -7799.448
    #1 $finish;
    end

    initial begin
    $recordfile ("wave");
    $recordvars ("depth=0", SubOp_tb);
    end
    
endmodule
