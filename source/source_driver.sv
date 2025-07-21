class source_drv extends uvm_driver #(write_xtn);
   `uvm_component_utils(source_drv)
    source_config s_cfg;
    virtual source_if.DRV_MP sif;
   function new (string name="source_drv",uvm_component parent);
        super.new(name,parent);
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
       @(sif.drv_cb);
        sif.drv_cb.rst<=1'b0;
       @(sif.drv_cb);
        sif.drv_cb.rst<=1'b1;
        forever begin
         seq_item_port.get_next_item(req);
         req.print();
         send_to_dut(req);
         seq_item_port.item_done();
        end 
   endtask
   task send_to_dut(write_xtn req);
       while(sif.drv_cb.busy !==0)
          @(sif.drv_cb);
       sif.drv_cb.pkt_valid<=1'b1;
       sif.drv_cb.data_in<=req.header;
       @(sif.drv_cb);
     //req.payload.size=req.header[7:2];
     //  req.payload=new[req.header[7:2]];
       foreach(req.payload[i])
         begin
           while(sif.drv_cb.busy!==0)
              @(sif.drv_cb);
           sif.drv_cb.data_in<=req.payload[i];
           @(sif.drv_cb);
         end
        while(sif.drv_cb.busy !==0)
           @(sif.drv_cb);
        sif.drv_cb.pkt_valid<=1'b0;
        sif.drv_cb.data_in<=req.parity;
  //   repeat(2)
    //       @(sif.drv_cb);

       endtask
  
endclass
