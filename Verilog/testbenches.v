
module regFile_test;
    reg[2:0] rd, rs, rt;
    reg[23:0] dataIn;
    reg clk, we;
    wire[23:0] dataOutA, dataOutB;
    regFile rf (rs, rt, rd, dataIn, dataOutA, dataOutB, clk, we);
    initial begin 
        clk = 0;
        #40 $finish;
    end
    always #5 clk = ~clk;
    always @(posedge clk) begin
        $display("rs: %b, rt: %b, rd: %b, dataIn: %b, dataOutA: %b, dataOutB: %b, clk: %b, we: %b", rs, rt, rd, dataIn, dataOutA, dataOutB, clk, we);
    end
    initial begin
        rd = 7;
        we = 1;
        dataIn = 100;
        #6
        rd = 0;
        dataIn = 200;
        #6
        rs = 7;
        rt = 0;
        we = 0;
    end
endmodule