/*
 * Description  : Bus Interface Unit
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 17:10:47
 * LastEditTime : 2021-12-16 15:36:29
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\perips\biu.v
 */
`include "../headers/buceros_header.v"
 module biu (
    input  wire [`MemAddrBus] mem_addr_i,
    input  wire [   `WordBus] wmem_data_i,
    input  wire [`MemDataBus] ram_data_i,
    input  wire [`MemDataBus] gpio_data_i,

    output wire               ram_en_o,
    output wire               gpio_en_o,
    output wire [`MemDataBus] rmem_data_o
);

    assign ram_en_o  = mem_addr_i[31:29] == 3'b001;
    assign gpio_en_o = mem_addr_i[31:29] == 3'b010;

    assign rmem_data_o = {`MEM_DATA_W{ram_en_o }} & ram_data_i |
                         {`MEM_DATA_W{gpio_en_o}} & gpio_data_i;

    assign wmem_data_o = wmem_data_i;

endmodule //biu