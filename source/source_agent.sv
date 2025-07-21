class source_agt extends uvm_agent;
     `uvm_component_utils(source_agt)
       
     source_drv sdrv;
     source_mon smon;
     source_seqr sseqr;
     source_config s_cfg;
    function new(string name="source_agt",uvm_component parent);
         super.new(name,parent);
    endfunction
   
    function void build_phase (uvm_phase phase);
      if(!uvm_config_db #(source_config)::get(this,"","source_config",s_cfg))
        `uvm_fatal("config","cannot get() source_config from uvm_config_db.Have you set() it")
       smon=source_mon::type_id::create("smon",this);
       if(s_cfg.is_active==UVM_ACTIVE)
          begin
         sdrv=source_drv::type_id::create("sdrv",this);
         sseqr=source_seqr::type_id::create("sseqr",this);
         end
    endfunction
function void connect_phase(uvm_phase phase);
    if(s_cfg.is_active==UVM_ACTIVE)
        sdrv.seq_item_port.connect(sseqr.seq_item_export);
endfunction 
endclass  
   
