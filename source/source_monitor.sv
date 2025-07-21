class source_mon extends uvm_monitor;
    `uvm_component_utils(source_mon)
     virtual source_if.MON_MP sif; 
     source_config s_cfg;
     uvm_analysis_port #(write_xtn) wr_monitor_port;
     function new(string name="source_mon",uvm_component parent);
        super.new(name,parent);
        wr_monitor_port=new("wr_monitor_port",this);
     endfunction
        
      function void build_phase(uvm_phase phase);
          super.build_phase(phase);
         if(! uvm_config_db #(source_config)::get(this,"","source_config",s_cfg))
             `uvm_fatal("config","cannot get() source_config from uvm_config_db.Have you set() it")
    endfunction
    
    function void connect_phase(uvm_phase phase);
           sif=s_cfg.svif;
     endfunction
    task run_phase(uvm_phase phase);
     forever
       collect_data();
    endtask
    
    task collect_data();
     write_xtn data_sent;
     data_sent=write_xtn::type_id::create("data_sent");
     while(sif.mon_cb.busy !==0)
       @(sif.mon_cb);
      // $display("1");
     while(sif.mon_cb.pkt_valid !==1)
       @(sif.mon_cb);
        data_sent.header=sif.mon_cb.data_in;
        data_sent.payload=new[data_sent.header[7:2]];
        @(sif.mon_cb);
        foreach(data_sent.payload[i])
           begin
   while(sif.mon_cb.busy !==0)
       @(sif.mon_cb);
           data_sent.payload[i]=sif.mon_cb.data_in;
           @(sif.mon_cb);
           end
   while(sif.mon_cb.busy !==0)
       @(sif.mon_cb);
    //   $display("3");
       data_sent.parity=sif.mon_cb.data_in;
    //   data_sent.print();
       repeat(2)
         @(sif.mon_cb);
     //    @(sif.mon_cb);
      //   $display("4");       
         data_sent.error=sif.mon_cb.error;
         wr_monitor_port.write(data_sent);
         $display("from source monitor");
         data_sent.print();
        endtask
endclass

