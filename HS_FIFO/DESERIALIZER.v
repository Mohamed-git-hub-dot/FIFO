
module DESERIALIZER 
(
 input   wire                      RxDDRClkHS,
 input   wire                      RST,
 input   wire                      HS_RX_DATA,
 input   wire                      Enable,
 output  reg                      FLAG_DESERIALIZE,  
 output  reg    [7:0]              P_DATA
);

// DESERIALIZER //







reg [2:0] Counter;

always @(posedge RxDDRClkHS or negedge RxDDRClkHS or  negedge RST)
begin
if (!RST)
begin
 Counter <= 3'b0;
 P_DATA <= 8'b0;
end
else if (Enable)
begin
 P_DATA <= {HS_RX_DATA, P_DATA[7:1]} ;
 
  Counter <= Counter+1;
 if(Counter == 3'd7)
  begin
    FLAG_DESERIALIZE   <= 1'b1;
  end
 else 
  begin
   FLAG_DESERIALIZE  <= 1'b0;  
  end
end

else 
begin
 Counter <= 3'b0;
 P_DATA <= 8'b0;
 FLAG_DESERIALIZE  <= 1'b0;
end

end


endmodule

/*

module DESERIALIZER 
(
 input   wire                      RxDDRClkHS,
 input   wire                      RST,
 input   wire                      HS_RX_DATA,
 input   wire                      Enable,
 output  wire                      FLAG_DESERIALIZE,  
 output  reg    [7:0]              P_DATA
);

// DESERIALIZER //

reg [3:0] CNTR; 

reg [7:0] P_DATA_REG;

reg flag ;

reg curr_s, next_s;

always @ (posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST)
 begin
  if(!RST)
   begin
    P_DATA_REG <= 'b0;
    CNTR       <= 'd0;
    curr_s     <= 'd0;
   end
  else if(Enable)
   begin
    P_DATA_REG <= {HS_RX_DATA, P_DATA_REG[7:1]};
    CNTR       <= CNTR + 'd1; 
    curr_s     <= next_s; 
   end	
 end
 
always @ (posedge RxDDRClkHS or negedge RxDDRClkHS or negedge RST)
 begin
  if(!RST)
   begin
    P_DATA <= 'd0;
   end
  else if(CNTR == 'd7)
   begin
    P_DATA <= P_DATA_REG;
   end	
 end
 
always @(*)
begin
  if(CNTR == 'd7)
      next_s = 'd0;
   else
      next_s = 'd1;
end

always @(*)
begin
  if(curr_s == 'd0)
      CNTR   = 'd0;
end

 assign FLAG_DESERIALIZE = (CNTR == 'd7)? ('d1):('d0);

endmodule
*/