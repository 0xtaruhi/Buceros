`include "../headers/buceros_header.v"
module id (
    input  wire [`RegDataBus] pc_i,
    input  wire               ex_wreg_en_i,
    input  wire [`RegAddrBus] ex_wreg_addr_i,
    input  wire [`RegDataBus] ex_wreg_data_i,
    input  wire               mem_wreg_en_i,
    input  wire [`RegAddrBus] mem_wreg_addr_i,
    input  wire [`RegDataBus] mem_wreg_data_i,

    output wire               wmem_en_o,
    output wire               rmem_en_o,
    output wire               opcode_o,
    output wire [`Funct3Bus]  funct3_o,
    output wire [`Funct7Bus]  funct7_o,
    output wire [   `ImmBus]  imm_o,
    output wire               wreg_en_o,
    output wire [`RegAddrBus] wreg_addr_o,
    output wire [`RegAddrBus] rs1_addr_o,
    output wire [`RegDataBus] rs1_data_o,
    output wire [`RegAddrBus] rs2_addr_o,
    output wire [`RegDataBus] rs2_data_o
);
    
endmodule //id