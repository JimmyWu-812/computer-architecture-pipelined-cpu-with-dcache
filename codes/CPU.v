module CPU
(
    clk_i, 
    rst_i,
    start_i,

    mem_data_i, 
    mem_ack_i,     
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

integer counter;

initial begin
    counter = 0;
end

always @(posedge clk_i) begin
    counter = counter + 1;
end

// ports
input clk_i;
input rst_i;
input start_i;

input [255:0] mem_data_i;
input mem_ack_i;

output [255:0] mem_data_o;
output [31:0] mem_addr_o;
output mem_enable_o;
output mem_write_o;

// wires in IF stage
wire [31:0] Adder_IF, Mux21_IF, Pc_IF, Instruction_IF;

// wires in ID stage
wire PCWrite_ID, Stall_ID, Flush_ID, NoOp_ID, Branch_ID;
wire RegWrite_ID, MemtoReg_ID, MemRead_ID, MemWrite_ID, ALUSrc_ID, Comparator_ID;
wire [1:0] ALUOp_ID;
wire [31:0] Read_Data_1_ID, Read_Data_2_ID;
wire [31:0] Pc_ID, Instruction_ID, Shifter_ID, Adder_ID, Imm_Gen_ID;

// wires in EX stage
wire RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX;
wire ALUSrc_EX;
wire [1:0] ALUOp_EX, Forward_A_EX, Forward_B_EX;
wire [2:0] ALU_Control_EX;
wire [4:0] Read_Register_1_EX, Read_Register_2_EX, Write_Register_EX;
wire [9:0] Funct_EX;
wire [31:0] Read_Data_1_EX, Read_Data_2_EX, Imm_Gen_EX;
wire [31:0] Mux21_A_1_EX, Mux21_B_1_EX, Mux21_A_2_EX, Mux21_B_2_EX, Mux21_C_EX, ALU_Result_EX;

// wires in MEM stage
wire RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, MemWrite_MEM, MemStall_MEM;
wire [4:0] Write_Register_MEM;
wire [31:0] ALU_Result_MEM, Write_Data_MEM, Read_Data_MEM;

// wires in WB stage
wire RegWrite_WB, MemtoReg_WB;
wire [4:0] Write_Register_WB;
wire [31:0] ALU_Result_WB, Read_Data_WB, Mux21_WB;

// initial conditions for wires
wire PCWrite_ID_module, Flush_ID_module, Stall_ID_module;
assign Stall_ID = (counter === 1/* || counter === 2*/) ? 0 : Stall_ID_module;
assign PCWrite_ID = (counter === 1/* || counter === 2*/) ? 1 : PCWrite_ID_module;
assign Flush_ID = /*(counter === 1) ? 0 : */Flush_ID_module;

wire NoOp_ID_module;
wire [4:0] Write_Register_WB_module;
wire [31:0] Mux21_WB_module;
assign NoOp_ID = (/*counter === 1 || */Instruction_ID === 0) ? 1 : NoOp_ID_module;
assign Write_Register_WB = (counter === 1 || counter === 2 || counter === 3/* || counter === 4*/) ? 0 : Write_Register_WB_module;
assign Mux21_WB = (counter === 1 || counter === 2 || counter === 3/* || counter === 4*/) ? Read_Data_1_ID : Mux21_WB_module;

wire RegWrite_MEM_module;
assign RegWrite_MEM = (counter === 1 || counter === 2/* || counter === 3*/) ? 0 : RegWrite_MEM_module;

// pipeline Registers
IF_ID IF_ID (
    .clk_i (clk_i),
    .Pc_i (Pc_IF),
    .Flush_i (Flush_ID),
    .Stall_i (Stall_ID),
    .Instruction_i (Instruction_IF),
    .Mem_Stall_i(MemStall_MEM),
    .Pc_o (Pc_ID),
    .Instruction_o (Instruction_ID)
);

ID_EX ID_EX (
    .clk_i (clk_i),
    .RegWrite_i (RegWrite_ID),
    .MemtoReg_i (MemtoReg_ID),
    .MemRead_i (MemRead_ID),
    .MemWrite_i (MemWrite_ID),
    .ALUOp_i (ALUOp_ID),
    .ALUSrc_i (ALUSrc_ID),
    .Read_Data_1_i (Read_Data_1_ID),
    .Read_Data_2_i (Read_Data_2_ID),
    .Imm_Gen_i (Imm_Gen_ID),
    .Funct_i ({Instruction_ID[31:25], Instruction_ID[14:12]}),
    .Read_Register_1_i (Instruction_ID[19:15]),
    .Read_Register_2_i (Instruction_ID[24:20]),
    .Write_Register_i (Instruction_ID[11:7]),
    .Mem_Stall_i(MemStall_MEM),
    .RegWrite_o (RegWrite_EX),
    .MemtoReg_o (MemtoReg_EX),
    .MemRead_o (MemRead_EX),
    .MemWrite_o (MemWrite_EX),
    .ALUOp_o (ALUOp_EX),
    .ALUSrc_o (ALUSrc_EX),
    .Read_Data_1_o (Read_Data_1_EX),
    .Read_Data_2_o (Read_Data_2_EX),
    .Imm_Gen_o (Imm_Gen_EX),
    .Funct_o (Funct_EX),
    .Read_Register_1_o (Read_Register_1_EX),
    .Read_Register_2_o (Read_Register_2_EX),
    .Write_Register_o (Write_Register_EX)
);

EX_MEM EX_MEM (
    .clk_i (clk_i),
    .RegWrite_i (RegWrite_EX),
    .MemtoReg_i (MemtoReg_EX),
    .MemRead_i (MemRead_EX),
    .MemWrite_i (MemWrite_EX),
    .ALU_Result_i (ALU_Result_EX),
    .Read_Data_2_i (Mux21_B_2_EX),
    .Write_Register_i (Write_Register_EX),
    .Mem_Stall_i(MemStall_MEM),
    .RegWrite_o (RegWrite_MEM_module),
    .MemtoReg_o (MemtoReg_MEM),
    .MemRead_o (MemRead_MEM),
    .MemWrite_o (MemWrite_MEM),
    .ALU_Result_o (ALU_Result_MEM),
    .Read_Data_2_o (Write_Data_MEM),
    .Write_Register_o (Write_Register_MEM)
);

MEM_WB MEM_WB (
    .clk_i (clk_i),
    .RegWrite_i (RegWrite_MEM),
    .MemtoReg_i (MemtoReg_MEM),
    .ALU_Result_i (ALU_Result_MEM),
    .Read_Data_i (Read_Data_MEM),
    .Write_Register_i (Write_Register_MEM),
    .Mem_Stall_i(MemStall_MEM),
    .RegWrite_o (RegWrite_WB),
    .MemtoReg_o (MemtoReg_WB),
    .ALU_Result_o (ALU_Result_WB),
    .Read_Data_o (Read_Data_WB),
    .Write_Register_o (Write_Register_WB_module)
);

// modules in IF stage
assign Adder_IF = Pc_IF + 32'b100;

MUX32 MUX21_IF(
    .Data_1_i (Adder_IF),
    .Data_2_i (Adder_ID),
    .Control_i (Flush_ID),
    .Data_o (Mux21_IF)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .stall_i    (MemStall_MEM),
    .PCWrite_i  (PCWrite_ID),
    .pc_i       (Mux21_IF),
    .pc_o       (Pc_IF)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (Pc_IF), 
    .instr_o    (Instruction_IF)
);

// modules in ID stage
assign Shifter_ID = Imm_Gen_ID << 1;
assign Adder_ID = Shifter_ID + Pc_ID;
assign Comparator_ID = (Read_Data_1_ID === Read_Data_2_ID);
assign Flush_ID_module = Branch_ID && Comparator_ID;

Control Control(
    .Op_i (Instruction_ID[6:0]),
    .NoOp_i (NoOp_ID),
    .RegWrite_o (RegWrite_ID),
    .MemtoReg_o (MemtoReg_ID),
    .MemRead_o (MemRead_ID),
    .MemWrite_o (MemWrite_ID),
    .ALUOp_o (ALUOp_ID),
    .ALUSrc_o (ALUSrc_ID),
    .Branch_o (Branch_ID)
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (Instruction_ID[19:15]),
    .RS2addr_i   (Instruction_ID[24:20]),
    .RDaddr_i    (Write_Register_WB), 
    .RDdata_i    (Mux21_WB),
    .RegWrite_i  (RegWrite_WB), 
    .RS1data_o   (Read_Data_1_ID), 
    .RS2data_o   (Read_Data_2_ID) 
);

Imm_Gen Imm_Gen(
    .Imm_i (Instruction_ID),
    .Imm_o (Imm_Gen_ID)
);

Hazard_Detection_Unit Hazard_Detection_Unit(
    .Read_Register_1_ID_i (Instruction_ID[19:15]),
    .Read_Register_2_ID_i (Instruction_ID[24:20]),
    .Write_Register_EX_i (Write_Register_EX),
    .MemRead_EX_i (MemRead_EX),
    .NoOp_o (NoOp_ID_module),
    .Stall_o (Stall_ID_module),
    .PCWrite_o (PCWrite_ID_module)
);

// modules in EX stage
ALU ALU(
    .Data_1_i (Mux21_A_2_EX),
    .Data_2_i (Mux21_C_EX),
    .ALUCtrl_i (ALU_Control_EX),
    .Data_o (ALU_Result_EX)
);

ALU_Control ALU_Control(
    .Funct_i (Funct_EX),
    .ALUOp_i (ALUOp_EX),
    .ALUCtrl_o (ALU_Control_EX)
);

Forwarding_Unit Forwarding_Unit(
    .Read_Register_1_EX_i (Read_Register_1_EX),
    .Read_Register_2_EX_i (Read_Register_2_EX),
    .Write_Register_MEM_i (Write_Register_MEM),
    .RegWrite_MEM_i (RegWrite_MEM),
    .Write_Register_WB_i (Write_Register_WB),
    .RegWrite_WB_i (RegWrite_WB),
    .Forward_A_o (Forward_A_EX),
    .Forward_B_o (Forward_B_EX)
);

MUX32 MUX21_A_1_EX(
    .Data_1_i (Read_Data_1_EX),
    .Data_2_i (Mux21_WB),
    .Control_i (Forward_A_EX[0]),
    .Data_o (Mux21_A_1_EX)
);

MUX32 MUX21_A_2_EX(
    .Data_1_i (Mux21_A_1_EX),
    .Data_2_i (ALU_Result_MEM),
    .Control_i (Forward_A_EX[1]),
    .Data_o (Mux21_A_2_EX)
);

MUX32 MUX21_B_1_EX(
    .Data_1_i (Read_Data_2_EX),
    .Data_2_i (Mux21_WB),
    .Control_i (Forward_B_EX[0]),
    .Data_o (Mux21_B_1_EX)
);

MUX32 MUX21_B_2_EX(
    .Data_1_i (Mux21_B_1_EX),
    .Data_2_i (ALU_Result_MEM),
    .Control_i (Forward_B_EX[1]),
    .Data_o (Mux21_B_2_EX)
);

MUX32 MUX21_C_EX(
    .Data_1_i (Mux21_B_2_EX),
    .Data_2_i (Imm_Gen_EX),
    .Control_i (ALUSrc_EX),
    .Data_o (Mux21_C_EX)
);

// modules in MEM stage
// Data_Memory Data_Memory(
//     .clk_i (clk_i), 
//     .addr_i (ALU_Result_MEM), 
//     .MemRead_i (MemRead_MEM),
//     .MemWrite_i (MemWrite_MEM),
//     .data_i (Write_Data_MEM),
//     .data_o (Read_Data_MEM)
// );

dcache_controller dcache(
    .clk_i (clk_i), 
    .rst_i (rst_i),
    .mem_data_i (mem_data_i), 
    .mem_ack_i (mem_ack_i),     
    .mem_data_o (mem_data_o), 
    .mem_addr_o (mem_addr_o),     
    .mem_enable_o (mem_enable_o), 
    .mem_write_o (mem_write_o), 
    .cpu_data_i (Write_Data_MEM), 
    .cpu_addr_i (ALU_Result_MEM),     
    .cpu_MemRead_i (MemRead_MEM), 
    .cpu_MemWrite_i (MemWrite_MEM), 
    .cpu_data_o (Read_Data_MEM), 
    .cpu_stall_o (MemStall_MEM)
);

// modules in WB stage
MUX32 MUX21_WB(
    .Data_1_i (ALU_Result_WB),
    .Data_2_i (Read_Data_WB),
    .Control_i (MemtoReg_WB),
    .Data_o (Mux21_WB_module)
);

endmodule