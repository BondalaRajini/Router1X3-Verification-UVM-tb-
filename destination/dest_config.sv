class dest_config extends uvm_object;
   `uvm_object_utils(dest_config)
    uvm_active_passive_enum is_active;
    virtual dest_if dvif;
//    int no_of_dst;
   function new(string name="dest_config");
      super.new(name);
   endfunction
endclass


