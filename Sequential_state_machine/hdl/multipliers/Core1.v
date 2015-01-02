`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:Deepak Kapoor 
// 
// Create Date:    11:43:05 07/23/2014 
// Design Name: 
// Module Name:    lower_bit_implementation 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module Core1_Implementation#(
	parameter param=4,
	parameter SQR=3'b01,

	parameter XOR=3'b10,
	parameter LUT=3'b11,
	parameter MASK=3'b100
	)(
	
   //INPUTS
	input wire         clk,
	input wire [255:0] A,                 
	input wire [255:0] B,                      //change
	input wire [2:0] select_line,
	
	//OUTPUT
	output[127:0] C_Out,
	output[127:0] D_Out
	
	);
	
	//OUTPUT PORTS
	wire [127:0] Data_C_Out[param:0];
	wire [127:0] Data_D_Out[param:0];
    
	//INPUT PORTS
	
	wire [255:0] Data_A_XOR,Data_B_XOR;
	
	wire [127:0] Data_A_SQR;
	wire [63:0] Data_A_Mask,Data_A_LUT,Data_B_LUT;
	wire [7:0]  Data_B_Mask;


		
		assign Data_A_XOR =(select_line==XOR)?A[255:0]:256'hz;
		assign Data_B_XOR =(select_line==XOR)?B[255:0]:256'hz;
		
		assign Data_A_Mask =(select_line==MASK)?A[63:0]:63'hz;
		assign Data_B_Mask =(select_line==MASK)?B[7:0]:7'hz;
		
		assign Data_A_LUT =(select_line==LUT)?A[63:0]:63'hz;
		assign Data_B_LUT =(select_line==LUT)?B[63:0]:63'hz;
		
		assign Data_A_SQR =(select_line==SQR)?A[127:0]:128'hzz;
		
		
      
		
		
		Xor_256_module Xor1(
			.A(Data_A_XOR),
			.B(Data_B_XOR),
			.C({Data_C_Out[XOR],Data_D_Out[XOR]})
		);
			
	
		sqr_128_module square(
			.A(Data_A_SQR),
			.Out({Data_C_Out[SQR],Data_D_Out[SQR]})
		);
		
				
		Masking_Module Mask(
			.A(Data_A_Mask),
			.B(Data_B_Mask),
			.Out({Data_D_Out[MASK][63:0]})
			);
					
			
		LOOK_UP_module Look_up_table(
			.A_Poly(Data_A_LUT),               //frst chunk [19:12] scnd chunk [7:0]
			.B(Data_B_LUT),
			.D_out_1(Data_C_Out[LUT]),     //frst chunk lut[255:128] secnd chunk Lut[127:0]
			.D_out_2(Data_D_Out[LUT])
			);
		
		assign C_Out=Data_C_Out[select_line];
		assign D_Out=Data_D_Out[select_line];

endmodule	


