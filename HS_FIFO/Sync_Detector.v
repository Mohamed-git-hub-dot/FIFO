
module Sync_Detector (

input      RxDDRClkHS ,
input      RST ,
input      sync_en,
input      HS_RX_DATA,
output reg sync_error, sync_valid

);

reg  [3:0]  count;
reg  [5:0]  stored_bits;
//reg sync_valid_c;
wire done ;
/* Latch to store  received sequence  */
always @ ( posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST )
begin
  if (! RST )
   stored_bits <= 'd0;
   else if (sync_en && !done) 
     stored_bits [count] <= HS_RX_DATA;
     else
       stored_bits <= 'd0;
end
  
/* Counter +ve and -ve edge triggered */
always @ ( posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST ) 
begin
if (!RST)
    count <= 'd0;
  else if (sync_en) /* condition on done ?? */
    count <= count + 'd1;
  else
    count <= 'd0;
  end
    
  assign done = (count == 'd6)? ('d1) : ('d0);

/* Deceide validation , 1 bit error is allowed */

always @ ( * )
begin
	if ( done  )
		begin
		case (stored_bits)
			'b101110 , 'b101111 , 'b101100,
			'b101010 , 'b100110 , 'b111110,
			'b001110: 
			begin
				
				
					sync_valid= 1'b1;
					sync_error = 1'b0;
				
				
				
					
				
			end
			
			default:
			begin
			sync_valid= 1'b0;
			sync_error = 1'b1;
			end
			endcase
		end
		
		else /* done = 0 */ 
		begin
			
			sync_valid = 1'b0;
			sync_error = 1'b0;
			
			end
  end

endmodule

