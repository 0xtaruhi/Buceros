`ifndef _PERIPS_HEADER_V_
`define _PERIPS_HEADER_V_

`define ROM_WIDTH                           32
`define RomBus                              31:0
`define RomAddrBus                          31:0

`define UART_BAUD_RATE                      115200
`define UART_DIV_CNT_MAX                    10'd868         // 115200
`define UART_DIV_CNT_HALF                   10'd434         // 115200
`define UART_DIV_W                          10
`define UartDivBus                          9:0

`endif