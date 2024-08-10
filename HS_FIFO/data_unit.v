module data_unit  #(parameter data_width =8,address_width=9)(

input [data_width-1:0] DATA,
input	trail_detected,data_valid,
input wfull,
input [address_width-1:0] waddr,

output reg [data_width-1:0] wdata,
//output reg [data_width:0] wdata,
output reg  winc,now,
output reg  [7:0] address_to_stop_at
);

wire rst;
assign rst = trail_detected;



always @(*)
begin
	if(data_valid && !wfull && !trail_detected)
	begin
		//wdata[data_width-1:0] = DATA;
		wdata = DATA;
		winc  = 1;
	end
	else
	begin
		wdata = 0;
		winc  = 0;
		
		if(trail_detected)
		begin
			now=1;
		
		end
		else
		begin
			now=0;
			
		end
		
	end
	
end
/*
always @(*)
begin
	wdata[data_width] = trail_detected;
	
end
*/
always @(posedge trail_detected or rst)
begin
	if(rst)
		address_to_stop_at <= waddr-24;
	else
		address_to_stop_at <=0;
end
endmodule