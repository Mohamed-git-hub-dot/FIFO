module CTRL_UNIT(
  input      RxDDRClkHS,RxByteClkHS,RST,
  input      HS_RX_DATA,
  input      Enable_HS_RX,RX_SYNC_HS,sync_error,FLAG_DESERIALIZE,
  input      trailer_done , break_trailer, /*Compartor*/
  output reg ENABLE_DESERIALIZE,ENABLE_SYNC_DETECTOR, comparator_enable_o,
  output reg RxActiveHS,RxValidHS ,
  output wire RxSyncHS
  );
  
  localparam [2:0] IDLE       = 'd0,
                   WAIT_SYNC  = 'd1,
                   HS_0       = 'd2,
                   HS_1       = 'd3,
                   EOT        = 'd4;
                   
                   
  localparam [2:0] ZERO       = 'd0,
                   ONE        = 'd1,
                   TWO        = 'd2,
                   THREE      = 'd3,
                   FOUR       = 'd4,
                   FIVE       = 'd5,
                   SIX        = 'd6,
                   SEVEN      = 'd7;
                   
                   
 reg [2:0] curr_state,next_state;
 
 reg [2:0] curr_CNTR,next_CNTR;
 
 reg [1:0] DATA;
 
 reg       comparator_enable;
 
 reg       RxValidHS_comb;
 
 reg       flag_1;
 
 reg       RxActiveHS_c;
 
 wire      E1,E2;
  reg       flag, rcv_flop  , pls_flop;
 
 

 always @(posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST)
 begin
   if(!RST)
     begin
       curr_state <= IDLE;
       curr_CNTR  <= 'd0;
     end
   else
     begin
       curr_state <= next_state;
       curr_CNTR  <= next_CNTR; 
     end
 end
 
 
 always @(*)
 begin
   
   //ENABLE_DESERIALIZE   = 'd0;
   //ENABLE_SYNC_DETECTOR = 'd0;
   //RxValidHS_comb     = 'd0;
 //  RxActiveHS_c       = 'd0;
  // comparator_enable    = 'd0;
   if(Enable_HS_RX==1)
   begin
	case(curr_state)
		
		IDLE:
		begin
		RxActiveHS_c       = 'd0;
		ENABLE_DESERIALIZE   = 'd0;
		ENABLE_SYNC_DETECTOR = 'd0;
		RxValidHS_comb     = 'd0;
		comparator_enable    = 'd0;
		
		if(Enable_HS_RX == 'd1)
			begin
			next_state = WAIT_SYNC;
			
			end
			
		else
			begin
			next_state = IDLE;
			end
			
		next_CNTR = ZERO; 
			
		end
		
		WAIT_SYNC:
		begin
		
		next_CNTR = ZERO;
		
		if(RX_SYNC_HS == 'd1 && !sync_error)
			begin	
			//
			ENABLE_DESERIALIZE   = 'd1;
			//
			next_state           = HS_0; 
			ENABLE_SYNC_DETECTOR = 'd0;
			RxActiveHS_c       = 'd1;
			end
		else
			begin
			next_state           = WAIT_SYNC;
			ENABLE_SYNC_DETECTOR = 'd1;
			RxActiveHS_c         = 'd0;
			//
				ENABLE_DESERIALIZE   = 'd0;
			//
			end
		end
		
		HS_0:
		begin
		
		ENABLE_SYNC_DETECTOR = 'd0;
		ENABLE_DESERIALIZE   = 'd1;
		RxActiveHS_c       = 'd1;
		//RxValidHS_comb =   1;
		next_CNTR            = curr_CNTR + 'd1;
		
		if(DATA[0] == DATA[1])      
			begin      
			comparator_enable = 'd0;  
			end
			else
			begin
			comparator_enable = 'd1;
			end
			
		if(trailer_done)
			begin
			next_state = EOT;
			end
		else if(break_trailer)
			begin
			next_state  = HS_1;
			end
		else
			begin
			next_state  =  HS_1;
			end
			
		end
		
		HS_1:
		begin
		
		ENABLE_SYNC_DETECTOR = 'd0;
		ENABLE_DESERIALIZE   = 'd1;
		RxActiveHS_c       = 'd1;
		
		next_CNTR  = curr_CNTR + 'd1;
			
				
		if(FLAG_DESERIALIZE == 'd1)
			begin
			RxValidHS_comb = 'd1;
			end
		//else
			//begin
			//RxValidHS_comb = 'd0;
			//end
			
		if(trailer_done)
			begin
			next_state = EOT;
			end
		else if(break_trailer)
			begin
			next_state  = HS_0;
			end
		else
			begin
			next_state  = HS_0;
			end
			
		end
		
		EOT:
		begin
		
		//ENABLE_DESERIALIZE   = 'd0;
		ENABLE_SYNC_DETECTOR = 'd0;
		RxActiveHS_c       = 'd0;
		comparator_enable    = 'd0;
		RxValidHS_comb     = 'd0;
		next_CNTR            = ZERO;       
		
		next_state           = IDLE;
		end
		
		default:
		begin
		
		ENABLE_DESERIALIZE   = 'd0;
		ENABLE_SYNC_DETECTOR = 'd0;
		RxValidHS_comb     = 'd0;
		comparator_enable    = 'd0;
		
		next_CNTR            = ZERO;
		
		next_state = IDLE;
		
		end
		
	endcase
	end
	else
	begin
		// this blick is edited 27/2/2024
		RxActiveHS_c       = 'd0;
		ENABLE_DESERIALIZE   = 'd0;
		ENABLE_SYNC_DETECTOR = 'd0;
		RxValidHS_comb     = 'd0;
		comparator_enable    = 'd0;
		
		next_state           = IDLE;
	end
 end
 
 always @(posedge RxByteClkHS or negedge RST)
 begin
   if(!RST)
     begin
       RxValidHS     <= 'd0;
     end
   else 
   begin 
		if(RxValidHS_comb)
		begin
			RxValidHS     <= 'd1;
		end
		else
			RxValidHS     <= 'd0;
	end 
 end
 
 always @(posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST)
 begin
   if(!RST)
     begin
       DATA <= 'd0;
     end
   else if(E1)
     begin
       DATA[0] <= HS_RX_DATA;
     end
   else if(E2)
     begin
       DATA[1] <= HS_RX_DATA;
     end
 end
 /*
 always @(posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST)
 begin
   if(!RST)
     begin
       flag_1 <= 'd0;
     end
   else if(RxValidHS_comb)
     begin
       flag_1 <= 'd1;
     end
 end
 */
 always @(posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST)
 begin
   if(!RST)
     begin
       comparator_enable_o <= 'd0;
     end
   else if(comparator_enable)
     begin
       comparator_enable_o <= 'd1;
     end
   else if(trailer_done || break_trailer)
     begin
       comparator_enable_o <= 'd0;
     end
 end



/*Active Flag*/
always @ (posedge RxByteClkHS or negedge RST)
begin
  if (! RST )
    RxActiveHS <= 0;
  else 
    RxActiveHS <= RxActiveHS_c;
end

assign E1 = (curr_CNTR == 'd6)? ('d1):('d0);
assign E2 = (curr_CNTR == 'd7)? ('d1):('d0);



always @(posedge RxByteClkHS or negedge RST)
 begin
  if(!RST)      // active low //
   begin
    rcv_flop <= 1'b0 ;
    pls_flop <= 1'b0 ;	
   end
  else
   begin
    rcv_flop <= flag;   
    pls_flop <= rcv_flop;
   end  
 end
always @(posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST)
 begin
   if(!RST)
     begin
       flag <= 'd0;
     end
   else if(RX_SYNC_HS)
     begin
       flag <= 'd1;
     end
 end
 assign RxSyncHS = rcv_flop && !pls_flop;
endmodule
