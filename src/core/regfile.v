/*
 * Description  : Register
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:40:59
 * LastEditTime : 2021-11-28 15:34:08
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\core\regfile.v
 */
`include "../headers/buceros_header.v"

module regfile (
    input  wire               clk,
    input  wire               rst_n,
    input  wire [`RegAddrBus] r_addr1_i,
    input  wire [`RegAddrBus] r_addr2_i,
    input  wire               w_en_i,
    input  wire [`RegAddrBus] w_addr_i,
    input  wire [`RegDataBus] w_data_i,

    output wire [`RegDataBus] r_data1_o,
    output wire [`RegDataBus] r_data2_o
);

    reg [`RegDataBus] regfile [`REG_NUM-1:0];

    assign r_data1_o = (r_addr1_i == w_addr_i) ? w_data_i : regfile[r_addr1_i];
    assign r_data2_o = (r_addr2_i == w_addr_i) ? w_data_i : regfile[r_addr2_i];
    always @(*) begin
        regfile[0] = 0;             // x0 permanently be 0
    end

    genvar reg_idx;
    generate
        for(reg_idx=1;reg_idx<`REG_NUM;reg_idx=reg_idx+1) begin: loop_regfile

            always @(posedge clk or negedge rst_n) begin
                if(~rst_n) begin
                    regfile[reg_idx] <= 0;
                end else begin
                    if(w_en_i && w_addr_i == reg_idx) begin
                        regfile[reg_idx] <= w_data_i;
                    end else begin
                        regfile[reg_idx] <= regfile[reg_idx];
                    end
                end
            end
        end
    endgenerate

endmodule //regfile