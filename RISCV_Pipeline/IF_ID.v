module IF_ID(
  input clk,
  input reset,
  input [63:0] PC_In,
  input  [31:0] Inst_input,
  input IF_ID_Write,
  input flush,
  output reg [31:0] Inst_output,
  output reg [63:0] PC_Out

);
  
  always @ (posedge clk or posedge reset)
    begin
    if (reset == 1'b1)
      begin
         PC_Out <= 64'd0; 
         Inst_output <= 32'd0;
      end
    else if (IF_ID_Write != 1'b0)
       begin
         PC_Out <= PC_In;
         Inst_output <= Inst_input;
       end
    if (flush) begin
      Inst_output <= 32'd0;
    end
    end
endmodule
