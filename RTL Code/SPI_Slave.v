module SPI_Slave (MOSI , MISO , SS_n , clk , rst_n , rx_data , rx_valid , tx_data , tx_valid );
// define parameters to used in states  
parameter   IDLE     = 3'b000 ;
parameter  CHK_CMD   = 3'b001 ; 
parameter  WRITE     = 3'b010 ;
parameter  READ_ADD  = 3'b011 ;
parameter  READ_DATA = 3'b100 ;
// define all ports 
input  clk , rst_n , SS_n ;
input  MOSI , tx_valid ;
input  [7:0] tx_data ; 
output reg MISO , rx_valid ;
output reg [9:0] rx_data ; 
// define internal signal in the design 
  (*fsm_encoding = "sequential"*) 
reg [2:0] cs , ns ; 
reg read_addr_recieved ;
reg [3:0] counter ;
// next state Logic 
always @(*) begin
    case (cs)  
       IDLE    :    if (SS_n == 1'b0 ) begin 
                         ns = CHK_CMD ; 
                    end 
                    else begin 
                         ns = IDLE ; 
                    end

       CHK_CMD :    if (SS_n) begin 
                          ns = IDLE ;
                    end
                    else begin 
                        if (~MOSI) begin 
                             ns = WRITE ;
                        end
                        else begin 
                             if (~read_addr_recieved ) begin 
                                  ns = READ_ADD ;
                             end 
                             else begin 
                                  ns = READ_DATA ;  
                             end 
                        end      
                    end  

       WRITE   :    if (SS_n) begin 
                         ns = IDLE ;
                    end
                    else begin 
                         ns = WRITE ;
                    end              

       READ_ADD:    if (SS_n) begin 
                         ns = IDLE ; 
                    end
                    else begin 
                         ns = READ_ADD ; 
                    end                 
       
       READ_DATA :  if (SS_n) begin 
                         ns = IDLE ;  
                    end 
                    else begin 
                         ns = READ_DATA ;
                    end 
    endcase  
end
// state memory 
always @(posedge clk ) begin
      if (~ rst_n) begin 
            cs <= IDLE ;
      end 
      else begin 
            cs <= ns ;
      end 
end
// output Logic 
always @(posedge clk ) begin
    if (~rst_n) begin 
        rx_data <= 0 ; 
        rx_valid <= 0 ;
        counter <= 0 ;
        MISO <= 0 ; 
        read_addr_recieved <= 0 ; 
    end 
    else begin 
    case (cs)
       IDLE    :   begin 
                        counter <= 0 ; 
                        MISO <= 0 ;
                        rx_valid <= 0 ;
                   end 
       CHK_CMD :   begin 
                        counter <= 0 ; 
                        rx_valid <= 0  ;
                        MISO <= 0 ; 
                   end  
       WRITE   :   begin 
                       if (counter <= 9 ) begin 
                       rx_data <= {rx_data[8:0] , MOSI }  ;
                       counter <= counter + 1 ; 
                       rx_valid <= 0 ; 
                       end     
                       if (counter >= 9) begin 
                          rx_valid <= 1 ;  
                       end 
                   end 
       READ_ADD :  begin 
                         if (counter <= 9 ) begin 
                         rx_data <= {rx_data[8:0] , MOSI } ;
                         counter <= counter + 1 ; 
                         read_addr_recieved <= 1 ; 
                         rx_valid <=  0 ; 
                   end  
                   if (counter >= 9 ) begin 
                         rx_valid <= 1 ; 
                   end 
                   end 
      READ_DATA :  begin 
                        if (counter >= 3 && rx_valid == 1'b1) begin 
                             MISO <= tx_data [counter-3 ] ; 
                             counter <= counter - 1 ;  
                        end 
                        else begin 
                        if (counter <= 9 ) begin 
                             rx_data <= {rx_data[8:0] , MOSI } ;
                             counter <= counter + 1 ; 
                        end 
                        if (counter >= 9) begin 
                             rx_valid <= 1 ;
                             read_addr_recieved <= 0 ;
                        end 
                        end 
                  end   
    endcase
    end 
end 
endmodule