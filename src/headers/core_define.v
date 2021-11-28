/*
 * Description  : general definition
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:36:53
 * LastEditTime : 2021-11-28 15:33:10
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\headers\core_define.v
 */

`include "settings.v"
`ifndef _DEFINE_V_
`define _DEFINE_V_

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

// id
`define Funct3Bus                           2:0
`define Funct7Bus                           6:0
`define ImmBus                              31:0
`define OpcodeBus                           6:0

`endif // _DEFINE_V