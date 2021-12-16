/*
 * Description  : general definition
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:36:53
 * LastEditTime : 2021-12-15 14:19:03
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\headers\core_define.v
 */

`include "settings.v"
`ifndef _CORE_DEFINE_V_
`define _CORE_DEFINE_V_

`ifdef ARCH_RV32
    `define REG_DATA_W                      32
    `define RegDataBus                      31:0
`elsif ARCH_RV64
    `define REG_DATA_W                      64
    `define RegDataBus                      63:0
`endif // ARCH

`define REG_ADDR_W                          5
`define RegAddrBus                          4:0
`define REG_NUM                             32  

`define INST_W                              32
`define InstBus                             31:0
`define InstAddrBus                         31:0
`define INST_ADDR_W                         32

`define ZERO_WORD                            32'h00000000

// pc reg
`define PC_RST_ADDR                         32'b0

//ram register
// id
`define Funct3Bus                           2:0
`define FUNCT3_W                            3
`define FUNCT7_W                            7
`define Funct7Bus                           6:0
`define IMM_W                               32
`define ImmBus                              31:0
`define OpcodeBus                           6:0
`define OPCODE_W                            7
`define NOP                                 32'h00100013

// ex
`define INST_LUI                            7'b0110111
`define INST_AUIPC                          7'b0010111
`define INST_JAL                            7'b1101111
`define INST_JALR                           7'b1100111
`define INST_B_TYPE                         7'b1100011
`define INST_LOAD                           7'b0000011
`define INST_STORE                          7'b0100011
`define INST_ARITH_IMM                      7'b0010011 // arithmetic with immediate
`define INST_ARITH                          7'b0110011
`define INST_FENCE                          7'b0001111
`define INST_ENV                            7'b1110011
`define INST_SUM                            3'b000 // ADDI      and ADD,SUB
`define INST_SL                             3'b001 // SLLI      and SLL
`define INST_SLT                            3'b010 // SLTI      and SLT
`define INST_SLTU                           3'b011 // SLTIU     and SLTU
`define INST_XOR                            3'b100 // XORI      and XOR
`define INST_SR                             3'b101 // SRLI,SRAI and SRL,SRA
`define INST_OR                             3'b110 // ORI       and OR
`define INST_AND                            3'b111 // ANDI      and AND

// mem
`define INST_BYTE                           3'b000
`define INST_HALF_WORD                      3'b001
`define INST_WORD                           3'b010
`define INST_BYTE_U                         3'b100
`define INST_HALF_WORD_U                    3'b101

//mem_wb
`define StallBus                            0:0
`endif // _DEFINE_V

