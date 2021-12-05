/*
 * Description  : general definition
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:36:53
 * LastEditTime : 2021-11-28 19:21:38
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
`define InstAddrBus                         31:0

// pc reg
`define PC_RST_ADDR                         32'b0

//ram register
// id
`define Funct3Bus                           2:0
`define Funct7Bus                           6:0
`define ImmBus                              31:0
`define OpcodeBus                           6:0
`define Enable                              1
`define Disable                             0
`define NrstEnable                          0
`define NrstDisable                         1
`define ZeroWord                            32'b0
`define U_Type_Plus                         7'b0110111
`define U_Type                              7'b0010111
`define J_Type                              7'b1101111
`define I_Type_Plus                         7'b1100111
`define B_Type                              7'b1100011
`define I_Type1                             7'b0000011
`define S_Type                              7'b0100011
`define I_Type2                             7'b0010011
`define R_Type                              7'b0110011
`define I_Type3                             7'b0001111
`define I_Type4                             7'b1110011
`endif // _DEFINE_V'b