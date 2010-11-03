//
// -------------------------------------------------------------
//    Copyright 2010 Mentor Graphics Corp.
//    Copyright 2010 Synopsys, Inc.
//    All Rights Reserved Worldwide
// 
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
// 

//
// TITLE: Built-In Test Sequences
//
// This sequence is able to execute a user-defined selection of the
// pre-defined register and memory test sequences
//

//
// Type: uvm_reg_mem_tests_e
// Select which pre-defined test sequence to execute.
//
// Multiple test sequences may be selected by adding their
// respective symbolic values.
//
// UVM_DO_REG_HW_RESET      - <uvm_reg_hw_reset_seq>
// UVM_DO_REG_BIT_BASH      - <uvm_reg_bit_bash_seq>
// UVM_DO_REG_ACCESS        - <uvm_reg_access_seq>
// UVM_DO_MEM_ACCESS        - <uvm_mem_access_seq>
// UVM_DO_SHARED_ACCESS     - <uvm_reg_mem_shared_access_seq>
// UVM_DO_MEM_WALK          - <uvm_mem_walk_seq>
// UVM_DO_ALL_REG_MEM_TESTS - All of the above
//
// Test sequences, when selected, are executed in the
// order in which they are specified above.
//
typedef enum bit [63:0] {
  UVM_DO_REG_HW_RESET      = 64'h0000_0000_0000_0001,
  UVM_DO_REG_BIT_BASH      = 64'h0000_0000_0000_0002,
  UVM_DO_REG_ACCESS        = 64'h0000_0000_0000_0004,
  UVM_DO_MEM_ACCESS        = 64'h0000_0000_0000_0008,
  UVM_DO_SHARED_ACCESS     = 64'h0000_0000_0000_0010,
  UVM_DO_MEM_WALK          = 64'h0000_0000_0000_0020,
  UVM_DO_ALL_REG_MEM_TESTS = 64'hffff_ffff_ffff_ffff 
} uvm_reg_mem_tests_e;


//
// Class: uvm_reg_mem_built_in_seq
// Sequence that executes a user-defined selection
// of pre-defined register and memory test sequences.
//
class uvm_reg_mem_built_in_seq extends uvm_reg_sequence #(uvm_sequence #(uvm_reg_item));

   `uvm_object_utils(uvm_reg_mem_built_in_seq)

   function new(string name="uvm_reg_mem_built_in_seq");
     super.new(name);
   endfunction

   // Variable: model
   //
   // The block to be tested. Declared in the base class.
   //
   //| uvm_reg_block model; 


   // Variable: tests
   //
   // The pre-defined test sequences to be executed.
   //
   bit [63:0] tests = UVM_DO_ALL_REG_MEM_TESTS;


   // Task: body
   //
   // Executes any or all the built-in register and memory sequences.
   // Do not call directly. Use seq.start() instead.
   
   virtual task body();

      if (model == null) begin
         `uvm_error("RegModel", "Not block or system specified to run sequence on");
         return;
      end

      uvm_report_info("START_SEQ",{"\n\nStarting ",get_name()," sequence...\n"},UVM_LOW);
      
      if (tests & UVM_DO_REG_HW_RESET &&
          model.get_attribute("NO_REG_TESTS") == "" &&
          model.get_attribute("NO_HW_RESET_TEST") == "") begin
        uvm_reg_hw_reset_seq seq = uvm_reg_hw_reset_seq::type_id::create("reg_hw_reset_seq");
        seq.model = model;
        seq.start(null,this);
        `uvm_info("FINISH_SEQ",{"Finished ",seq.get_name()," sequence."},UVM_LOW)
      end

      if (tests & UVM_DO_REG_BIT_BASH &&
          model.get_attribute("NO_REG_TESTS") == "" &&
          model.get_attribute("NO_BIT_BASH_TEST") == "") begin
        uvm_reg_bit_bash_seq seq = uvm_reg_bit_bash_seq::type_id::create("reg_bit_bash_seq");
        seq.model = model;
        seq.start(null,this);
        `uvm_info("FINISH_SEQ",{"Finished ",seq.get_name()," sequence."},UVM_LOW)
      end

      if (tests & UVM_DO_REG_ACCESS &&
          model.get_attribute("NO_REG_TESTS") == "" &&
          model.get_attribute("NO_REG_ACCESS_TEST") == "") begin
        uvm_reg_access_seq seq = uvm_reg_access_seq::type_id::create("reg_access_seq");
        seq.model = model;
        seq.start(null,this);
        `uvm_info("FINISH_SEQ",{"Finished ",seq.get_name()," sequence."},UVM_LOW)
      end

      if (tests & UVM_DO_MEM_ACCESS &&
          model.get_attribute("NO_REG_TESTS") == "" &&
          model.get_attribute("NO_MEM_ACCESS_TEST") == "") begin
        uvm_mem_access_seq seq = uvm_mem_access_seq::type_id::create("mem_access_seq");
        seq.model = model;
        seq.start(null,this);
        `uvm_info("FINISH_SEQ",{"Finished ",seq.get_name()," sequence."},UVM_LOW)
      end

      if (tests & UVM_DO_SHARED_ACCESS &&
          model.get_attribute("NO_REG_TESTS") == "" &&
          model.get_attribute("NO_SHARED_ACCESS_TEST") == "") begin
        uvm_reg_mem_shared_access_seq seq = uvm_reg_mem_shared_access_seq::type_id::create("shared_access_seq");
        seq.model = model;
        seq.start(null,this);
        `uvm_info("FINISH_SEQ",{"Finished ",seq.get_name()," sequence."},UVM_LOW)
      end

      if (tests & UVM_DO_MEM_WALK &&
          model.get_attribute("NO_REG_TESTS") == "" &&
          model.get_attribute("NO_MEM_WALK_TEST") == "") begin
        uvm_mem_walk_seq seq = uvm_mem_walk_seq::type_id::create("mem_walk_seq");
        seq.model = model;
        seq.start(null,this);
        `uvm_info("FINISH_SEQ",{"Finished ",seq.get_name()," sequence."},UVM_LOW)
      end

   endtask: body

endclass: uvm_reg_mem_built_in_seq

