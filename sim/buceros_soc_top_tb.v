module buceros_soc_top_tb;

  // Parameters

  // Ports
  reg  pin_clk = 0;
  reg  pin_btn_c = 0;
  reg [15:0] pin_sw;
  wire [15:0] pin_led;
  wire [ 7:0] pin_seg;
  wire [ 3:0] pin_seg_sel;

  buceros_soc_top 
  buceros_soc_top_dut (
    .pin_clk (pin_clk ),
    .pin_btn_c (pin_btn_c ),
    .pin_sw (pin_sw ),
    .pin_led (pin_led ),
    .pin_seg (pin_seg ),
    .pin_seg_sel  ( pin_seg_sel)
  );

  initial begin
    begin
      pin_sw = 0;
      pin_btn_c = 0;
      #100 pin_btn_c = 1;
      #100 pin_btn_c = 0;
      #10000;
    $finish;
    end
  end

  always
    #5  pin_clk = ! pin_clk ;

endmodule
