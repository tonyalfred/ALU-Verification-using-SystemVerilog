/* Monitor */

// Samples the interface signals and converts the signal level activity to the transaction level.
// Send the sampled transaction to Scoreboard via Mailbox.

class monitor;
	
	virtual alu_if vif ;
	mailbox log_mon    ;
	packet pkt         ;

	function new(virtual alu_if vif , mailbox log_mon);
		this.vif = vif;
		this.log_mon = log_mon;
	endfunction
	
	task monitor_task;
		forever 
		  begin
			pkt = new();

			@(posedge vif.clk)
			begin
			#1;
			pkt.a 		   = vif.a        ;
			pkt.b 		   = vif.b        ;
			pkt.valid_in = vif.valid_in ;
			pkt.cin 	   = vif.cin      ;
			pkt.ctl 	   = vif.ctl      ;
			end

			@(posedge vif.clk)
			begin
			#1;
			pkt.alu 	    = vif.alu       ;
			pkt.valid_out = vif.valid_out ;
			pkt.carry 	  = vif.carry     ;
			pkt.zero 	    = vif.zero      ;
			end 
			
      pkt.pkt_num   = vif.pkt_num   ;
			log_mon.put(pkt);
			
			$display("packet_monitor = %p",pkt)	;
		end
	endtask
endclass