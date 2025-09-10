module spr_sync (din , rx_valid , dout , tx_valid , clk , rst_n );
// define all ports 
parameter MEM_DEPTH = 256 ;
parameter ADDR_SIZE = 8 ; 
input [9:0] din ;
input clk , rst_n , rx_valid  ; 
output reg [7:0] dout ;
output reg tx_valid ; 
// create internal signal (RAM) 
reg [ADDR_SIZE-1 : 0] mem [MEM_DEPTH-1:0] ; 
reg [ADDR_SIZE-1 : 0] addr ;
// design using Behavioral Moduling 
always @(posedge clk) begin
      if (~rst_n) begin 
           dout <= 8'd0 ;
           tx_valid <= 1'b0 ; 
      end
      else begin 
           if (rx_valid) begin     
                 case (din[9:8]) 
                     2'b00 :  addr <= din[7:0] ;        // write address 
                     2'b01 :  mem[addr] <= din[7:0] ;   // write data 
                     2'b10 :  addr <= din[7:0] ;        // read address 
                     2'b11 :  begin 
                                 dout <= mem[addr] ;       // read data 
                                 tx_valid <= 1'b1 ;      
                              end  
                 endcase 
           end 
      end 
end
endmodule