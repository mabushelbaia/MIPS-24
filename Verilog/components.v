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
