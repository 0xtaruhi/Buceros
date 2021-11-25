/*
 * Description  : Register
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-25 16:40:59
 * LastEditTime : 2021-11-25 17:53:45
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\core\regfile.v
 */
`include "../headers/define.v"

module regfile (
    input  wire               clk,
    input  wire               rst_n,

    // jtag
    `ifdef JTAG_ENABLE
    input  wire [`RegAddrBus] jtag_addr_i,
    input  wire               w_jtag_en_i,
    input  wire [`RegDataBus] w_jtag_data_i,
    output wire [`RegDataBus] r_jtag_data_o,
    `endif

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
    
    `ifdef JTAG_ENABLE
    assign r_jtag_data_o = regfile[jtag_addr_i];
    `endif
    
    
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
                    `ifdef JTAG_ENABLE
                    end else if(w_jtag_en_i && jtag_addr_i == reg_idx) begin
                        regfile[reg_idx] <= w_jtag_data_i;
                    `endif
                    end else begin
                        regfile[reg_idx] <= regfile[reg_idx];
                    end
                end
            end
        end
    endgenerate

endmodule //regfile