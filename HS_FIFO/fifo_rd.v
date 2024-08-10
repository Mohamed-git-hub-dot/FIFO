
// ************************* Description *********************** //
//  This module is implemented to:-                              //
//   -- generate read address in binary code                     //
//   -- generate empty flag to overcome fifo underflow           //
//   -- generate gray coded read pointer                         //
// ************************************************************* //

module fifo_rd #(
  parameter P_SIZE = 4                          // pointer width
)
  (
   input  wire                     r_clk,              // read domian operating clock
   input  wire                     r_rstn,             // read domian active low reset 
   input  wire                     r_inc,              // read control signal 
   input  wire   [P_SIZE-1:0]      sync_wr_ptr,        // synced gray coded write pointer         
   output wire   [P_SIZE-2:0]      rd_addr,            // generated binary read address
   output wire                     empty,              // fifo empty flag
   output reg    [P_SIZE-1:0]      gray_rd_ptr         // generated gray coded write address

);

wire [P_SIZE-1:0]  gray_rd_ptr_comb;
reg [P_SIZE-1:0]  rd_ptr ;

// increment binary pointer
always @(posedge r_clk or negedge r_rstn)
 begin
  if(!r_rstn)
   begin
    rd_ptr <= 0 ;
   end
 else if (!empty && r_inc)
    rd_ptr <= rd_ptr + 1 ;
 end


// generation of read address
assign rd_addr = rd_ptr[P_SIZE-2:0] ;

// converting binary read pointer to gray coded
always @(posedge r_clk or negedge r_rstn)
begin
 if(!r_rstn)
   begin
    gray_rd_ptr <= 0 ;
   end
 else 
  begin
  /*
   case (rd_ptr)
   4'b0000: gray_rd_ptr <= 4'b0000 ;
   4'b0001: gray_rd_ptr <= 4'b0001 ;
   4'b0010: gray_rd_ptr <= 4'b0011 ;
   4'b0011: gray_rd_ptr <= 4'b0010 ;
   4'b0100: gray_rd_ptr <= 4'b0110 ;
   4'b0101: gray_rd_ptr <= 4'b0111 ;
   4'b0110: gray_rd_ptr <= 4'b0101 ;
   4'b0111: gray_rd_ptr <= 4'b0100 ;
   4'b1000: gray_rd_ptr <= 4'b1100 ;
   4'b1001: gray_rd_ptr <= 4'b1101 ;
   4'b1010: gray_rd_ptr <= 4'b1111 ;
   4'b1011: gray_rd_ptr <= 4'b1110 ;
   4'b1100: gray_rd_ptr <= 4'b1010 ;
   4'b1101: gray_rd_ptr <= 4'b1011 ;
   4'b1110: gray_rd_ptr <= 4'b1001 ;
   4'b1111: gray_rd_ptr <= 4'b1000 ;
   endcase
   */
   gray_rd_ptr <= gray_rd_ptr_comb;
  end
 end


// generation of empty flag
assign empty = (sync_wr_ptr == gray_rd_ptr) ;

gray_code_generator gray_module (

.binary(rd_ptr),
. gray(gray_rd_ptr_comb)

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