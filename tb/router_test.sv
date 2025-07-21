class router_test extends uvm_test;
    `uvm_component_utils(router_test)
     router_env envh;
     env_config env_cfg;
     source_config s_cfg;
     dest_config d_cfg[]; 
     bit[1:0]addr;
     bit has_wagent=1;
     bit has_ragent=1;
     bit has_vsequencer=1;
     bit has_sb=1;
     int no_of_dst=3;
     int no_of_agts=1;
     int no_of_src=1;
     function new(string name="envh",uvm_component parent);
       super.new(name,parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
         env_cfg=env_config::type_id::create("env_cfg");
        if(has_ragent)
              env_cfg.d_cfg=new[no_of_dst];
          config_r();
         uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);
         addr=$random%3;
         uvm_config_db #(bit[1:0]) ::set(this,"*","bit",addr);
         envh=router_env::type_id::create("envh",this);
    endfunction

    function void config_r();
           if(has_wagent)
             begin
              s_cfg=source_config::type_id::create("s_cfg");
            if(! uvm_config_db #(virtual source_if)::get(this,"","source_if",s_cfg.svif))
                 `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
             s_cfg.is_active=UVM_ACTIVE;
             env_cfg.s_cfg=s_cfg;
            end
           if(has_ragent)
             begin
              d_cfg=new[no_of_dst];
              foreach(d_cfg[i])
                 begin
                 d_cfg[i]=dest_config::type_id::create($sformatf("d_cfg[%0d]",i));
                 if(!uvm_config_db #(virtual dest_if)::get(this,"",$sformatf("dif%0d",i),d_cfg[i].dvif))
                       `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
                 d_cfg[i].is_active=UVM_ACTIVE;
               //  d_cfg[i].no_of_dst=no_of_dst;
                 env_cfg.d_cfg[i]=d_cfg[i];   
               end
            
             end
                 env_cfg.has_ragent=has_ragent; 
                 env_cfg.has_wagent=has_wagent;
                 env_cfg.has_vsequencer=has_vsequencer;
                 env_cfg.has_sb=has_sb;
                 env_cfg.no_of_dst=no_of_dst;
                 env_cfg.no_of_agts=no_of_agts;
                 env_cfg.no_of_src=no_of_src;
   endfunction
                 
    function void end_of_elaboration_phase(uvm_phase phase);
           uvm_top.print_topology();
    endfunction
endclass


class small_test extends router_test;
   `uvm_component_utils(small_test)
 
    router_sn_seqs snseqs;
  // bit [1:0] addr;
   function new(string name="small_test",uvm_component parent);
            super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      endfunction
   
   task run_phase(uvm_phase phase);
        phase.raise_objection(this);
     //   addr=$random%3;
     //   uvm_config_db #(bit[1:0]) ::set(this,"*","bit",addr);
        snseqs=router_sn_seqs::type_id::create("snseqs");
        snseqs.start(envh.vseqr);
        phase.drop_objection(this);
   endtask
endclass

class medium_test extends router_test;
   `uvm_component_utils(medium_test)
    router_mn_seqs mnseqs;
     //  bit [1:0] addr;
   function new(string name="medium_test",uvm_component parent);
            super.new(name,parent);
        endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
   
   task run_phase(uvm_phase phase);
        phase.raise_objection(this);
    //    addr=$random%3;
    //    uvm_config_db #(bit[1:0]) ::set(this,"*","bit",addr);
        mnseqs=router_mn_seqs::type_id::create("mnseqs");
        mnseqs.start(envh.vseqr);
        phase.drop_objection(this);
   endtask
endclass
 
   
class large_test extends router_test;
   `uvm_component_utils(large_test)
      router_ln_seqs lnseqs;
   //   bit [1:0] addr;
   function new(string name="large_test",uvm_component parent);
            super.new(name,parent);
         endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
   
   task run_phase(uvm_phase phase);
        phase.raise_objection(this);
      //  addr=$random%3;
      //  uvm_config_db #(bit[1:0]) ::set(this,"*","bit",addr);
        lnseqs=router_ln_seqs::type_id::create("lnseqs");
        lnseqs.start(envh.vseqr);
        phase.drop_objection(this);
   endtask
endclass

 
class small_soft_test extends router_test;
   `uvm_component_utils(small_soft_test)
 
    router_ss_seqs ssoft_seqs;
   // bit [1:0] addr;
   function new(string name="small_soft_test",uvm_component parent);
            super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      endfunction
   
   task run_phase(uvm_phase phase);
        phase.raise_objection(this);
     //   addr=$random%3;
     //   uvm_config_db #(bit[1:0]) ::set(this,"*","bit",addr);
        ssoft_seqs=router_ss_seqs::type_id::create("ssoft_seqs");
        ssoft_seqs.start(envh.vseqr);
        phase.drop_objection(this);
   endtask
endclass
   
class medium_soft_test extends router_test;
   `uvm_component_utils(medium_soft_test)
    router_ms_seqs msoft_seqs;
     //  bit [1:0] addr;
   function new(string name="medium_soft_test",uvm_component parent);
            super.new(name,parent);
        endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
   
   task run_phase(uvm_phase phase);
        phase.raise_objection(this);
     //   addr=$random%3;
     //   uvm_config_db #(bit[1:0]) ::set(this,"*","bit",addr);
        msoft_seqs=router_ms_seqs::type_id::create("msoft_seqs");
        msoft_seqs.start(envh.vseqr);
        phase.drop_objection(this);
   endtask
endclass


class large_soft_test extends router_test;
   `uvm_component_utils(large_soft_test)
      router_ls_seqs lsoft_seqs;
    //  bit [1:0] addr;
   function new(string name="large_soft_test",uvm_component parent);
            super.new(name,parent);
         endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
   
   task run_phase(uvm_phase phase);
        phase.raise_objection(this);
      //  addr=$random%3;
      //  uvm_config_db #(bit[1:0]) ::set(this,"*","bit",addr);
        lsoft_seqs=router_ls_seqs::type_id::create("lsoft_seqs");
        lsoft_seqs.start(envh.vseqr);
        phase.drop_objection(this);
   endtask
endclass

