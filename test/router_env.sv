class router_env extends uvm_env;
   `uvm_component_utils(router_env)
    source_agt_top source_top;
    dst_agt_top dst_top[];
    env_config env_cfg; 
    virtual_seqr vseqr;
    router_scoreboard router_sb;
    function new(string name="router_env",uvm_component parent);
        super.new(name,parent);
    endfunction
    
   function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
          `uvm_fatal("config","cannot get() env_config from uvm_config_db.Have you set() it")
       if(env_cfg.has_wagent)
        begin
        source_top=source_agt_top::type_id::create("source_top",this);
        uvm_config_db #(source_config)::set(this,"source_top*","source_config",env_cfg.s_cfg);
       end
       if(env_cfg.has_ragent)
        begin
         dst_top=new[env_cfg.no_of_agts];
       foreach(dst_top[i])
       begin
        dst_top[i]=dst_agt_top::type_id::create($sformatf("dst_top[%0d]",i),this);
         end
      end
     if(env_cfg.has_vsequencer)
          vseqr=virtual_seqr::type_id::create("vseqr",this);
     if(env_cfg.has_sb)
          begin
        /*  router_sb=new[env_cfg.no_of_agts];
            foreach(router_sb[i])
                router_sb[i]=router_scoreboard::type_id::create($sfromatf("router_sb[%0d]",i),this); */
             router_sb=router_scoreboard::type_id::create("router_sb",this);
           end 
            
   endfunction
    function void connect_phase(uvm_phase phase);
        if(env_cfg.has_vsequencer)
           begin
             if(env_cfg.has_wagent)
                begin
                 for(int i=0;i<env_cfg.no_of_src;i++)
                    vseqr.sseqrh[i]=source_top.s_agt.sseqr;
                 end
             if(env_cfg.has_ragent)
               begin
               for(int i=0;i<env_cfg.no_of_agts;i++)
                  begin
                   for(int j=0;j<env_cfg.no_of_dst;j++)
                     vseqr.dseqrh[j]=dst_top[i].dst_agt[j].dseqr;
                   end
                end
           end
                  if(env_cfg.has_sb)
                      begin
                      source_top.s_agt.smon.wr_monitor_port.connect(router_sb.src_fifo[0].analysis_export);
                      for(int j=0;j<env_cfg.no_of_dst;j++)
                        dst_top[0].dst_agt[j].dmon.rd_monitor_port.connect(router_sb.dst_fifo[j].analysis_export);
                  end 
      endfunction
         
endclass
  
