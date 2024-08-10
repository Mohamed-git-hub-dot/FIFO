
module TOP_HS_FIFO #(
  parameter DATA_WIDTH = 'd8
  )(
  input RxDDRClkHS,RST,
  input Enable_HS_RX,HS_RX_DATA,
  output wire RxByteClkHS,
  output wire RxActiveHS,RxSyncHS,RxValidHS,
  output wire [DATA_WIDTH-1 : 0] RxDataHS
  );
  
  wire FLAG_DESERIALIZE,comparator_enable,trailer_done,break_trailer;
  wire ENABLE_DESERIALIZE,ENABLE_SYNC_DETECTOR,ENABLE_SAMPLER;
  wire sync_error,RxValidHS_old ;
  wire [DATA_WIDTH-1 : 0] RxDataHS_old;
  CTRL_UNIT INST_1(
  .RxDDRClkHS(RxDDRClkHS),
  .RxByteClkHS(RxByteClkHS),
  .RST(RST),
  .HS_RX_DATA(HS_RX_DATA),
  .Enable_HS_RX(Enable_HS_RX),
  .RX_SYNC_HS(Rx_Sync_Hs),
  .sync_error(sync_error),
  .FLAG_DESERIALIZE(FLAG_DESERIALIZE),
  .ENABLE_DESERIALIZE(ENABLE_DESERIALIZE),
  .ENABLE_SYNC_DETECTOR(ENABLE_SYNC_DETECTOR),
  .RxActiveHS(RxActiveHS),
  .RxValidHS(RxValidHS_old),
  .RxSyncHS(RxSyncHS),
  .break_trailer(break_trailer),
  .trailer_done(trailer_done),
  .comparator_enable_o(comparator_enable)
  ); 
  
  DESERIALIZER INST_2(
  .RxDDRClkHS(RxDDRClkHS),
  .RST(RST),
  .HS_RX_DATA(HS_RX_DATA),
  .Enable(ENABLE_DESERIALIZE),
  .FLAG_DESERIALIZE(FLAG_DESERIALIZE),  
  .P_DATA(RxDataHS_old)
  );
  
  
  Sync_Detector INST_3(
  .RxDDRClkHS(RxDDRClkHS),
  .RST(RST),
  .sync_en(ENABLE_SYNC_DETECTOR),
  .HS_RX_DATA(HS_RX_DATA),
  .sync_error(sync_error),
  .sync_valid(Rx_Sync_Hs)
  );
  
  CLOCK_DIV INST_4 (
  .i_ref_clk(RxDDRClkHS),              
  .i_rst(RST),                  
  .i_clk_en(1'b1),             
  .i_div_ratio(4'B0100),                     
  .o_div_clk(RxByteClkHS)               
  );
  
  comparator INST_5 (
  .clk_comparator(RxDDRClkHS),
  .RST(RST),
  .comparator_enable(comparator_enable),
  .HS_RX_DATA(HS_RX_DATA),
  .trailer_done(trailer_done),
  .break_trailer_c(break_trailer));
  wire  [7:0]     o_r_data; 
  wire now;
 wire i_w_inc,o_empty;


wire [7:0] address_to_stop_at;
wire [7:0] i_w_data;
wire i_r_inc;




  data_unit dut_data_unit(

.DATA(RxDataHS_old),
.trail_detected (trailer_done),
.data_valid(FLAG_DESERIALIZE),
.wfull(o_full),
.waddr(fifo_dut.w_addr),
.wdata(i_w_data),
.winc(i_w_inc),
.now(now),
.address_to_stop_at(address_to_stop_at)
);
  
  
  
  
  
Async_fifo #( 8,60,10 )  fifo_dut (

.i_w_clk(RxDDRClkHS),              // write domian operating clock
.  i_w_rstn(RST),             // write domian active low reset  
.  i_w_inc(i_w_inc),              // write control signal 
.  i_r_clk(RxByteClkHS),              // read domian operating clock
.  i_r_rstn(RST),             // read domian active low reset 

.  i_r_inc(i_r_inc),              // read control signal
.  i_w_data(i_w_data),             // write data bus 
.  o_r_data(o_r_data),             // read data bus
.  o_full(o_full),               // fifo full flag
.o_empty(o_empty)


); 
  
  wire  [7 :0] RxData_hs_new;
  wire Rx_Valid_new;
  
  
  
   PPI_UNIT  ppi_new (


.r_Data(o_r_data),
.o_empty(o_empty),
.clk(RxByteClkHS),
.rst(RST),

.RxData_hs_new(RxDataHS),
.Rx_Valid_new(Rx_Valid_new),
.rinc(i_r_inc)




);
assign RxValidHS =  Rx_Valid_new & RxValidHS_old;
endmodule
