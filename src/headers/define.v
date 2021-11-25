/*
 * Description  : general definition
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:36:53
 * LastEditTime : 2021-11-25 17:25:19
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\headers\define.v
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

`endif // _DEFINE_V