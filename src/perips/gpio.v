`include "../headers/buceros_header.v"
module gpio (
    input  wire               clk,
    input  wire               rst_n,
    input  wire               en_i,

    input  wire               r_en_i,
    input  wire [`MemAddrBus] addr_i,
    input  wire               w_en_i,
    input  wire [`MemDataBus] w_data_i,
    input  wire [       15:0] pin_sw_i,

    output wire [`MemDataBus] r_data_o,
    output wire [        7:0] pin_seg_o,
    output wire [        3:0] pin_seg_sel_o,
    output wire [       15:0] pin_led_o
);

    reg [ 7:0] seg;
    reg [ 3:0] seg_sel;           // HIGH when lightened
    reg [15:0] led;               // HIGH when lightened

    wire       r_en;
    wire       w_en;
    wire       r_seg;
    wire       r_seg_sel;
    wire       r_led;
    wire       r_sw;
    wire       w_seg;
    wire       w_seg_sel;
    wire       w_led;
    wire       led_en;
    wire       seg_en;
    wire       seg_sel_en;
    wire       sw_en;

    assign r_en = en_i & r_en_i;
    assign w_en = en_i & w_en_i;
    
    // led 0x4000_0000 - 0x4000_0001
    assign led_en     = ~addr_i[28] & ~addr_i[3] & ~addr_i[2];
    assign r_led      = r_en & led_en;
    assign w_led      = w_en & led_en;
    // seg disp 0x4000_0004 - 0x4000_0005
    assign seg_en = ~addr_i[28] & ~addr_i[3] & addr_i[2];
    assign r_seg = r_en & seg_en;
    assign w_seg = w_en & seg_en;
    // seg sel 0x4000_0008
    assign seg_sel_en = ~addr_i[28] & addr_i[3];
    assign r_seg_sel  = r_en & seg_sel_en;
    assign w_seg_sel  = w_en & seg_sel_en;
    // sw 0x5000_0000 - 0x5000_0001
    assign sw_en      = addr_i[28];
    assign r_sw       = r_en & sw_en;
    assign w_sw       = w_en & sw_en;

    assign pin_seg_sel_o = ~seg_sel;
    assign pin_seg_o     = seg;
    assign pin_led_o     = led;

    assign r_data_o = {16'b0, {16{    r_led}} & led}     |
                      {24'b0, { 8{    r_seg}} & seg}     |
                      {28'b0, { 4{r_seg_sel}} & seg_sel} |
                      {16'b0, {16{     r_sw}} & pin_sw_i};
                      
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            seg     <= 8'b0;
            seg_sel <= 4'b0;
            led     <= 16'b0;
        end else begin
            seg     <= w_seg     ? w_data_i[ 7:0] : seg;
            seg_sel <= w_seg_sel ? w_data_i[ 3:0] : seg_sel;
            led     <= w_led     ? w_data_i[15:0] : led;
        end
    end

endmodule //gpio