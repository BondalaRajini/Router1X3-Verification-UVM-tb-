class dst_driver extends uvm_driver #(rd_xtn);
     `uvm_component_utils(dst_driver)
      dest_config d_cfg;
      virtual dest_if.DRV_MP dif;
     function new(string name="dst_driver",uvm_component parent);
          super.new(name,parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
           if(! uvm_config_db #(dest_config)::get(this,"","dest_config",d_cfg))
             `uvm_fatal("config","cannot get() dest_config from uvm_config_db.Have you set() it")
    endfunction
   function void connect_phase(uvm_phase phase);
      dif=d_cfg.dvif;
    endfunction 
    task run_phase(uvm_phase phase);
     forever begin
         seq_item_port.get_next_item(req);
         $display("3");
         req.print();
         send_to_dut(req);
         seq_item_port.item_done();
     end
    endtask
     task send_to_dut(rd_xtn req);
         while(dif.drv_cb.valid_out!==1)
            @(dif.drv_cb);
         repeat(req.cyc)
            @(dif.drv_cb);
         dif.drv_cb.read_enb<=1'b1;
         @(dif.drv_cb);
         while(dif.drv_cb.valid_out!==0)
            @(dif.drv_cb);
        @(dif.drv_cb);
        dif.drv_cb.read_enb<=1'b0;
     endtask  
endclass
