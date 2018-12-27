////////////////////////////////////////////////////////////////////////////////
// Company: 奥新智能
// Engineer: 耿慧�?
//
// Description: A fast base-2 logarithm function
//
// Revision: N/A
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module math_log2_64 (

  // core interface

  input                    clk,
  input                    rst,
  input                    ena,

  // data interface

  input     [63:0]         din,
  output    [ 9:0]         dout

);

  // Comprises 3 main blocks: priority encoder, barrel shifter, and LUT

  reg       [ 5:0]         priencout1 = 'b0;
  reg       [ 3:0]         lut_out = 'b0;
  reg       [ 3:0]         lut_out_reg = 'b0;
  reg       [ 5:0]         priencout2 = 'b0;
  reg       [ 5:0]         priencout3 = 'b0;
  reg       [ 5:0]         priencout4 = 'b0;
  reg       [59:0]         barrelin = 'b0;
  reg       [ 4:0]         barrelout = 'b0;

  assign dout =	{priencout4, lut_out};	// Basic top-level connectivity

  // Barrel shifter - OMG, it's a primitive in Verilog!

  wire      [63:0]         priencin = din[63:0];
  wire      [59:0]         tmp1 = (barrelin << ~priencout1);

  always @(posedge clk) begin
    if (rst) begin
      barrelout <= 'b0;
    end else if (ena) begin
      barrelout <= tmp1[59:55];
    end
  end

  // Priority encoder

  always @(posedge clk) begin
    if (rst) begin
      priencout2 <= 'b0;
      priencout3 <= 'b0;
      priencout4 <= 'b0;
      barrelin <= 'b0;
    end else if (ena) begin 
      priencout2 <= priencout1;
      priencout3 <= priencout2;
      priencout4 <= priencout3;
      barrelin <= din[62:3];     
    end
  end  
  
  always @(posedge clk) begin   
    if (rst) begin 
      lut_out <= 'b0;                 
    end else if (ena) begin     
      lut_out <= lut_out_reg;         
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      priencout1 <= 0;
    end else if (ena) begin
      casez (priencin)
        64'b1???????????????????????????????????????????????????????????????: priencout1 <= 63;
        64'b01??????????????????????????????????????????????????????????????: priencout1 <= 62;
        64'b001?????????????????????????????????????????????????????????????: priencout1 <= 61;
        64'b0001????????????????????????????????????????????????????????????: priencout1 <= 60;
        64'b00001???????????????????????????????????????????????????????????: priencout1 <= 59;
        64'b000001??????????????????????????????????????????????????????????: priencout1 <= 58;
        64'b0000001?????????????????????????????????????????????????????????: priencout1 <= 57;
        64'b00000001????????????????????????????????????????????????????????: priencout1 <= 56;
        64'b000000001???????????????????????????????????????????????????????: priencout1 <= 55;
        64'b0000000001??????????????????????????????????????????????????????: priencout1 <= 54;
        64'b00000000001?????????????????????????????????????????????????????: priencout1 <= 53;
        64'b000000000001????????????????????????????????????????????????????: priencout1 <= 52;
        64'b0000000000001???????????????????????????????????????????????????: priencout1 <= 51;
        64'b00000000000001??????????????????????????????????????????????????: priencout1 <= 50;
        64'b000000000000001?????????????????????????????????????????????????: priencout1 <= 49;
        64'b0000000000000001????????????????????????????????????????????????: priencout1 <= 48;
        64'b00000000000000001???????????????????????????????????????????????: priencout1 <= 47;
        64'b000000000000000001??????????????????????????????????????????????: priencout1 <= 46;
        64'b0000000000000000001?????????????????????????????????????????????: priencout1 <= 45;
        64'b00000000000000000001????????????????????????????????????????????: priencout1 <= 44;
        64'b000000000000000000001???????????????????????????????????????????: priencout1 <= 43;
        64'b0000000000000000000001??????????????????????????????????????????: priencout1 <= 42;
        64'b00000000000000000000001?????????????????????????????????????????: priencout1 <= 41;
        64'b000000000000000000000001????????????????????????????????????????: priencout1 <= 40;
        64'b0000000000000000000000001???????????????????????????????????????: priencout1 <= 39;
        64'b00000000000000000000000001??????????????????????????????????????: priencout1 <= 38;
        64'b000000000000000000000000001?????????????????????????????????????: priencout1 <= 37;
        64'b0000000000000000000000000001????????????????????????????????????: priencout1 <= 36;
        64'b00000000000000000000000000001???????????????????????????????????: priencout1 <= 35;
        64'b000000000000000000000000000001??????????????????????????????????: priencout1 <= 34;
        64'b0000000000000000000000000000001?????????????????????????????????: priencout1 <= 33;
        64'b00000000000000000000000000000001????????????????????????????????: priencout1 <= 32;
        64'b000000000000000000000000000000001???????????????????????????????: priencout1 <= 31;
        64'b0000000000000000000000000000000001??????????????????????????????: priencout1 <= 30;
        64'b00000000000000000000000000000000001?????????????????????????????: priencout1 <= 29;
        64'b000000000000000000000000000000000001????????????????????????????: priencout1 <= 28;
        64'b0000000000000000000000000000000000001???????????????????????????: priencout1 <= 27;
        64'b00000000000000000000000000000000000001??????????????????????????: priencout1 <= 26;
        64'b000000000000000000000000000000000000001?????????????????????????: priencout1 <= 25;
        64'b0000000000000000000000000000000000000001????????????????????????: priencout1 <= 24;
        64'b00000000000000000000000000000000000000001???????????????????????: priencout1 <= 23;
        64'b000000000000000000000000000000000000000001??????????????????????: priencout1 <= 22;
        64'b0000000000000000000000000000000000000000001?????????????????????: priencout1 <= 21;
        64'b00000000000000000000000000000000000000000001????????????????????: priencout1 <= 20;
        64'b000000000000000000000000000000000000000000001???????????????????: priencout1 <= 19;
        64'b0000000000000000000000000000000000000000000001??????????????????: priencout1 <= 18;
        64'b00000000000000000000000000000000000000000000001?????????????????: priencout1 <= 17;
        64'b000000000000000000000000000000000000000000000001????????????????: priencout1 <= 16;
        64'b0000000000000000000000000000000000000000000000001???????????????: priencout1 <= 15;
        64'b00000000000000000000000000000000000000000000000001??????????????: priencout1 <= 14;
        64'b000000000000000000000000000000000000000000000000001?????????????: priencout1 <= 13;
        64'b0000000000000000000000000000000000000000000000000001????????????: priencout1 <= 12;
        64'b00000000000000000000000000000000000000000000000000001???????????: priencout1 <= 11;
        64'b000000000000000000000000000000000000000000000000000001??????????: priencout1 <= 10;
        64'b0000000000000000000000000000000000000000000000000000001?????????: priencout1 <= 9;
        64'b00000000000000000000000000000000000000000000000000000001????????: priencout1 <= 8;
        64'b000000000000000000000000000000000000000000000000000000001???????: priencout1 <= 7;
        64'b0000000000000000000000000000000000000000000000000000000001??????: priencout1 <= 6;
        64'b00000000000000000000000000000000000000000000000000000000001?????: priencout1 <= 5;
        64'b000000000000000000000000000000000000000000000000000000000001????: priencout1 <= 4;
        64'b0000000000000000000000000000000000000000000000000000000000001???: priencout1 <= 3;
        64'b00000000000000000000000000000000000000000000000000000000000001??: priencout1 <= 2;
        64'b000000000000000000000000000000000000000000000000000000000000001?: priencout1 <= 1;
        64'b000000000000000000000000000000000000000000000000000000000000000?: priencout1 <= 0;
        default : priencout1 <= 0;
      endcase
    end
  end

  /*
  LUT for log fraction lookup
   - can be done with array or case:

  case (addr)
  0:out=0;
  .
  31:out=15;
  endcase

  	OR

  wire [3:0] lut [0:31];
  assign lut[0] = 0;
  .
  assign lut[31] = 15;

  Are there any better ways?
  */

  // Let's try "case".
  // The equation is: output = log2(1+input/32)*16
  // For larger tables, better to generate a separate data file using a program!

 /* always @*
    case (barrelout)

      0 : lut_out = 0;
      1 : lut_out = 0;
      2 : lut_out = 1;
      3 : lut_out = 2;
      4 : lut_out = 2;
      5 : lut_out = 3;
      6 : lut_out = 4;
      7 : lut_out = 4;
      8 : lut_out = 5;
      9 : lut_out = 6;
      10: lut_out = 6;
      11: lut_out = 7;
      12: lut_out = 7;
      13: lut_out = 8;
      14: lut_out = 9;
      15: lut_out = 9;
      16: lut_out = 10;
      17: lut_out = 10;
      18: lut_out = 11;
      19: lut_out = 12;
      20: lut_out = 12;
      21: lut_out = 13;
      22: lut_out = 13;
      23: lut_out = 14;
      24: lut_out = 14;
      25: lut_out = 15;
      26: lut_out = 15;
      27: lut_out = 16;
      28: lut_out = 16;	// calculated value is *slightly* closer to 15, but 14 makes for a smoother curve!
      29: lut_out = 17;
      30: lut_out = 17;
      31: lut_out = 18;
      32: lut_out = 18;
      33: lut_out = 19;
      34: lut_out = 19;
      35: lut_out = 20;
      36: lut_out = 20;
      37: lut_out = 21;
      38: lut_out = 21;
      39: lut_out = 21;
      40: lut_out = 22;
      41: lut_out = 22;
      42: lut_out = 23;
      43: lut_out = 23;
      44: lut_out = 24;
      45: lut_out = 24;
      46: lut_out = 25;
      47: lut_out = 25;
      48: lut_out = 25;
      49: lut_out = 26;
      50: lut_out = 26;
      51: lut_out = 27;
      52: lut_out = 27;
      53: lut_out = 27;
      54: lut_out = 28;
      55: lut_out = 28;
      56: lut_out = 29;
      57: lut_out = 29;
      58: lut_out = 29;
      59: lut_out = 30;
      60: lut_out = 30;    // calculated value is *slightly* closer to 15, but 14 makes for a smoother curve!
      61: lut_out = 30;
      62: lut_out = 31;
      63: lut_out = 31;
    endcase */

  always @(posedge clk) 
      casez ({rst,ena,barrelout})
        7'b1?????? : lut_out_reg <= 0;
        7'b0100000 : lut_out_reg <= 0;
        7'b0100001 : lut_out_reg <= 1;
        7'b0100010 : lut_out_reg <= 1;
        7'b0100011 : lut_out_reg <= 2;
        7'b0100100 : lut_out_reg <= 3;
        7'b0100101 : lut_out_reg <= 3;
        7'b0100110 : lut_out_reg <= 4;
        7'b0100111 : lut_out_reg <= 5;
        7'b0101000 : lut_out_reg <= 5;
        7'b0101001 : lut_out_reg <= 6;
        7'b0101010 : lut_out_reg <= 6;
        7'b0101011 : lut_out_reg <= 7;
        7'b0101100 : lut_out_reg <= 7;
        7'b0101101 : lut_out_reg <= 8;
        7'b0101110 : lut_out_reg <= 8;
        7'b0101111 : lut_out_reg <= 9;
        7'b0110000 : lut_out_reg <= 9;
        7'b0110001 : lut_out_reg <= 10;
        7'b0110010 : lut_out_reg <= 10;
        7'b0110011 : lut_out_reg <= 11;
        7'b0110100 : lut_out_reg <= 11;
        7'b0110101 : lut_out_reg <= 12;
        7'b0110110 : lut_out_reg <= 12;
        7'b0110111 : lut_out_reg <= 13;
        7'b0111000 : lut_out_reg <= 13;
        7'b0111001 : lut_out_reg <= 13;
        7'b0111010 : lut_out_reg <= 14;
        7'b0111011 : lut_out_reg <= 14;
        7'b0111100 : lut_out_reg <= 14;
        7'b0111101 : lut_out_reg <= 15;
        7'b0111110 : lut_out_reg <= 15;
        7'b0111111 : lut_out_reg <= 15; 
        default : lut_out_reg <= 0;
      endcase 

  always @(posedge clk) begin
    if (rst) begin
      lut_out_reg <= 0;
    end else if (ena) begin
      case (barrelout)
        0 : lut_out_reg <= 0;
        1 : lut_out_reg <= 1;
        2 : lut_out_reg <= 1;
        3 : lut_out_reg <= 2;
        4 : lut_out_reg <= 3;
        5 : lut_out_reg <= 3;
        6 : lut_out_reg <= 4;
        7 : lut_out_reg <= 5;
        8 : lut_out_reg <= 5;
        9 : lut_out_reg <= 6;
        10: lut_out_reg <= 6;
        11: lut_out_reg <= 7;
        12: lut_out_reg <= 7;
        13: lut_out_reg <= 8;
        14: lut_out_reg <= 8;
        15: lut_out_reg <= 9;
        16: lut_out_reg <= 9;
        17: lut_out_reg <= 10;
        18: lut_out_reg <= 10;
        19: lut_out_reg <= 11;
        20: lut_out_reg <= 11;
        21: lut_out_reg <= 12;
        22: lut_out_reg <= 12;
        23: lut_out_reg <= 13;
        24: lut_out_reg <= 13;
        25: lut_out_reg <= 13;
        26: lut_out_reg <= 14;
        27: lut_out_reg <= 14;
        28: lut_out_reg <= 14;
        29: lut_out_reg <= 15;
        30: lut_out_reg <= 15;
        31: lut_out_reg <= 15; 
        default : lut_out_reg <= 0;
      endcase
    end
  end
                                        
endmodule

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

