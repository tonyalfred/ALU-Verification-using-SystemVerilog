interface alu_if(input logic clk, input logic reset);

	//ALU inputs
	logic 		valid_in	; //validate input signals
	logic [3:0] a			; //port A
	logic [3:0] b			; //port B 
	logic 		cin			; //carry input from carry flag register 
	logic [3:0] ctl 		; //functionality control for ALU 
	
	//Output signals
	logic 		valid_out	; //validate output signals
	logic [3:0] alu			; //the result 
	logic 		carry		; //carry output 
	logic 		zero 		; //zero output 
	int         pkt_num         ;

endinterface: alu_if
