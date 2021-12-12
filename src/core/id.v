/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-06 21:19:00
 * LastEditTime : 2021-12-12 11:51:22
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\core\id.v
 */
 `include "../headers/buceros_header.v"
 module id (
     input  wire                rst_n,
     input  wire [`InstAddrBus] pc_i,
     input  wire [    `InstBus] inst_i,
     input  wire                ex_wreg_en_i,
     input  wire [ `RegAddrBus] ex_wreg_addr_i,
     input  wire [ `RegDataBus] ex_wreg_data_i,
     input  wire                mem_wreg_en_i,
     input  wire [ `RegAddrBus] mem_wreg_addr_i,
     input  wire [ `RegDataBus] mem_wreg_data_i,
     input  wire [ `RegDataBus] rs1_data_i,
     input  wire [ `RegDataBus] rs2_data_i,
 
     output wire                branch_o,
     output wire [`InstAddrBus] pc_o,
     output wire                wmem_en_o,
     output wire                rmem_en_o,
     output wire [  `OpcodeBus] opcode_o,
     output wire [  `Funct3Bus] funct3_o,
     output wire [  `Funct7Bus] funct7_o,
     output wire [     `ImmBus] imm_o,
     output wire                wreg_en_o,
     output wire [ `RegAddrBus] wreg_addr_o,
     output wire [ `RegAddrBus] rs1_addr_o,
     output wire [ `RegDataBus] rs1_data_o,
     output wire [ `RegAddrBus] rs2_addr_o,
     output wire [`RegDataBus] rs2_data_o
 );
     // Instruction Type
     wire       inst_type_R;
     wire       inst_type_I;
     wire       inst_type_S;
     wire       inst_type_B;
     wire       inst_type_U;
     wire       inst_type_J;
 
     wire       inst_branch;
     wire       inst_load;
     wire       inst_store;
     wire       inst_alu_imm;
     wire       inst_alu_reg;
     wire       inst_lui;
     wire       inst_auipc;
     wire       inst_jal;
     wire       inst_jalr;
 
     wire       rs1_lt_rs2;
     wire       rs1_ltu_rs2;
     wire       rs1_eq_rs2;
     wire       rs1_ltu_rs2_exclude_msb;
     wire       rs_diff_signed;
 
     assign inst_branch  = opcode_o[6:2] == 5'b11000;
     assign inst_load    = opcode_o[6:2] == 5'b00000;
     assign inst_store   = opcode_o[6:2] == 5'b01000;
     assign inst_alu_imm = opcode_o[6:2] == 5'b00100;
     assign inst_alu_reg = opcode_o[6:2] == 5'b01100;
     assign inst_lui     = opcode_o[6:2] == 5'b01101;
     assign inst_auipc   = opcode_o[6:2] == 5'b00101;
     assign inst_jal     = opcode_o[6:2] == 5'b11011;
     assign inst_jalr    = opcode_o[6:2] == 5'b11001;
 
     assign inst_type_R = inst_alu_reg;
     assign inst_type_I = inst_alu_imm | inst_load;
     assign inst_type_S = inst_store;
     assign inst_type_B = inst_branch;
     assign inst_type_U = inst_lui | inst_auipc;
     assign inst_type_J = inst_jal;
 
     assign opcode_o     = inst_i[ 6: 0];
     assign wreg_addr_o  = inst_i[11: 7];
     assign rs1_addr_o   = inst_i[20:16];
     assign rs2_addr_o   = inst_i[25:21];
     assign funct3_o     = inst_i[14:12];
     assign funct7_o     = inst_i[31:25];
     assign imm_o        = {`IMM_W{inst_type_I}} & {{20{inst_i[31]}}, inst_i[31:20]} |
                           {`IMM_W{inst_type_S}} & {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]} |
                           {`IMM_W{inst_type_B}} & {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0} |
                           {`IMM_W{inst_type_U}} & {{12{inst_i[31]}}, inst_i[31:12]} |
                           {`IMM_W{inst_type_J}} & {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
 
     assign wreg_en_o   = inst_type_R | inst_type_I | inst_type_U | inst_type_J;
 
     assign rs1_data_o  = (ex_wreg_en_i && ex_wreg_addr_i == rs1_addr_o)   ? ex_wreg_data_i  :
                          (mem_wreg_en_i && mem_wreg_addr_i == rs1_addr_o) ? mem_wreg_data_i :
                          rs1_data_i;
     assign rs2_data_o  = (ex_wreg_en_i && ex_wreg_addr_i == rs2_addr_o)   ? ex_wreg_data_i  :
                          (mem_wreg_en_i && mem_wreg_addr_i == rs2_addr_o) ? mem_wreg_data_i :
                          rs2_data_i;
 
     assign wmem_en_o   = inst_type_S;
     assign rmem_en_o   = inst_type_R;
 
     assign pc_o = {{`INST_ADDR_W{inst_type_B | inst_jal}}} & (pc_i + imm_o) |
                   {{`INST_ADDR_W{inst_jalr}}}              & (pc_i + imm_o + rs1_data_o);
                   
     assign rs_diff_signed = rs1_data_o[`REG_DATA_W-1] ^ rs2_data_o[`REG_DATA_W-1];
     assign rs1_ltu_rs2_exclude_msb = rs1_data_o[`REG_DATA_W-2:0] < rs2_data_o[`REG_DATA_W-2:0];
     assign rs1_ltu_rs2 = rs_diff_signed ? rs2_data_o[`REG_DATA_W-1] : rs1_ltu_rs2_exclude_msb;
     assign rs1_lt_rs2  = rs_diff_signed ? rs1_data_o[`REG_DATA_W-1] : rs1_ltu_rs2_exclude_msb;
     assign rs1_eq_rs2  = rs1_data_o == rs2_data_o;
 
     assign branch_o    = funct3_o[0] ^ (~funct3_o[2] & ~funct3_o[1] & rs1_eq_rs2 |          // 00  beq
                                         funct3_o[2] & ~funct3_o[1] & rs1_lt_rs2 |           // 10  blt
                                         funct3_o[2] & funct3_o[1] & rs1_ltu_rs2);           // 11  bltu
 endmodule //id