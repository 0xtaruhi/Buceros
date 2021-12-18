`include "../headers/buceros_header.v"
module buceros_soc_top (
    input  wire pin_clk,
    input  wire pin_btn_c,
    input  wire [15:0] pin_sw,

    output wire [15:0] pin_led,
    output wire [ 7:0] pin_seg,
    output wire [ 3:0] pin_seg_sel
);

    wire               rst_n;
    wire               clk;
    wire [   `WordBus] inst;
    wire [   `WordBus] rmem_data;
    wire               wmem_en;
    wire               rmem_en;
    wire [   `WordBus] wmem_data;
    wire [`MemAddrBus] rom_addr;
    wire [`MemAddrBus] mem_addr;
    wire [   `WordBus] ram_data;
    wire [   `WordBus] gpio_data;
    wire               ram_en;
    wire               gpio_en;

    assign rst_n = ~pin_btn_c;

    core_top inst_core_top(
        .clk(clk),
        .rst_n(rst_n),
        .io_enter(1'b0),
        .inst_i(inst),
        .rmem_data_i(rmem_data),
        .wmem_en_o(wmem_en),
        .rmem_en_o(rmem_en),
        .wmem_data_o(wmem_data),
        .rom_addr_o(rom_addr),
        .mem_addr_o(mem_addr)
    );

    rom inst_rom(
        .clk(clk),
        .rst_n(rst_n),
        .r_addr_i(rom_addr),
        .w_en_i(1'b0),
        .w_addr_i(32'b0),
        .w_data_i(32'b0),
        .w_sel_i(4'b0),
        .r_data_o(inst)
    );

    biu inst_biu(
        .mem_addr_i(mem_addr),
        .wmem_data_i(wmem_data),
        .ram_data_i(ram_data),
        .gpio_data_i(gpio_data),
        .ram_en_o(ram_en),
        .gpio_en_o(gpio_en),
        .rmem_data_o(rmem_data)
    );

    gpio inst_gpio(
        .clk(clk),
        .rst_n(rst_n),
        .en_i(gpio_en),
        .r_en_i(rmem_en),
        .addr_i(mem_addr),
        .w_en_i(wmem_en),
        .w_data_i(wmem_data),
        .pin_sw_i(pin_sw),
        .r_data_o(gpio_data),
        .pin_seg_o(pin_seg),
        .pin_seg_sel_o(pin_seg_sel),
        .pin_led_o(pin_led)
    );

    ram inst_ram(
        .clk(clk),
        .rst_n(rst_n),
        .addr_i(mem_addr),
        .w_en_i(wmem_en),
        .w_data_i(wmem_data),
        .w_sel_i(4'b1111),
        .r_data_o(ram_data)
    );

//    assign clk = pin_clk;
    cpu_clk_div inst_cpu_clk_div(
        .pin_clk(pin_clk),
        .cpu_clk(clk)
    );

endmodule //buceros_soc_top