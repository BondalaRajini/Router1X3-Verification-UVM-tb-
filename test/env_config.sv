class env_config extends uvm_object;
     `uvm_object_utils(env_config)
   
    source_config s_cfg;
    dest_config d_cfg[];
   
    int no_of_dst;
    bit has_wagent;
    bit has_ragent;
    bit has_vsequencer;
    bit has_sb;
    int no_of_agts;
    int no_of_src; 
function new(string name="env_config");
    super.new(name);
endfunction

endclass 
