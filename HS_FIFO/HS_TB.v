
`timescale 1ns/1ps

module HS__FIFO_TB ();
 
  reg        RxDDRClkHS,RST;
  reg        Enable_HS_RX,HS_RX_DATA;
  wire       RxByteClkHS;
  wire       RxActiveHS,RxSyncHS,RxValidHS;
  wire [7:0] RxDataHS;
  
  
  parameter CLK_PER = 0.666;
  
  always #(CLK_PER/2) RxDDRClkHS = ~RxDDRClkHS;
  
  TOP_HS_FIFO DUT(
  .RxDDRClkHS(RxDDRClkHS),
  .RST(RST),
  .Enable_HS_RX(Enable_HS_RX),
  .HS_RX_DATA(HS_RX_DATA),
  .RxByteClkHS(RxByteClkHS),
  .RxActiveHS(RxActiveHS),
  .RxSyncHS(RxSyncHS),
  .RxValidHS(RxValidHS),
  .RxDataHS(RxDataHS)
  );
  
  
  initial
  begin
    
    $dumpfile("HS_TB.vcd");
    $dumpvars;
    
   
    
    RST = 'd1;
    #(CLK_PER/2)
    RST = 'd0;
    #(CLK_PER/2)
    RST = 'd1;
	
     RxDDRClkHS = 'd0;
    Enable_HS_RX = 'd1;
    HS_RX_DATA = 1'd0;
    
    #(CLK_PER/4)
    
	//entry command
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
	
    //206
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    //15
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    //176
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
	
	HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
	
	HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
	
	HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
	
	HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    
	
	
	HS_RX_DATA = 1'd0;
	#64; // t_trail
	Enable_HS_RX =0;
	#10
	// wrong entry command 
	Enable_HS_RX =1;
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd0;
    #(CLK_PER/2)
    HS_RX_DATA = 1'd1;
    #(CLK_PER/2)
	#30
	/*
	what happens next : is outside fsm close it or it waits till lp11 is come agaian
	*/
	$stop;
    
  end
  
endmodule
