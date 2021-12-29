module IF_ID (
    clk_i,
    Pc_i,
    Flush_i,
    Stall_i,
    Instruction_i,
    Pc_o,
    Instruction_o
);

    input clk_i, Flush_i, Stall_i;
    input [31:0] Pc_i, Instruction_i;

    output reg [31:0] Pc_o, Instruction_o;
    
    always @(posedge clk_i) begin
        if(Stall_i) begin
            Pc_o <= Pc_o;
            Instruction_o <= Instruction_o;
        end
        else if(Flush_i) begin
            Pc_o <= 32'b0;
            Instruction_o <= 32'b0;
        end
        else begin
            Pc_o <= Pc_i;
            Instruction_o <= Instruction_i;
        end
    end
endmodule

module ID_EX (
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    Read_Data_1_i,
    Read_Data_2_i,
    Imm_Gen_i,
    Funct_i,
    Read_Register_1_i,
    Read_Register_2_i,
    Write_Register_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    Read_Data_1_o,
    Read_Data_2_o,
    Imm_Gen_o,
    Funct_o,
    Read_Register_1_o,
    Read_Register_2_o,
    Write_Register_o
);

    input clk_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;
    input [1:0] ALUOp_i;
    input [4:0] Read_Register_1_i, Read_Register_2_i, Write_Register_i;
    input [9:0] Funct_i;
    input [31:0] Read_Data_1_i, Read_Data_2_i, Imm_Gen_i;

    output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;
    output reg [1:0] ALUOp_o;
    output reg [4:0] Read_Register_1_o, Read_Register_2_o, Write_Register_o;
    output reg [9:0] Funct_o;
    output reg [31:0] Read_Data_1_o, Read_Data_2_o, Imm_Gen_o;
    
    always @(posedge clk_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUSrc_o <= ALUSrc_i;
        ALUOp_o <= ALUOp_i;
        Read_Register_1_o <= Read_Register_1_i;
        Read_Register_2_o <= Read_Register_2_i;
        Write_Register_o <= Write_Register_i;
        Funct_o <= Funct_i;
        Read_Data_1_o <= Read_Data_1_i;
        Read_Data_2_o <= Read_Data_2_i;
        Imm_Gen_o <= Imm_Gen_i;
    end
endmodule

module EX_MEM (
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALU_Result_i,
    Read_Data_2_i,
    Write_Register_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALU_Result_o,
    Read_Data_2_o,
    Write_Register_o
);

    input clk_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i;
    input [4:0] Write_Register_i;
    input [31:0] ALU_Result_i, Read_Data_2_i;

    output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
    output reg [4:0] Write_Register_o;
    output reg [31:0] ALU_Result_o, Read_Data_2_o;
    
    always @(posedge clk_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        Write_Register_o <= Write_Register_i;
        ALU_Result_o <= ALU_Result_i;
        Read_Data_2_o <= Read_Data_2_i;
    end
endmodule

module MEM_WB (
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    ALU_Result_i,
    Read_Data_i,
    Write_Register_i,
    RegWrite_o,
    MemtoReg_o,
    ALU_Result_o,
    Read_Data_o,
    Write_Register_o
);
    
    input clk_i, RegWrite_i, MemtoReg_i;
    input [4:0] Write_Register_i;
    input [31:0] ALU_Result_i, Read_Data_i;

    output reg RegWrite_o, MemtoReg_o;
    output reg [4:0] Write_Register_o;
    output reg [31:0] ALU_Result_o, Read_Data_o;
    
    always @(posedge clk_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALU_Result_o <= ALU_Result_i;
        Read_Data_o <= Read_Data_i;
        Write_Register_o <= Write_Register_i;
    end
endmodule