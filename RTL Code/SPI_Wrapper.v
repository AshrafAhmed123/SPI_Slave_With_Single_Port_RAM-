module SPI_Wrapper (MOSI , MISO , SS_n , clk , rst_n);
// define all ports 
input   clk , rst_n ; 
input   MOSI , SS_n ;
output  MISO ; 
// define internal signals 
wire [9:0] rx_data ;
wire rx_valid , tx_valid ; 
wire [7:0] tx_data ; 
// instantiate the first design (SPI Slave) 
SPI_Slave Block_1 (.clk(clk) , .SS_n(SS_n) , .rst_n(rst_n) , .MISO(MISO) , .MOSI(MOSI) , .rx_data(rx_data)
, .rx_valid(rx_valid) , .tx_data(tx_data) , .tx_valid(tx_valid) ) ; 
// instantiate the secound design (RAM) 
spr_sync  Block_2 (.clk(clk) , .rst_n(rst_n) , .din(rx_data) , .rx_valid(rx_valid) , .dout(tx_data) , .tx_valid(tx_valid)) ;
    
endmodule