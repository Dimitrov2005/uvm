`OVM_REPORT_INFO("bla","text");
`OVM_REPORT_FATAL("foo","text");

class bla extends ovm_sequence_item;


function new(a,b,c);

super.new( a , f ,h);

endfunction


 function foo;
	#1 component::global_stop_request();
 endfunction
endclass

class bla2 extends ovm_sequence_item;


function new(a,b,c);

super.new( a , f2 ,h);

endfunction

endclass

`include "ovm.svh"

`include "ovm_macros.svh"
`include "ovm_foo.svh"

ovm_factory::print()

ovm_urm_report_server::set_global_verbosity(OVM_DEBUG-1);

ovm_urm_report_server::set_global_debug_style(style);


	something.ovm_enable_print_topology = 1;
	ovm_enable_print_topology = 1;	

class bla extends ovm_reporter;
endclass

class phu extends configure_ph;
endclass

// swap a and b for uvm
foo.raise_objection(devthis,a,b); 
 // should be devthis,,54
foo.raise_objection(devthis,54);
// no change
foo.raise_objection(this); 
// this,,4
foo.raise_objection(this,4);
 // this,,4 
foo.raise_objection(this,4);

class bla extends ovm_sequence_item;
 
    function new(string name="yapp_packet");
     super.new(name);
     setPacketLength();
     `ifdef DATA_ITEM_DEBUG
       $display("DATA_ITEM_DEBUG: yapp_packet allocated @addr %0d : time=%0g",this,$time);
     `endif
   endfunction : new

   function void post_new ();
   endfunction

   function void pre_run();
   endfunction

   function void import_connections();
   endfunction
 
   function void export_connections();
   endfunction


endclass


// this should be now in global space
my_component.global_stop_request();
