`include "../src/headers/buceros_header.v"

module ex_tb;

  // Parameters
  localparam  OP_LUI    = 7'b0110111;
  localparam  OP_AUIPC  = 7'b0010111;
  localparam  OP_JAL    = 7'b1101111;
  localparam  OP_JALR   = 7'b1100111;
  localparam  OP_B_TYPE = 7'b1100011;
  localparam  OP_LOAD   = 7'b0000011;
  localparam  OP_STORE  = 7'b0100011;
  localparam  OP_ARITHI = 7'b0010011;
  localparam  OP_ARITH  = 7'b0110011;
  localparam  OP_FENCE  = 7'b0001111;
  localparam  OP_ENV    = 7'b1110011;

  // Ports
  reg [`InstAddrBus] pc_i;
  reg  wmem_en_i = 0;
  reg  rmem_en_i = 0;
  reg [  `OpcodeBus] opcode_i;
  reg [  `Funct3Bus] funct3_i;
  reg [  `Funct7Bus] funct7_i;
  reg [     `ImmBus] imm_i;
  reg  wreg_en_i = 0;
  reg [ `RegAddrBus] wreg_addr_i;
  reg [ `RegDataBus] rs1_data_i;
  reg [ `RegDataBus] rs2_data_i;
  wire  wmem_en_o;
  wire  rmem_en_o;
  wire [`MemAddrBus] mem_addr_o;
  wire [ `Funct3Bus] funct3_o;
  wire  wreg_en_o;
  wire [`RegAddrBus] wreg_addr_o;
  wire [`RegDataBus] wreg_data_o;

  ex 
  ex_dut (
    .pc_i (pc_i ),
    .wmem_en_i (wmem_en_i ),
    .rmem_en_i (rmem_en_i ),
    .opcode_i (opcode_i ),
    .funct3_i (funct3_i ),
    .funct7_i (funct7_i ),
    .imm_i (imm_i ),
    .wreg_en_i (wreg_en_i ),
    .wreg_addr_i (wreg_addr_i ),
    .rs1_data_i (rs1_data_i ),
    .rs2_data_i (rs2_data_i ),
    .wmem_en_o (wmem_en_o ),
    .rmem_en_o (rmem_en_o ),
    .mem_addr_o (mem_addr_o ),
    .funct3_o (funct3_o ),
    .wreg_en_o (wreg_en_o ),
    .wreg_addr_o (wreg_addr_o ),
    .wreg_data_o  ( wreg_data_o)
  );

  initial begin
    begin
      wmem_en_i = 0;
      rmem_en_i = 0;
      wreg_en_i = 0;
      repeat(100000) begin
        #5 pc_i = $random;
        wmem_en_i = $random;
        rmem_en_i = $random;
        opcode_i = $random;
        funct3_i = $random;
        funct7_i = $random;
        imm_i = $random;
        wreg_en_i = $random;
        wreg_addr_i = $random;
        rs1_data_i = $random;
        rs2_data_i = $random;
        #5 opcode_i = OP_LUI;
        #5 opcode_i = OP_AUIPC;
        #5 opcode_i = OP_JAL;
        #5 opcode_i = OP_JALR;
        #5 opcode_i = OP_B_TYPE;
        #5 opcode_i = OP_LOAD;
        #5 opcode_i = OP_STORE;
        #5 opcode_i = OP_ARITHI;
        #5 opcode_i = OP_ARITH;
        #5 opcode_i = OP_FENCE;
        #5 opcode_i = OP_ENV;
        #5 opcode_i = $random;
      end
    end
  end


endmodule
