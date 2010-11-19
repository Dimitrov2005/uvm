//----------------------------------------------------------------------
//   Copyright 2010 Synopsys, Inc.
//   Copyright 2010 Mentor Graphics Corp.
//   Copyright 2010 Cadence Design Systems, Inc.
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


import apb_pkg::*;

typedef class dut_reset_seq;
class sys_R_test extends uvm_test;

   sys_env env;

   `uvm_component_utils(sys_R_test)

   function new(string name="sys_R_test", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   function void build();
      if (env == null)
         $cast(env, uvm_top.find("env"));
   endfunction

   task run();
      uvm_sequence_base reset_seq;
      sys_R_test_seq seq;

      begin
         dut_reset_seq rst_seq;
         rst_seq = dut_reset_seq::type_id::create("rst_seq", this);
         rst_seq.start(null);
      end
      env.model.reset();

      seq = sys_R_test_seq::type_id::create("sys_R_test_seq",this);
      seq.model = env.model;
      seq.start(null);

      global_stop_request();
   endtask
   
endclass


