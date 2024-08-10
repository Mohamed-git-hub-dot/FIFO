
module comparator(

input 	     clk_comparator, RST,
input 	     comparator_enable,
input 	     HS_RX_DATA,
output reg  trailer_done,
output wire break_trailer_c
);

reg [7:0]	  counter;
reg         delayed_version;
reg         break_trailer;
wire        indc;

reg         rcv_flop;
reg         pls_flop;

always @(posedge clk_comparator or negedge clk_comparator  or negedge RST)
begin
	if(!RST)
	begin
		counter         <= 'd0;
		delayed_version <= 'd0;
		trailer_done     = 'd0;
	end
	
	else
	begin
		if(comparator_enable)
		begin
			if(delayed_version == HS_RX_DATA)
			begin
				counter <= counter + 'd1;
				if(counter == 'd186)
				begin
					trailer_done = 'd1;
					counter     <= 'd0;
				end
			end
			
			else
			begin
				delayed_version <= HS_RX_DATA; 
				counter         <= 'd0;
				trailer_done     = 'd0;
			end
		end
		else
		begin
			counter      <=  'd0;
			trailer_done <=  'd0;
		end	
	end
	
end

always @ (posedge clk_comparator or negedge clk_comparator  or negedge RST )
begin
 if(!RST)
	break_trailer  <= 'd0;
 else if (comparator_enable && indc && counter != 'd0)
	break_trailer  <= 'd1;
end

always @(posedge clk_comparator or negedge clk_comparator  or negedge RST)
begin
  if(!RST)
    begin
      rcv_flop <= 1'b0 ;
      pls_flop <= 1'b0 ;	
    end
    else
    begin
      rcv_flop <= break_trailer;
      pls_flop <= rcv_flop ;	
    end
end

xor (indc , HS_RX_DATA , delayed_version); /* any toggle means it was a data */

assign break_trailer_c = rcv_flop && !pls_flop;

endmodule