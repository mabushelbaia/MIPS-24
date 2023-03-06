
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


module instruction_mem_test;
    reg clk, instruction_en;
    reg [23:0] pc, instruction;
    initial begin 
		clk = 1;
        #100 $finish;
    end
    always #5 clk = ~clk;
    instruction_mem im (pc, clk, instruction_en, instruction);
    always @(negedge clk) begin	  
        $display("pc: 0x%h, instruction: 0x%h", pc, instruction);
    end
    initial begin
        instruction_en = 1;
        pc = 0;
        #10
        pc = 3;
        #10
        pc = 6;
        #10
        instruction_en = 0;
        #10
        pc = 9;
    end
endmodule
module data_mem_test;
    reg [23:0] address;
    reg [23:0] dataIn;
    reg clk, we, re;
    wire [23:0] dataOut;
    data_mem dm (address, dataIn, clk, we, re, dataOut);
    initial begin 
        clk = 0;
        #100 $finish;
    end
    always #5 clk = ~clk;
    always @(negedge clk) begin
        $display("address: %b, dataIn: %b, clk: %b, we: %b, re: %b, dataOut: %b", address, dataIn, clk, we, re, dataOut);
    end
    initial begin
        address = 0;
        dataIn = 100;
        we = 1;
        re = 0;
        #10
        address = 3;
        dataIn = 200;
        #10
        address = 6;
        dataIn = 300;
        #10
        address = 9;
        dataIn = 0;
        we = 1;
        #10
        address = 0;
        re = 1;
        #10
        address = 3;
        re = 1;
        #10
        address = 6;
        re = 1;
        #10
        address = 9;
        re = 1;
        #10
        address = 0;
        re = 1;	 
		#10
		$finish;
    end
endmodule
