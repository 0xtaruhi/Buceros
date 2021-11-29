/*
 * Description  : uart module
 * Author       : Zhengyi Zhang
 * Date         : 2021-11-28 13:23:34
 * LastEditTime : 2021-11-29 22:05:11
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\src\perips\uart.v
 */
`include "../headers/buceros_header.v"
module uart (
    input  wire       clk,
    input  wire       rst_n,

    input  wire       rx_i,
    input  wire [7:0] tx_data_i,
    input  wire       tx_en_i,

    output wire       tx_busy_o,
    output reg        tx_o,
    output wire       rx_ready_o,         // HIGH when rx_data_o is ready     
    output wire [7:0] rx_data_o
);

    localparam RX_STATE_IDLE  = 4'b1111;
    localparam RX_STATE_START = 4'b1000;
    localparam RX_STATE_BIT0  = 4'b0000;
    localparam RX_STATE_BIT1  = 4'b0001;
    localparam RX_STATE_BIT2  = 4'b0011;
    localparam RX_STATE_BIT3  = 4'b0010;
    localparam RX_STATE_BIT4  = 4'b0110;
    localparam RX_STATE_BIT5  = 4'b0111;
    localparam RX_STATE_BIT6  = 4'b0101;
    localparam RX_STATE_BIT7  = 4'b0100;        
    localparam RX_STATE_STOP  = 4'b1100;

    localparam TX_STATE_IDLE  = 4'b1111;
    localparam TX_STATE_START = 4'b1000;
    localparam TX_STATE_BIT0  = 4'b0000;
    localparam TX_STATE_BIT1  = 4'b0001;
    localparam TX_STATE_BIT2  = 4'b0011;
    localparam TX_STATE_BIT3  = 4'b0010;
    localparam TX_STATE_BIT4  = 4'b0110;
    localparam TX_STATE_BIT5  = 4'b0111;
    localparam TX_STATE_BIT6  = 4'b0101;
    localparam TX_STATE_BIT7  = 4'b0100;
    localparam TX_STATE_STOP  = 4'b1100;

    reg  [        1:0] rx_edge_detect;
    reg  [        7:0] rx_data;
    wire               rx_negedge;
    reg  [`UartDivBus] rx_div_cnt;
    reg  [        3:0] rx_state;
    reg  [        3:0] rx_state_nxt;
    wire               rx_div_cnt_max;
    wire               rx_div_cnt_half;
    wire               tx_busy;
    reg  [        7:0] tx_data;
    reg  [        3:0] tx_state;
    reg  [        3:0] tx_state_nxt;
    reg  [`UartDivBus] tx_div_cnt;
    wire               tx_div_cnt_max;

    /******************************rx********************************/
    // detect the edge of start bit
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            rx_edge_detect <= 2'b0;
        end else begin
            rx_edge_detect <= {rx_edge_detect[0], rx_i};
        end
    end

    assign rx_negedge = ~rx_edge_detect[0] & rx_edge_detect[1];
    assign rx_div_cnt_max  = (rx_div_cnt == `UART_DIV_CNT_MAX - 1);
    assign rx_div_cnt_half = (rx_div_cnt == `UART_DIV_CNT_HALF - 1);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            rx_state <= RX_STATE_IDLE;
        end else begin
            rx_state <= rx_state_nxt;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n | (&rx_state)) begin                  // state is RX_STATE_IDLE
            rx_div_cnt <= 0;
        end else begin
            rx_div_cnt <= rx_div_cnt_max ? 0 : (rx_div_cnt + 1);
        end
    end

    always @(*) begin
        if(rx_div_cnt_max) begin
            case(rx_state)
                RX_STATE_START: rx_state_nxt = RX_STATE_BIT0;
                RX_STATE_BIT0 : rx_state_nxt = RX_STATE_BIT1;
                RX_STATE_BIT1 : rx_state_nxt = RX_STATE_BIT2;
                RX_STATE_BIT2 : rx_state_nxt = RX_STATE_BIT3;
                RX_STATE_BIT3 : rx_state_nxt = RX_STATE_BIT4;
                RX_STATE_BIT4 : rx_state_nxt = RX_STATE_BIT5;
                RX_STATE_BIT5 : rx_state_nxt = RX_STATE_BIT6;
                RX_STATE_BIT6 : rx_state_nxt = RX_STATE_BIT7;
                RX_STATE_BIT7 : rx_state_nxt = RX_STATE_STOP;
                RX_STATE_STOP : rx_state_nxt = RX_STATE_IDLE;
                default       : rx_state_nxt = RX_STATE_IDLE;
            endcase
        end else begin
            rx_state_nxt = (rx_state == RX_STATE_IDLE) && rx_negedge ? RX_STATE_START: rx_state;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            rx_data <= 0;
        end else if(rx_div_cnt_half & ~rx_state[3]) begin
            rx_data <= {rx_i, rx_data[7:1]};
        end else begin
            rx_data <= rx_data;
        end
    end

    assign rx_data_o = rx_data;
    assign rx_ready_o = rx_state == RX_STATE_STOP;

    /******************************tx********************************/

    assign tx_div_cnt_max = (tx_div_cnt == `UART_DIV_CNT_MAX - 1);
    assign tx_busy        = ~(tx_state == TX_STATE_IDLE);
    assign tx_busy_o      = tx_busy;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            tx_data <= 0;
        end else if(tx_en_i & ~tx_busy) begin
            tx_data <= tx_data_i;
        end else begin
            tx_data <= tx_data;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n || (tx_state == TX_STATE_IDLE)) begin
            tx_div_cnt <= 0;
        end else begin
            tx_div_cnt <= tx_div_cnt_max ? 0 : (tx_div_cnt + 1);
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            tx_state <= TX_STATE_IDLE;
        end else begin
            tx_state <= tx_state_nxt;
        end
    end

    always @(*) begin
        if(tx_div_cnt_max) begin
            case(tx_state)
                TX_STATE_START: tx_state_nxt = TX_STATE_BIT0;
                TX_STATE_BIT0 : tx_state_nxt = TX_STATE_BIT1;
                TX_STATE_BIT1 : tx_state_nxt = TX_STATE_BIT2;
                TX_STATE_BIT2 : tx_state_nxt = TX_STATE_BIT3;
                TX_STATE_BIT3 : tx_state_nxt = TX_STATE_BIT4;
                TX_STATE_BIT4 : tx_state_nxt = TX_STATE_BIT5;
                TX_STATE_BIT5 : tx_state_nxt = TX_STATE_BIT6;
                TX_STATE_BIT6 : tx_state_nxt = TX_STATE_BIT7;
                TX_STATE_BIT7 : tx_state_nxt = TX_STATE_STOP;
                TX_STATE_STOP : tx_state_nxt = TX_STATE_IDLE;
                default       : tx_state_nxt = TX_STATE_IDLE;
            endcase
        end else begin
            tx_state_nxt = (tx_en_i & ~tx_busy) ? TX_STATE_START: tx_state;
        end
    end

    always @(*) begin
        case(tx_state)
            TX_STATE_IDLE : tx_o = 1;
            TX_STATE_START: tx_o = 0;
            TX_STATE_BIT0 : tx_o = tx_data[0];
            TX_STATE_BIT1 : tx_o = tx_data[1];
            TX_STATE_BIT2 : tx_o = tx_data[2];
            TX_STATE_BIT3 : tx_o = tx_data[3];
            TX_STATE_BIT4 : tx_o = tx_data[4];
            TX_STATE_BIT5 : tx_o = tx_data[5];
            TX_STATE_BIT6 : tx_o = tx_data[6];
            TX_STATE_BIT7 : tx_o = tx_data[7];
            TX_STATE_STOP : tx_o = 1;
            default       : tx_o = 1;
        endcase
    end

endmodule //uart