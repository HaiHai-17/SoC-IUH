// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.0sp1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/03/07 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module nios_sys_addr_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 2,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 19 
   )
  (output [83 - 79 : 0] default_destination_id,
   output [22-1 : 0] default_wr_channel,
   output [22-1 : 0] default_rd_channel,
   output [22-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[83 - 79 : 0];

  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1) begin
      assign default_src_channel = '0;
    end
    else begin
      assign default_src_channel = 22'b1 << DEFAULT_CHANNEL;
    end
  end
  endgenerate

  generate begin : default_decode_rw
    if (DEFAULT_RD_CHANNEL == -1) begin
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin
      assign default_wr_channel = 22'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 22'b1 << DEFAULT_RD_CHANNEL;
    end
  end
  endgenerate

endmodule


module nios_sys_addr_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [94-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [94-1    : 0] src_data,
    output reg [22-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 52;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 83;
    localparam PKT_DEST_ID_L = 79;
    localparam PKT_PROTECTION_H = 87;
    localparam PKT_PROTECTION_L = 85;
    localparam ST_DATA_W = 94;
    localparam ST_CHANNEL_W = 22;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 55;
    localparam PKT_TRANS_READ  = 56;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h10000 - 64'h8000); 
    localparam PAD1 = log2ceil(64'h11000 - 64'h10800); 
    localparam PAD2 = log2ceil(64'h11040 - 64'h11020); 
    localparam PAD3 = log2ceil(64'h11170 - 64'h11160); 
    localparam PAD4 = log2ceil(64'h11180 - 64'h11170); 
    localparam PAD5 = log2ceil(64'h11190 - 64'h11180); 
    localparam PAD6 = log2ceil(64'h111a0 - 64'h11190); 
    localparam PAD7 = log2ceil(64'h111b0 - 64'h111a0); 
    localparam PAD8 = log2ceil(64'h111c0 - 64'h111b0); 
    localparam PAD9 = log2ceil(64'h111d0 - 64'h111c0); 
    localparam PAD10 = log2ceil(64'h111e0 - 64'h111d0); 
    localparam PAD11 = log2ceil(64'h111f0 - 64'h111e0); 
    localparam PAD12 = log2ceil(64'h11200 - 64'h111f0); 
    localparam PAD13 = log2ceil(64'h11210 - 64'h11200); 
    localparam PAD14 = log2ceil(64'h11220 - 64'h11210); 
    localparam PAD15 = log2ceil(64'h11230 - 64'h11220); 
    localparam PAD16 = log2ceil(64'h11240 - 64'h11230); 
    localparam PAD17 = log2ceil(64'h11250 - 64'h11240); 
    localparam PAD18 = log2ceil(64'h11260 - 64'h11250); 
    localparam PAD19 = log2ceil(64'h11270 - 64'h11260); 
    localparam PAD20 = log2ceil(64'h11280 - 64'h11270); 
    localparam PAD21 = log2ceil(64'h11290 - 64'h11288); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h11290;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;

      wire [PKT_ADDR_W-1 : 0] address = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;

    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [22-1 : 0] default_src_channel;





    nios_sys_addr_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x8000 .. 0x10000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 17'h8000   ) begin
            src_channel = 22'b0000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x10800 .. 0x11000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 17'h10800   ) begin
            src_channel = 22'b0000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x11020 .. 0x11040 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 17'h11020   ) begin
            src_channel = 22'b0000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x11160 .. 0x11170 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 17'h11160   ) begin
            src_channel = 22'b1000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x11170 .. 0x11180 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 17'h11170   ) begin
            src_channel = 22'b0100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x11180 .. 0x11190 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 17'h11180   ) begin
            src_channel = 22'b0010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x11190 .. 0x111a0 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 17'h11190   ) begin
            src_channel = 22'b0001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x111a0 .. 0x111b0 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 17'h111a0   ) begin
            src_channel = 22'b0000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x111b0 .. 0x111c0 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 17'h111b0   ) begin
            src_channel = 22'b0000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x111c0 .. 0x111d0 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 17'h111c0   ) begin
            src_channel = 22'b0000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x111d0 .. 0x111e0 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 17'h111d0   ) begin
            src_channel = 22'b0000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x111e0 .. 0x111f0 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 17'h111e0   ) begin
            src_channel = 22'b0000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x111f0 .. 0x11200 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 17'h111f0   ) begin
            src_channel = 22'b0000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x11200 .. 0x11210 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 17'h11200   ) begin
            src_channel = 22'b0000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x11210 .. 0x11220 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 17'h11210   ) begin
            src_channel = 22'b0000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x11220 .. 0x11230 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 17'h11220   ) begin
            src_channel = 22'b0000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x11230 .. 0x11240 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 17'h11230   ) begin
            src_channel = 22'b0000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x11240 .. 0x11250 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 17'h11240   ) begin
            src_channel = 22'b0000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x11250 .. 0x11260 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 17'h11250   ) begin
            src_channel = 22'b0000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x11260 .. 0x11270 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 17'h11260   ) begin
            src_channel = 22'b0000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x11270 .. 0x11280 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 17'h11270   ) begin
            src_channel = 22'b0000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x11288 .. 0x11290 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 17'h11288   ) begin
            src_channel = 22'b0000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


