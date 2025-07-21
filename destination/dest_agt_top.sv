class dst_agt_top extends uvm_env;
     `uvm_component_utils(dst_agt_top)
      dst_agent dst_agt[];
     // dest_config d_cfg;
      env_config e_cfg;
      function new(string name="dst_agt_top",uvm_component parent);
        super.new(name,parent);
      endfunction
    
      function void build_phase(uvm_phase phase);
       if(! uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
           `uvm_fatal("config","cannot get() env_config from uvm_config_db.Have you set() it")
          dst_agt=new[e_cfg.no_of_dst];           
          foreach(dst_agt[i])
          begin
          dst_agt[i]=dst_agent::type_id::create($sformatf("dst_agt[%0d]",i),this);
          uvm_config_db #(dest_config)::set(this,$sformatf("dst_agt[%0d]*",i),"dest_config",e_cfg.d_cfg[i]);
          end
      endfunction
 endclass
      
    
