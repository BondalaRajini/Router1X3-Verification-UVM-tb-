class dst_monitor extends uvm_monitor;
     `uvm_component_utils(dst_monitor);
      dest_config d_cfg;
      virtual dest_if.MON_MP dif;
     uvm_analysis_port #(rd_xtn) rd_monitor_port;
   function new(string name="dst_monitor",uvm_component parent);
      super.new(name,parent);
       rd_monitor_port=new("rd_monitor_port",this);
   endfunction
   function void build_phase (uvm_phase phase);
           if(! uvm_config_db #(dest_config)::get(this,"","dest_config",d_cfg))
             `uvm_fatal("config","cannot get() source_config from uvm_config_db.Have you set() it")
    endfunction
   function void connect_phase(uvm_phase phase);
      dif=d_cfg.dvif;
    endfunction 
   task run_phase(uvm_phase phase);
      forever begin
        collect_data();
        end
   endtask
   task collect_data();
       rd_xtn data;
       data=rd_xtn::type_id::create("rd_xtn");
       while(dif.mon_cb.read_enb!==1)
           @(dif.mon_cb);
        //$display("from destination");
        //data.print();
       data.header=dif.mon_cb.data_out;
       data.payload=new[data.header[7:2]];
        @(dif.mon_cb);
      foreach(data.payload[i])
       begin
     //  while(dif.mon_cb.read_enb!==1)
     //   @(dif.mon_cb); 
       data.payload[i]=dif.mon_cb.data_out;
       @(dif.mon_cb);
     end
   //   while(dif.mon_cb.read_enb!==1)
  //      @(dif.mon_cb);
         data.parity=dif.mon_cb.data_out;
       if(data.header!=0)
          rd_monitor_port.write(data);
        $display("from destination monitor");
        data.print();
      endtask
      
endclass
