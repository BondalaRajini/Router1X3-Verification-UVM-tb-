class dst_agent extends uvm_agent ;
    `uvm_component_utils(dst_agent)
     
     dst_driver ddrv;
     dst_monitor dmon;
     dst_sequencer dseqr;
     dest_config d_cfg;
     function new (string name="dst_agent",uvm_component parent);
       super.new(name,parent);
     endfunction
  
    function void build_phase(uvm_phase phase);
     if(!uvm_config_db #(dest_config)::get(this,"","dest_config",d_cfg))
          `uvm_fatal("config","cannot get() dest_config from uvm_config_db.Have you set() it")
          dmon=dst_monitor::type_id::create("dmon",this);
          if(d_cfg.is_active==UVM_ACTIVE)
            begin
             ddrv=dst_driver::type_id::create("ddrv",this);
             dseqr=dst_sequencer::type_id::create("dseqr",this);
           end
    endfunction

function void connect_phase(uvm_phase phase);
    if(d_cfg.is_active==UVM_ACTIVE)
        ddrv.seq_item_port.connect(dseqr.seq_item_export);
endfunction 
endclass




