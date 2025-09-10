module SPI_Wrapper_tb ();
reg    clk , rst_n ; 
reg    MOSI , SS_n ;
wire   MISO ;
// instantiate the design to  under test 
SPI_Wrapper DUT (.clk(clk) , .rst_n(rst_n) , .MOSI(MOSI) , .SS_n(SS_n) , .MISO(MISO)) ; 
// Clock Generation
initial begin
     clk = 0 ; 
     forever begin
        #1  clk = ~ clk ;  
     end
end  
// Stimulus Generation 
initial begin
    // Load initial Value in RAM
    $readmemb ("mem.dat" , DUT.Block_2.mem);
    $display ("Start Simulation ");
    // check reset 
    rst_n = 1'b0 ; 
    MOSI =  1'b0 ;
    SS_n = 1'b0 ;
    @(negedge clk ) ; 
    rst_n = 1'b1 ; 
     //----------------------------------------------------------------------//
    //----------------------------- Write Address---------------------------// 
    repeat (2)  @(negedge clk) ;
    //-----------sent 2'b00 to rx_data[9:8] bits  to select the Write address ------/// 
    MOSI = 0 ; 
    repeat (2) @(negedge clk ) ; 
    //---------- sent the address ------ // 
    MOSI = 1'b1 ;
    repeat (7)  @(negedge clk ) ; 
    MOSI = 1'b0 ; 
    @(negedge clk ) ; 
    //------------------------------------//
    SS_n = 1'b1 ; 
    repeat (2)  @(negedge clk) ;  
    $display("Write address Operation Sucessfully");
     //----------------------------------------------------------------------//
    //----------------------------- Write Data------------------------------// 
    SS_n = 1'b0 ;
    @(negedge clk ) ; 
    SS_n = 1'b0 ;
    MOSI = 1'b0 ; 
    @(negedge clk ) ;
    MOSI = 1'b0 ;
    @(negedge clk ) ;
    MOSI = 1'b1 ;
    @(negedge clk ) ;
    repeat (8) begin 
      MOSI = $random ;
      @(negedge clk ) ; 
    end 
    SS_n = 1'b1 ;
    repeat (2) @(negedge clk) ;
    $display("Write data Operation Sucessfully");
     //-------------------------------------------------------------------------//
    //----------------------------- Read Address ------------------------------// 
    SS_n = 1'b0 ; 
    @(negedge clk ) ; 
    MOSI = 1'b1 ; 
    @(negedge clk ) ;
    MOSI = 1'b1 ;
    @(negedge clk ) ; 
    MOSI = 1'b0 ; 
    @(negedge clk ) ;
    //---------- sent the address ------ // 
    MOSI = 1'b1 ;
    repeat (7)  @(negedge clk ) ; 
    MOSI = 1'b0 ; 
    @(negedge clk ) ; 
    //------------------------------------//
    SS_n = 1'b1 ; 
    repeat (2) @(negedge clk ) ;
    $display("Read address Operation Sucessfully");
     //-------------------------------------------------------------------------//
    //----------------------------- Read Data  --------------------------------// 
    SS_n = 1'b0 ; 
    @(negedge clk) ; 
    MOSI = 1'b1 ;
    @(negedge clk ) ; 
    repeat (20) begin 
     @(negedge clk ) ; 
    end 
    SS_n = 1 ;  
    repeat (2) @(negedge clk ) ; 
    $display("Read Data Operation Sucessfully");
    $display("The design is done successfully") ; 
    $stop ; 
end
// Generate monitor 
initial begin
   $monitor ("MOSI= %b , MISO =%b , SS_n =%b , counter=%d" , MOSI , MISO , SS_n , DUT.Block_1.counter ) ;
end
endmodule