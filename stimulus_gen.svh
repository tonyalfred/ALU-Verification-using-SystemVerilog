/* Stimulus Generator */

// Generator class is responsible for,
// 1. Generating the stimulus by randomizing the transaction class
// 2. Sending the randomized class to drive

class stimulus;

	packet 	pkt              ;

	// mailboxes between stimulus generator and driver/scoreboard
	mailbox s2d_mb, log_stim ;

	// index for packet numbering
    int     i = 0            ;

	function new(mailbox s2d_mb, mailbox log_stim);
		this.s2d_mb = s2d_mb     ;
		this.log_stim = log_stim ;
	endfunction

	task stim_task(int no_of_trans);
		repeat(no_of_trans)  
		begin
			pkt         = new()         ;
			i ++                        ;
			pkt.pkt_num = i             ;

			// wait until driver finishes driving 
				// the signals on the interface
			wait (s2d_mb.num () == 0)   ;  
			pkt.randomize()             ; 

			$display("packet = %p",pkt)	;

			s2d_mb.put(pkt)             ;
			log_stim.put(pkt)           ;
		end
	endtask 
endclass