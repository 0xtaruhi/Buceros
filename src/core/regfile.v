/*
 * Description  : Register
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:40:59
 * LastEditTime : 2021-12-15 14:05:25
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

    wire [`RegDataBus] regfile   [0:`REG_NUM-1];
    reg  [`RegDataBus] regfile_r [1:`REG_NUM-1];
    wire               r1_x0;
    wire               r2_x0;

    assign r1_x0 = r_addr1_i == `REG_ADDR_W'b0;
    assign r2_x0 = r_addr2_i == `REG_ADDR_W'b0;

    assign r_data1_o = {`REG_DATA_W{~r1_x0}} & ((w_en_i && (r_addr1_i == w_addr_i)) ? w_data_i : regfile[r_addr1_i]);
    assign r_data2_o = {`REG_DATA_W{~r2_x0}} & ((w_en_i && (r_addr2_i == w_addr_i)) ? w_data_i : regfile[r_addr2_i]);

    genvar reg_idx;
    generate
        for(reg_idx=1;reg_idx<`REG_NUM;reg_idx=reg_idx+1) begin: loop_regfile
            always @(posedge clk or negedge rst_n) begin
                if(~rst_n) begin
                    regfile_r[reg_idx] <= 0;
                end else begin
                    if(w_en_i && w_addr_i == reg_idx) begin
                        regfile_r[reg_idx] <= w_data_i;
                    end else begin
                        regfile_r[reg_idx] <= regfile_r[reg_idx];
                    end
                end
            end
            assign regfile[reg_idx] = regfile_r[reg_idx];
        end
    endgenerate

    assign regfile[0] = 32'b0;

endmodule //regfile