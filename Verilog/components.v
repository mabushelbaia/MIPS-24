module regFile(input [2:0] rs, rt, rd, input [23:0] dataIn, output reg [23:0] dataOutA, dataOutB, input clk, input we);
    reg [23:0] regFile [7:0];
    initial begin
        regFile[0] = 0;
        regFile[1] = 0;
        regFile[2] = 0;
        regFile[3] = 0;
        regFile[4] = 0;
        regFile[5] = 0;
        regFile[6] = 0;
        regFile[7] = 0;
    end
    always @(posedge clk) begin
        if (we) begin
            if (rd != 0) begin 
                regFile[rd] <= dataIn;
            end	  
        end
        else begin
            dataOutA <= regFile[rs];
            dataOutB <= regFile[rt];
        end
    end
endmodule


module data_mem(
    input [23:0] address,
    input [23:0] dataIn,
    input clk, we, re,
    output reg [23:0] dataOut
    );
    reg [7:0] memory [2**24-1:0];
    always @(posedge clk) begin
        if (we) {memory[address+2], memory[address+1], memory[address]} <= {dataIn};
        if (re) {dataOut} <= {memory[address+2], memory[address+1], memory[address]};
    end					
endmodule
module instruction_mem(
    input [23:0] address, 
    input clk, 
    input en,
    output reg [23:0] instruction
    );
    reg [7:0] memory [2**24-1:0];
    assign {memory[2],memory[1],memory[0]} = 24'hDEADBE;
    assign {memory[5],memory[4],memory[3]} = 24'hFEEDBA;
    assign {memory[8],memory[7],memory[6]} = 24'hABCDEF;
    assign {memory[11],memory[10],memory[9]} = 24'hC0FFEE;
    assign {memory[14],memory[13],memory[12]} = 24'hBEEFCA;
    always @(posedge clk) begin
        if (en) instruction <= {memory[address+2], memory[address+1], memory[address]};
    end
endmodule
module controler(
    input clk, we = 0,
    input [23:0] instruction,
    output reg [4:0] opcode,
    output reg [2:0] rs, rt, rd,
    output reg [1:0] cond,
    output reg set_flag,
    output reg [23:0] dataOutA, dataOutB
    );
    regFile rf (rs, rt, rd, dataIn, dataOutA, dataOutB, clk, we);
    always @* begin
        opcode = instruction[21:17];
        rs = instruction[12:10];
        rt = instruction[9:7];
        rd = instruction[15:13];
        cond = instruction[23:22];
        set_flag = instruction[16];
    end
endmodule
module mini_system;
    reg clk, instruction_en, we;
    reg [23:0] pc, instruction;
    wire [4:0] opcode;
    wire [2:0] rs, rt, rd;
    wire [1:0] cond;
    wire set_flag;
    wire [23:0] dataOutA, dataOutB;
    controler c (clk, we, instruction, opcode, rs, rt, rd, cond, set_flag, dataOutA, dataOutB);
    instruction_mem im (pc, clk, instruction_en, instruction);
    initial begin 
        clk = 1;
        instruction_en = 1;
        #100 $finish;
    end
    always #5 clk = ~clk;
    initial begin
        pc = 0;
        instruction_en = 1;
        #10
        pc = 3;
        #10
        pc = 6;
        #10
        pc = 9;
    end
    always @(negedge clk) begin
        display("PC: %h, Instruction: %h, Opcode: %h, rs: %h, rt: %h, rd: %h, cond: %h, set_flag: %h, dataOutA: %h, dataOutB: %h", pc, instruction, opcode, rs, rt, rd, cond, set_flag, dataOutA, dataOutB);
    end
endmodule