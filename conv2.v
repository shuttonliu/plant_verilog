/*	parameter w00 = 3'b001 ; parameter w01 = 3'b010 ; parameter w02 = 3'b011;   // kernel first row
	parameter w10 = 3'b100 ; parameter w11 = 3'b101 ; parameter w12 = 3'b110;   // kernel second row
	parameter w20 = 3'b111 ; parameter w21 = 3'b110 ; parameter w22 = 3'b100;	// kernel third row   */
module filter_0
(
    input CLK ,
    input EN ,
    input reset ,
	input [3:0] data_i ,
    output reg [8:0] data_o
);

reg [5:0] count = 0 ;
parameter w00 = 3'b001 ; 
parameter w01 = 3'b010 ; 
parameter w02 = 3'b011 ;

reg [8:0] D1 ;
reg [8:0] D2 ;

always @(posedge CLK or negedge reset) 
begin 
	if (!reset) 
		begin 
			D1 <= 9'b0 ; 
			D2 <= 9'b0 ;
		end
	else if (EN) 
		begin 
			D1 <= data_i * w00 ;
			D2 <= D1 + data_i * w01 ; 
			data_o <= D2 + data_i * w02 ;		
		end
end    
endmodule

module filter_1
(
    input CLK,
    input EN ,
    input reset ,
	input [3:0] data_i,
    output reg [8:0] data_o
);

reg [5:0] count = 0 ;
parameter w10 = 3'b100 ; 
parameter w11 = 3'b101 ; 
parameter w12 = 3'b110 ; 

reg [8:0] D1 ;
reg [8:0] D2 ;

always @(posedge CLK or negedge reset) 
begin 
    if (!reset) 
		begin 
			D1 <= 9'b0 ; 
			D2 <= 9'b0 ;
		end
	else if (EN) 
		begin 
			D1 <= data_i * w10 ;
			D2 <= D1 + data_i * w11 ; 
			data_o <= D2 + data_i * w12 ;
		end
end    
endmodule

module filter_2
(
    input CLK ,
    input EN ,
    input reset ,
	input [3:0] data_i,
    output reg [8:0] data_o
);

reg [5:0] count = 0 ;
parameter w20 = 3'b111 ; 
parameter w21 = 3'b110 ; 
parameter w22 = 3'b100 ;

reg [8:0] D1 ;
reg [8:0] D2 ;

always @(posedge CLK or negedge reset) 
begin 
    if (!reset) 
		begin 
			D1 <= 9'b0 ; 
			D2 <= 9'b0 ;
		end
	else if (EN) 
		begin 
			D1 <= data_i * w20 ;
			D2 <= D1 + data_i * w21 ; 
			data_o <= D2 + data_i * w22 ;
		end
end    
endmodule

module conv2D_out 
(
	input CLK ,
    input EN ,
    input reset ,
	input OE ,
	input [8:0] C1,
	input [8:0] C2,
	input [8:0] C3,
    output reg [9:0] out
);

reg [8:0] D1 ;
reg [8:0] D2 ;
reg [8:0] D3 ;

always @(posedge CLK or negedge reset)
begin 
	if(!reset) 
		begin
			D1 <= 9'b0 ; 
			D2 <= 9'b0 ;
			D3 <= 9'b0 ;
		end
	else if (EN) 
		begin 
			D1 <= C1 ;
			D2 <= C2 ;
			D3 <= C3 ;
			if(OE)
				begin
					out <= (D1 + D2) + D3 ;
				end
			else
				begin
					out <= 0 ;
				end
		end
end

endmodule

///////////////////////////////tb////////////////////////////////////

`define CYCLE 5.0
`define SIDE 6

module tb();
    reg clk;
    reg reset;
    reg EN;
	reg OE;
	reg [3:0] data_i_0 ;
	reg [3:0] data_i_1 ;
	reg [3:0] data_i_2 ;
	wire [8:0] out00 ;
	wire [8:0] out01 ;
	wire [8:0] out02 ;
	wire [9:0] out ;
	reg [3:0] ROM0 [35:0]; // graph first row

initial                                
    begin
		ROM0[ 0] = 4'b0001 ; ROM0[ 1] = 4'b0010 ; ROM0[ 2] = 4'b0011;
		ROM0[ 3] = 4'b0100 ; ROM0[ 4] = 4'b0101 ; ROM0[ 5] = 4'b0110;
		ROM0[ 6] = 4'b0111 ; ROM0[ 7] = 4'b1000 ; ROM0[ 8] = 4'b1001;
		ROM0[ 9] = 4'b1010 ; ROM0[10] = 4'b1011 ; ROM0[11] = 4'b1100;
		ROM0[12] = 4'b1101 ; ROM0[13] = 4'b1110 ; ROM0[14] = 4'b1111;
		ROM0[15] = 4'b0000 ; ROM0[16] = 4'b0001 ; ROM0[17] = 4'b0010;
		ROM0[18] = 4'b0011 ; ROM0[19] = 4'b0100 ; ROM0[20] = 4'b0101;
		ROM0[21] = 4'b0110 ; ROM0[22] = 4'b0111 ; ROM0[23] = 4'b1000;
		ROM0[24] = 4'b1001 ; ROM0[25] = 4'b1010 ; ROM0[26] = 4'b1011;
		ROM0[27] = 4'b1100 ; ROM0[28] = 4'b1101 ; ROM0[29] = 4'b1110;
		ROM0[30] = 4'b1111 ; ROM0[31] = 4'b0000 ; ROM0[32] = 4'b0001;
		ROM0[33] = 4'b0010 ; ROM0[34] = 4'b0011 ; ROM0[35] = 4'b0100;
    end

initial begin   //signal
	clk <= 0 ;
	EN  <= 0 ;
	reset <= 0 ;
	OE <= 1 ;
	# (`CYCLE/2) EN <= 1 ; reset <= 1;
	# (40*`CYCLE) $stop;
end

always #(`CYCLE/2) clk <= ~clk ; 

reg [5:0] count = 1 ;
reg [5:0] idx ;

always @(posedge clk or negedge reset)
begin 
	if (!reset) 
		begin
		idx = 0 ; 
		end
	else if (EN) 
		begin 	
			data_i_0 <= ROM0[idx] ; 
			data_i_1 <= ROM0[idx+`SIDE] ; 
			data_i_2 <= ROM0[idx+2*`SIDE] ; 
			idx <= idx + 1 ;
		end
end 

always @(posedge clk or negedge reset) //output counter 
begin
	if(out != 0)
		begin
			count <= count + 1 ;
		end
end

always @(posedge clk or negedge reset)
begin
	if(count == 3) //mod 4 , but clk mod-1
		begin
			OE <= 0 ;
			count <= 0 ;
			#(2*`CYCLE) ; 
		end
	else
		begin
			OE <= 1 ;			
		end
end

filter_0 u0(.CLK(clk),.EN(EN),.reset(reset),.data_i(data_i_0),.data_o(out00));
filter_1 u1(.CLK(clk),.EN(EN),.reset(reset),.data_i(data_i_1),.data_o(out01));
filter_2 u2(.CLK(clk),.EN(EN),.reset(reset),.data_i(data_i_2),.data_o(out02));
conv2D_out u3(.CLK(clk),.EN(EN),.reset(reset),.OE(OE),.C1(out00),.C2(out01),.C3(out02),.out(out)) ;

endmodule