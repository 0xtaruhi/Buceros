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
    output wire [ `RegDataBus] ex_rs2_data_o,

    output wire                stallreq_id_ex_o
);

    reg  stallreq_id_ex_r;

    gen_dffsr #(.WIDTH(    `INST_W))                             dffs_pc       (clk, rst_n, hold_i, id_pc_i, ex_pc_o);
    gen_dffsr #(.WIDTH(       1'b1))                             dffs_wmem_en  (clk, rst_n, hold_i, id_wmem_en_i, ex_wmem_en_o);
    gen_dffsr #(.WIDTH(       1'b1))                             dffs_rmem_en  (clk, rst_n, hold_i, id_rmem_en_i, ex_rmem_en_o);
    gen_dffsr #(.WIDTH(  `OPCODE_W),.HOLD_DATA(`INST_ARITH_IMM)) dffs_opcode   (clk, rst_n, hold_i, id_opcode_i, ex_opcode_o);
    gen_dffsr #(.WIDTH(  `FUNCT3_W))                             dffs_funct3   (clk, rst_n, hold_i, id_funct3_i, ex_funct3_o);
    gen_dffsr #(.WIDTH(  `FUNCT7_W))                             dffs_funct7   (clk, rst_n, hold_i, id_funct7_i, ex_funct7_o);
    gen_dffsr #(.WIDTH(     `IMM_W))                             dffs_imm      (clk, rst_n, hold_i, id_imm_i, ex_imm_o);
    gen_dffsr #(.WIDTH(       1'b1))                             dffs_wreg_en  (clk, rst_n, hold_i, id_wreg_en_i, ex_wreg_en_o);
    gen_dffsr #(.WIDTH(`REG_ADDR_W))                             dffs_wreg_addr(clk, rst_n, hold_i, id_wreg_addr_i, ex_wreg_addr_o);
    gen_dffsr #(.WIDTH(`REG_DATA_W))                             dffs_rs1_data (clk, rst_n, hold_i, id_rs1_data_i, ex_rs1_data_o);
    gen_dffsr #(.WIDTH(`REG_DATA_W))                             dffs_rs2_data (clk, rst_n, hold_i, id_rs2_data_i, ex_rs2_data_o);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            stallreq_id_ex_r <= 1'b0;
        end else if(id_rmem_en_i) begin
            stallreq_id_ex_r <= ~stallreq_id_ex_r;
        end else begin
            stallreq_id_ex_r <= 1'b0;
        end
    end

    assign stallreq_id_ex_o = stallreq_id_ex_r;

endmodule //id_ex