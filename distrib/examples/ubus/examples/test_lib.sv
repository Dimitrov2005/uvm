//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`include "ubus_example_tb.sv"


// Base Test
class ubus_example_base_test extends uvm_test;

  `uvm_component_utils(ubus_example_base_test)

  ubus_example_tb ubus_example_tb0;
  uvm_table_printer printer;
  bit test_pass = 1;

  function new(string name = "ubus_example_base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase();
    super.build_phase();
    // Enable transaction recording for everything
    set_config_int("*", "recording_detail", UVM_FULL);
    // Create the tb
    ubus_example_tb0 = ubus_example_tb::type_id::create("ubus_example_tb0", this);
    // Create a specific depth printer for printing the created topology
    printer = new();
    printer.knobs.depth = 3;
  endfunction : build_phase

  function void end_of_elaboration_phase();
    // Set verbosity for the bus monitor for this demo
     if(ubus_example_tb0.ubus0.bus_monitor != null)
       ubus_example_tb0.ubus0.bus_monitor.set_report_verbosity_level(UVM_FULL);
    `uvm_info(get_type_name(),
      $psprintf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase_schedule phase);
    //set a drain-time for the environment if desired
    uvm_test_done.set_drain_time(this, 50);
  endtask : run_phase

  function void extract_phase();
    if(ubus_example_tb0.scoreboard0.sbd_error)
      test_pass = 1'b0;
  endfunction // void
  
  function void report_phase();
    if(test_pass) begin
      `uvm_info(get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
    end
    else begin
      `uvm_error(get_type_name(), "** UVM TEST FAIL **")
    end
  endfunction

endclass : ubus_example_base_test


// Read Modify Write Read Test
class test_read_modify_write extends ubus_example_base_test;

  `uvm_component_utils(test_read_modify_write)

  function new(string name = "test_read_modify_write", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase();
    uvm_resource_db#(uvm_object_wrapper)::set({get_full_name(),
			       ".ubus_example_tb0.ubus0.masters[0].sequencer"}, 
			       "main_ph",
				read_modify_write_seq::type_id::get(),
				this);
    uvm_resource_db#(uvm_object_wrapper)::set({get_full_name(),
			       ".ubus_example_tb0.ubus0.slaves[0].sequencer"}, 
			       "run_ph",
				slave_memory_seq::type_id::get(),
				this);
    // Create the tb
    super.build_phase();
  endfunction : build_phase

endclass : test_read_modify_write


// Large word read/write test
class test_r8_w8_r4_w4 extends ubus_example_base_test;

  `uvm_component_utils(test_r8_w8_r4_w4)

  function new(string name = "test_r8_w8_r4_w4", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase();
    super.build_phase();
    uvm_resource_db#(uvm_object_wrapper)::set({get_full_name(),
			       ".ubus_example_tb0.ubus0.masters[0].sequencer"}, 
			       "run_ph",
				r8_w8_r4_w4_seq::type_id::get(),
				this);
    uvm_resource_db#(uvm_object_wrapper)::set({get_full_name(),
			       ".ubus_example_tb0.ubus0.slaves[0].sequencer"}, 
			       "run_ph",
				slave_memory_seq::type_id::get(),
				this);
  endfunction : build_phase

endclass : test_r8_w8_r4_w4 


// 2 Master, 4 Slave test
class test_2m_4s extends ubus_example_base_test;

  `uvm_component_utils(test_2m_4s)

  function new(string name = "test_2m_4s", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase();
    // Overides to the ubus_example_tb build_phase()
    // Set the topology to 2 masters, 4 slaves
    uvm_resource_db#(int)::set({get_full_name(),".ubus_example_tb0.ubus0"}, 
			       "num_masters", 2, this);
    uvm_resource_db#(int)::set({get_full_name(),".ubus_example_tb0.ubus0"}, 
			       "num_slaves", 4, this);
     
   // Control the number of RMW loops
    uvm_resource_db#(int)::set({get_name(),".ubus_example_tb0.ubus0.masters[0].sequencer", ".loop_read_modify_write_seq"}, "itr", 3);
    uvm_resource_db#(int)::set({get_name(),".ubus_example_tb0.ubus0.masters[1].sequencer",".loop_read_modify_write_seq"}, "itr", 4);

     // Define the sequences to run in the run phase
    uvm_resource_db#(uvm_object_wrapper)::set({get_full_name(),
			       ".ubus_example_tb0.ubus0.masters[0].sequencer"}, 
			       "run_ph",
				loop_read_modify_write_seq::type_id::get(),
				this);
    uvm_resource_db#(uvm_object_wrapper)::set({get_full_name(),
			       ".ubus_example_tb0.ubus0.masters[1].sequencer"}, 
			       "run_ph",
				loop_read_modify_write_seq::type_id::get(),
				this);

     for(int i = 0; i < 4; i++) begin
	string slname;
	$swrite(slname,"%s.ubus_example_tb0.ubus0.slaves[%0d].sequencer",
		get_full_name(),i);
	uvm_resource_db#(uvm_object_wrapper)::set(slname, 
						  "run_ph",
						  slave_memory_seq::type_id::get(),
						  this);
     end
     
    // Create the tb
    super.build_phase();
  endfunction : build_phase

  function void connect_phase();
    // Connect other slaves monitor to scoreboard
    ubus_example_tb0.ubus0.slaves[1].monitor.item_collected_port.connect(
      ubus_example_tb0.scoreboard0.item_collected_export);
    ubus_example_tb0.ubus0.slaves[2].monitor.item_collected_port.connect(
      ubus_example_tb0.scoreboard0.item_collected_export);
    ubus_example_tb0.ubus0.slaves[3].monitor.item_collected_port.connect(
      ubus_example_tb0.scoreboard0.item_collected_export);
  endfunction : connect_phase
  
  function void end_of_elaboration_phase();
    // Set up slave address map for ubus0 (slaves[0] is overwritten here)
    ubus_example_tb0.ubus0.set_slave_address_map("slaves[0]", 16'h0000, 16'h3fff);
    ubus_example_tb0.ubus0.set_slave_address_map("slaves[1]", 16'h4000, 16'h7fff);
    ubus_example_tb0.ubus0.set_slave_address_map("slaves[2]", 16'h8000, 16'hBfff);
    ubus_example_tb0.ubus0.set_slave_address_map("slaves[3]", 16'hC000, 16'hFfff);
     super.end_of_elaboration_phase();
  endfunction : end_of_elaboration_phase

endclass : test_2m_4s
