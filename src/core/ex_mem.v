/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:40:19
 * LastEditTime : 2021-12-12 11:38:41
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\core\ex_mem.v
 */

 `include "../headers/buceros_header.v"

 module ex_mem (
     input  wire clk,
     input  wire rst_n,
     input  wire hold_i,

     input  wire               ex_wmem_en_i,
     input  wire               ex_rmem_en_i,
     input  wire [`MemAddrBus] ex_mem_addr_i,
     input  wire [ `Funct3Bus] ex_funct3_i,
     input  wire               ex_wreg_en_i,
     input  wire [`RegAddrBus] ex_wreg_addr_i,
     input  wire [`RegDataBus] ex_wreg_data_i,

     output wire               mem_wmem_en_o,
     output wire               mem_rmem_en_o,
     output wire [`MemAddrBus] mem_mem_addr_o,
     output wire [ `Funct3Bus] mem_funct3_o,
     output wire               mem_wreg_en_o,
     output wire [`RegAddrBus] mem_wreg_addr_o,
     output wire [`RegDataBus] mem_wreg_data_o
 );

    gen_dffr #(.WIDTH(       1'b1)) dff_wmem_en  (clk, rst_n, hold_i, ex_wmem_en_i, mem_wmem_en_o);
    gen_dffr #(.WIDTH(       1'b1)) dff_rmem_en  (clk, rst_n, hold_i, ex_rmem_en_i, mem_rmem_en_o);
    gen_dffr #(.WIDTH(`MEM_ADDR_W)) dff_mem_addr (clk, rst_n, hold_i, ex_mem_addr_i, mem_mem_addr_o);
    gen_dffr #(.WIDTH(  `FUNCT3_W)) dff_funct3   (clk, rst_n, hold_i, ex_funct3_i, mem_funct3_o);
    gen_dffr #(.WIDTH(       1'b1)) dff_wreg_en  (clk, rst_n, hold_i, ex_wreg_en_i, mem_wreg_en_o);
    gen_dffr #(.WIDTH(`REG_ADDR_W)) dff_wreg_addr(clk, rst_n, hold_i, ex_wreg_addr_i, mem_wreg_addr_o);
    gen_dffr #(.WIDTH(`REG_DATA_W)) dff_wreg_data(clk, rst_n, hold_i, ex_wreg_data_i, mem_wreg_data_o);

 endmodule //ex_mem