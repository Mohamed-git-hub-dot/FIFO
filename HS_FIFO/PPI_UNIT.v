module PPI_UNIT #(parameter data_width =8)(


input [data_width-1 :0] r_Data,
input o_empty,clk,rst,

output reg [data_width-1 :0] RxData_hs_new,
output reg Rx_Valid_new,
output reg rinc




);

always @(posedge clk  or negedge rst)
begin
	if(!rst)
	begin
		RxData_hs_new<=0;
		Rx_Valid_new<=0;
	end
	else
	begin
		if(!o_empty  && rinc)
		begin
			RxData_hs_new<=r_Data;
			Rx_Valid_new<=1;
		
		end
		else
		begin
			RxData_hs_new<=0;
			Rx_Valid_new<=0;
			
		end
	end
	
end


reg [4:0] byte_count;
always @ (posedge clk or negedge rst)
begin
	if(!rst)
	begin
		byte_count<=0;
	end
	else
	begin
		if(r_Data ==0 && !o_empty  && rinc)
		begin
			if(byte_count == 23)
				byte_count<=0;
			else
				byte_count<=byte_count+1;
		end
		else
			byte_count<=0;
	end
end




always @(*)
begin
	
	
		if(!o_empty && byte_count !=23)
			rinc =1 ;
		else
			rinc =0;		
		
	
end






endmodule