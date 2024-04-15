`timescale 1ns / 1ps
`define LINK_INPUT "E:/dai_hoc/LSILogicDesign/FLOATING-POINTING_ALU/auto_test/build.txt"
`define LINK_OUTPUT "E:/dai_hoc/LSILogicDesign/FLOATING-POINTING_ALU/auto_test/output_sim.txt"
module AddOp_tb;
    integer fd, f_in;

    reg [31:0] para1, para2;
    wire [31:0] out;
    wire under_overflow;

    AddOp uut(.para1(para1), .para2(para2), .out(out), .under_overflow(under_overflow));
    
    initial begin
        $monitor("At time %t : para1 = %h + para2 = %h = out = %h - under_overflow = %b ", $time, para1, para2, out, under_overflow);
    end

    initial begin
        f_in = $fopen(`LINK_INPUT, "r");
        fd = $fopen(`LINK_OUTPUT, "w");
        $fmonitorh(fd, out);
        while (!$feof(f_in)) begin
            $fscanf(f_in, "%h %h\n", para1, para2);
            #1;
        end
        $fclose(f_in);
        $fclose(fd);
        $finish;
    end
    initial begin
        
        
    end
    // initial begin
    //     $recordfile ("wave");
    //     $recordvars ("depth=0", MultiOp_tb);
    // end
    
endmodule
