module uart_tb;

    // Parameters

    // Ports
    reg  clk = 0;
    reg  rst_n = 0;
    reg  rx_i = 0;
    reg [7:0] tx_data_i;
    reg  tx_en_i = 0;
    wire  tx_busy_o;
    wire tx_o;
    wire  rx_ready_o;
    wire [7:0] rx_data_o;

    uart
        uart_dut (
            .clk (clk ),
            .rst_n (rst_n ),
            .rx_i (rx_i ),
            .tx_data_i (tx_data_i ),
            .tx_en_i (tx_en_i ),
            .tx_busy_o (tx_busy_o ),
            .tx_o (tx_o ),
            .rx_ready_o (rx_ready_o ),
            .rx_data_o  ( rx_data_o)
        );

    initial begin
        begin
            rst_n = 0;
            rx_i = 1;
            tx_en_i = 0;
            tx_data_i = 0;
            #5 rst_n = 1;
            repeat(10) begin
                #1736    rx_i = 0;
                repeat(8) begin
                    #1736 rx_i = $random;
                end
                #1736    rx_i = 1;
            end
            repeat(100) begin
                #100000
                tx_en_i = $random;
                tx_data_i = $random;
            end
        end
    end

    always
        #5  clk = ! clk ;

endmodule
