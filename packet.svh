 /* Packet */

class packet;
	//input signals 
	rand  logic [3:0] 	a			;
	rand  logic [3:0] 	b			;
	rand  logic 		valid_in 	;
	rand  logic 		cin			;
	randc logic [3:0] 	ctl			;
	
	constraint c1 {valid_in==1;}
	
	//output signals 
	logic [3:0] 		alu 		;
	logic 				valid_out 	;
	logic 				carry 		;
	logic 				zero 		;

	int            		pkt_num     ;
endclass