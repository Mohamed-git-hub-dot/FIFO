
// ************************* Description *********************** //
//  This module is implemented to:-                              //
//   -- generate write address in binary code                    //
//   -- generate full flag to overcome fifo overwrite            //
//   -- generate gray coded write pointer                        //
// ************************************************************* //

module fifo_wr #(
  parameter P_SIZE = 4                          // pointer width
)
  (
   input  wire                    w_clk,              // write domian operating clock
   input  wire                    w_rstn,             // write domian active low reset 
   input  wire                    w_inc,              // write control signal 
   input  wire  [P_SIZE-1:0]      sync_rd_ptr,        // synced gray coded read pointer         
   output wire  [P_SIZE-2:0]      w_addr,             // generated binary write address
   output reg   [P_SIZE-1:0]      gray_w_ptr,         // generated gray coded write address [registered]
   output wire                    full                // fifo full flag

);

wire [P_SIZE-1:0]  gray_w_ptr_comb;
reg [P_SIZE-1:0]  w_ptr ;

// increment binary pointer
always @(posedge w_clk or negedge w_rstn)
 begin
  if(!w_rstn)
   begin
    w_ptr <= 0 ;
   end
 else if (!full && w_inc)
    w_ptr <= w_ptr + 1 ;
 end


// generation of write address
assign w_addr = w_ptr[P_SIZE-2:0] ;

// converting binary write pointer to gray coded
always @(posedge w_clk or negedge w_rstn)
 begin
  if(!w_rstn)
   begin
    gray_w_ptr <= 0 ;
   end
 else
  begin
  /*
   case (w_ptr)
   4'b0000: gray_w_ptr <= 4'b0000 ;
   4'b0001: gray_w_ptr <= 4'b0001 ;
   4'b0010: gray_w_ptr <= 4'b0011 ;
   4'b0011: gray_w_ptr <= 4'b0010 ;
   4'b0100: gray_w_ptr <= 4'b0110 ;
   4'b0101: gray_w_ptr <= 4'b0111 ;
   4'b0110: gray_w_ptr <= 4'b0101 ;
   4'b0111: gray_w_ptr <= 4'b0100 ;
   4'b1000: gray_w_ptr <= 4'b1100 ;
   4'b1001: gray_w_ptr <= 4'b1101 ;
   4'b1010: gray_w_ptr <= 4'b1111 ;
   4'b1011: gray_w_ptr <= 4'b1110 ;
   4'b1100: gray_w_ptr <= 4'b1010 ;
   4'b1101: gray_w_ptr <= 4'b1011 ;
   4'b1110: gray_w_ptr <= 4'b1001 ;
   4'b1111: gray_w_ptr <= 4'b1000 ;
   endcase
   */
   gray_w_ptr <= gray_w_ptr_comb;
   
   
   
   
   
  end
 end


// generation of full flag
assign full = (sync_rd_ptr[P_SIZE-1]!= gray_w_ptr[P_SIZE-1] && sync_rd_ptr[P_SIZE-2]!= gray_w_ptr[P_SIZE-2] && sync_rd_ptr[P_SIZE-3:0]== gray_w_ptr[P_SIZE-3:0]) ;

gray_code_generator gray_module (

.binary(w_ptr),
. gray(gray_w_ptr_comb)

);

endmodule











module gray_code_generator (
    input  [9:0] binary,
    output  [9:0] gray
);

assign gray[9] = binary[9];
assign gray[8] = binary[9] ^ binary[8];
assign gray[7] = binary[8] ^ binary[7];
assign gray[6] = binary[7] ^ binary[6];
assign gray[5] = binary[6] ^ binary[5];
assign gray[4] = binary[5] ^ binary[4];
assign gray[3] = binary[4] ^ binary[3];
assign gray[2] = binary[3] ^ binary[2];
assign gray[1] = binary[2] ^ binary[1];
assign gray[0] = binary[1] ^ binary[0];

endmodule
