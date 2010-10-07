module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  uvm_objection foo_objection = new();

  class test extends uvm_component;
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    task run;
      foo_objection.raise_objection(this);
    endtask
    `uvm_component_utils(test)
  endclass

  initial begin
    run_test();
  end

  uvm_object objs[$];
  initial begin
    foo_objection.set_report_verbosity_level(UVM_FULL);
    #100;
    foo_objection.raise_objection();
    foo_objection.get_objectors(objs);
    if(objs.size() != 2) $display("*** UVM TEST FAILED ***");
    foreach(objs[i]) $display(": objector: %s", objs[i].get_full_name());
    foo_objection.drop_objection();
    global_stop_request();
    $display("*** UVM TEST PASSED ***");
  end

endmodule
