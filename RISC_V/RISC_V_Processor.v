module RISC_V_Processor(
  input clk,
  input reset
);
  wire [63:0] PC_Out;
  wire [63:0] PC_In;
  wire [63:0] PC_offset_4;
  wire [31:0] IMem_out;
  wire [6:0] opcode;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [2:0] funct3;
  wire [6:0] funct7;
  wire [63:0] imm_data;
  wire [1:0] ALUOp;
  wire Branch;
  wire MemRead;
  wire MemtoReg;
  wire MemWrite;
  wire ALUSrc;
  wire RegWrite;
  wire [63:0] write_data;
  wire [63:0] readdata1;
  wire [63:0] readdata2;
  wire [3:0] Operation;
  wire Zero;
  wire [63:0] Result;
  wire [63:0] mux_1_out;
  wire [63:0] DMem_Read;
  wire [63:0] shifted_imm_data;
  wire [63:0] PC_offset_branch;
  wire mux3_select;
  
  Program_Counter p1(clk, reset, PC_In, PC_Out);
  Adder a1(PC_Out, 64'd4, PC_offset_4);
  Instruction_Memory i1(PC_Out, IMem_out);
  instruction i3(IMem_out, opcode, rd, funct3, rs1, rs2, funct7);
  imm_data_gen i2(IMem_out, imm_data);
  Control_Unit c1(opcode, ALUOp, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite);
  registerFile r1(clk, reset, rs1, rs2, rd, write_data, RegWrite, readdata1, readdata2);
  ALU_Control a2(ALUOp,{IMem_out[30],IMem_out[14:12]},Operation);
  MUX m1(readdata2,	 imm_data, ALUSrc, mux_1_out);
  ALU_64_bit a3(readdata1, mux_1_out, Operation, Zero, Result);
  Data_Memory d1(clk, Result, readdata2, MemWrite, MemRead, DMem_Read);
  MUX m2(Result,DMem_Read,  MemtoReg, write_data);
  shift_left s1(imm_data, shifted_imm_data);
  Adder a4(PC_Out, shifted_imm_data, PC_offset_branch);
  MUX m3(PC_offset_4, PC_offset_branch, Branch&&Zero, PC_In);
  
  
endmodule