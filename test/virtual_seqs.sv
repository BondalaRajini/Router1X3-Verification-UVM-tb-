class router_seqs extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(router_seqs)
      source_seqr sseqrh[];
      dst_sequencer dseqrh[];
      virtual_seqr vseqr;
      small_seq s_seq;
      medium_seq m_seq;
      large_seq l_seq;
      normal_sequence n_seq; 
      soft_sequence soft_seq;
      bit [1:0]addr;
      env_config e_cfg;
   
    function new (string name="router_seqs");
        super.new(name);
    endfunction
    
     task body();
            if(!uvm_config_db #(env_config)::get(null,get_full_name,"env_config",e_cfg))
          `uvm_fatal("config","cannot get() env_config from uvm_config_db.Have you set() it")
             if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"bit",addr))
                `uvm_fatal("config","cannot get() addr_config from uvm_config_db.Have you set() it")

             sseqrh=new[e_cfg.no_of_src];
             dseqrh=new[e_cfg.no_of_dst];
            assert($cast(vseqr,m_sequencer)) else begin
              `uvm_error("BODY", "Error in $cast of virtual sequencer")
            end
            for(int i=0;i<e_cfg.no_of_src;i++)
                            sseqrh[i]=vseqr.sseqrh[i];
             
            for(int j=0;j<e_cfg.no_of_dst;j++)
                      dseqrh[j] = vseqr.dseqrh[j];
       endtask     
endclass  

class router_sn_seqs extends router_seqs;
      `uvm_object_utils(router_sn_seqs)       
    function new(string name="router_sn_seqs");
        super.new(name);
    endfunction
   
   task body();
       super.body();
    
        s_seq=small_seq::type_id::create("s_seq");
        n_seq=normal_sequence::type_id::create("n_seq");
        soft_seq=soft_sequence::type_id::create("soft_seq");
        fork
        s_seq.start(sseqrh[0]);
        n_seq.start(dseqrh[addr]);
      //  soft_seq.start(dseqrh[addr]);
        join
   endtask
endclass      


class router_mn_seqs extends router_seqs;
      `uvm_object_utils(router_mn_seqs)
             
    function new(string name="router_mn_seqs");
        super.new(name);
    endfunction
   
   task body();
       super.body();
               m_seq=medium_seq::type_id::create("m_seq");
        n_seq=normal_sequence::type_id::create("n_seq");
        fork
        m_seq.start(sseqrh[0]);
        n_seq.start(dseqrh[addr]);
        join
   endtask
endclass      


class router_ln_seqs extends router_seqs;
      `uvm_object_utils(router_ln_seqs)
              
    function new(string name="router_ln_seqs");
        super.new(name);
    endfunction
   
   task body();
       super.body();
        l_seq=large_seq::type_id::create("l_seq");
        n_seq=normal_sequence::type_id::create("n_seq");
        fork
        l_seq.start(sseqrh[0]);
        n_seq.start(dseqrh[addr]);
        join
   endtask
endclass      

class router_ss_seqs extends router_seqs;
      `uvm_object_utils(router_ss_seqs)
        
    function new(string name="router_ss_seqs");
        super.new(name);
    endfunction
   
   task body();
       super.body();
        
        s_seq=small_seq::type_id::create("s_seq");
        soft_seq=soft_sequence::type_id::create("soft_seq");
        fork
        s_seq.start(sseqrh[0]);
        soft_seq.start(dseqrh[addr]);
        join
   endtask
endclass      


class router_ms_seqs extends router_seqs;
      `uvm_object_utils(router_ms_seqs)
              
    function new(string name="router_ms_seqs");
        super.new(name);
    endfunction
   
   task body();
       super.body();
        m_seq=medium_seq::type_id::create("m_seq");
        soft_seq=soft_sequence::type_id::create("soft_seq");
        fork
        m_seq.start(sseqrh[0]);
        soft_seq.start(dseqrh[addr]);
        join
   endtask
endclass      


class router_ls_seqs extends router_seqs;
      `uvm_object_utils(router_ls_seqs)
              
    function new(string name="router_ls_seqs");
        super.new(name);
    endfunction
   
    task body();
       super.body();
        l_seq=large_seq::type_id::create("l_seq");
        soft_seq=soft_sequence::type_id::create("soft_seq");
        fork
        l_seq.start(sseqrh[0]);
        soft_seq.start(dseqrh[addr]);
        join
   endtask
endclass      



