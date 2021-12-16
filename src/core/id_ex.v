/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:40:08
 * LastEditTime : 2021-12-16 14:41:05
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\core\id_ex.v
 */
`include "../headers/buceros_header.v"

module id_ex (
    input  wire                clk,
    input  wire                rst_n,
    input  wire                hold_i,
    
    input  wire [`InstAddrBus] id_pc_i,
    input  wire                id_wmem_en_i,
    input  wire                id_rmem_en_i,
    input  wire [  `OpcodeBus] id_opcode_i,
    input  wire [  `Funct3Bus] id_funct3_i,
    input  wire [  `Funct7Bus] id_funct7_i,
    input  wire [     `ImmBus] id_imm_i,
    input  wire                id_wreg_en_i,
    input  wire [ `RegAddrBus] id_wreg_addr_i,
    input  wire [ `RegDataBus] id_rs1_data_i,
    input  wire [ `RegDataBus] id_rs2_data_i,

    output wire [`InstAddrBus] ex_pc_o,
    output wire                ex_wmem_en_o,
    output wire                ex_rmem_en_o,
    output wire [  `OpcodeBus] ex_opcode_o,
    output wire [  `Funct3Bus] ex_funct3_o,
    output wire [  `Funct7Bus] ex_funct7_o,
    output wire [     `ImmBus] ex_imm_o,
    output wire                ex_wreg_en_o,
    output wire [ `RegAddrBus] ex_wreg_addr_o,
    output wire [ `RegDataBus] ex_rs1_data_o,
    output wire [ `RegDataBus] ex_rs2_data_o
);

    gen_dffr #(.WIDTH(    `INST_W)) dff_pc       (clk, rst_n, hold_i, id_pc_i, ex_pc_o);
    gen_dffr #(.WIDTH(       1'b1)) dff_wmem_en  (clk, rst_n, hold_i, id_wmem_en_i, ex_wmem_en_o);
    gen_dffr #(.WIDTH(       1'b1)) dff_rmem_en  (clk, rst_n, hold_i, id_rmem_en_i, ex_rmem_en_o);
    gen_dffr #(.WIDTH(  `OPCODE_W)) dff_opcode   (clk, rst_n, hold_i, id_opcode_i, ex_opcode_o);
    gen_dffr #(.WIDTH(  `FUNCT3_W)) dff_funct3   (clk, rst_n, hold_i, id_funct3_i, ex_funct3_o);
    gen_dffr #(.WIDTH(  `FUNCT7_W)) dff_funct7   (clk, rst_n, hold_i, id_funct7_i, ex_funct7_o);
    gen_dffr #(.WIDTH(     `IMM_W)) dff_imm      (clk, rst_n, hold_i, id_imm_i, ex_imm_o);
    gen_dffr #(.WIDTH(       1'b1)) dff_wreg_en  (clk, rst_n, hold_i, id_wreg_en_i, ex_wreg_en_o);
    gen_dffr #(.WIDTH(`REG_ADDR_W)) dff_wreg_addr(clk, rst_n, hold_i, id_wreg_addr_i, ex_wreg_addr_o);
    gen_dffr #(.WIDTH(`REG_DATA_W)) dff_rs1_data (clk, rst_n, hold_i, id_rs1_data_i, ex_rs1_data_o);
    gen_dffr #(.WIDTH(`REG_DATA_W)) dff_rs2_data (clk, rst_n, hold_i, id_rs2_data_i, ex_rs2_data_o);

endmodule //id_ex