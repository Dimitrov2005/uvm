//----------------------------------------------------------------------
//   Copyright 2010 Synopsys, Inc.
//   Copyright 2010 Mentor Graphics Corp.
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

class sys_R_test extends uvm_test;

   `uvm_component_utils(sys_R_test)

   sys_env env;

   function new(string name="sys_R_test", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   function void build();
      apb_config apb_cfg = new;
      apb_cfg.vif = $root.sys_top.apb0;
      env = sys_env::type_id::create("sys_env",this);
      set_config_object("sys_env.apb_agent.*","config",apb_cfg,0);
   endfunction

   task run();
      apb_reset_seq reset_seq;
      sys_R_test_seq seq;

      reset_seq = apb_reset_seq::type_id::create("apb_reset_seq",this);
      reset_seq.start(env.apb.sqr);

      seq = sys_R_test_seq::type_id::create("sys_R_test_seq",this);
      seq.model = env.model;
      seq.start(env.apb.sqr);

      global_stop_request();
   endtask
   
endclass

