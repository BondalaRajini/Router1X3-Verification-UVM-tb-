class virtual_seqr extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(virtual_seqr)
     source_seqr sseqrh[];
     dst_sequencer dseqrh[];
     env_config e_cfg;
     
    function new(string name="virtual_seqr",uvm_component parent);
        super.new(name,parent);
    endfunction
   
    function void build_phase(uvm_phase phase);
        
        if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
          `uvm_fatal("config","cannot get() env_config from uvm_config_db.Have you set() it")
             sseqrh=new[e_cfg.no_of_src];
             dseqrh=new[e_cfg.no_of_dst];
    endfunction
    
endclass    
    
