class router_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(router_scoreboard)
   	
    uvm_tlm_analysis_fifo #(rd_xtn) dst_fifo[];
    uvm_tlm_analysis_fifo #(write_xtn) src_fifo[];
    env_config e_cfg;
    write_xtn src;
    rd_xtn dst;
    bit[1:0] addr;
    covergroup src_cg;
  option.per_instance=1;
     
      ADDR:coverpoint src.header[1:0]
                 {bins d0={2'b00}; 
                  bins d1={2'b01};
                  bins d2={2'b10};}
     PAYLOAD: coverpoint src.header[7:2]{
                      bins smal={[1:20]};
                      bins mediu ={[21:40]};
                      bins larg={[41:63]};}
    ERROR: coverpoint src.error{
                        bins no_error={0};
                        bins error={1};}
   ADDR_PAYLOAD_ERROR: cross ADDR,PAYLOAD,ERROR;
   endgroup
    
    covergroup dst_cg;
   option.per_instance=1;

      ADDR:coverpoint dst.header[1:0]
                 {bins d0={2'b00}; 
                  bins d1={2'b01};
                  bins d2={2'b10};}
     PAYLOAD: coverpoint dst.header[7:2]{
                      bins smal={[1:20]};
                      bins mediu= {[21:40]};
                      bins larg ={[41:63]};}
       ADDR_PAYLOAD: cross ADDR,PAYLOAD;
   endgroup

   function new(string name="router_scoreboard",uvm_component parent);
       super.new(name,parent);
       src_cg=new();
       dst_cg=new();
   endfunction
     
  function void build_phase (uvm_phase phase);
     if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
          `uvm_fatal("config","cannot get() env_config from uvm_config_db.Have you set() it")
     if(!uvm_config_db #(bit[1:0])::get(this,"","bit",addr))
                `uvm_fatal("config","cannot get() addr_config from uvm_config_db.Have you set() it")
       src_fifo=new[e_cfg.no_of_src];
       dst_fifo=new[e_cfg.no_of_dst];
      for(int i=0;i<e_cfg.no_of_src;i++)
           src_fifo[i]=new($sformatf("src_fifo[%0d]",i),this);
      for(int j=0;j<e_cfg.no_of_dst;j++)
           dst_fifo[j]=new($sformatf("dst_fifo[%0d]",j),this);
   endfunction

task run_phase(uvm_phase phase);
//      bit [1:0]addr;
//      if(!uvm_config_db #(bit[1:0])::get(this,"","bit",addr))
//                `uvm_fatal("config","cannot get() addr_config from uvm_config_db.Have you set() it")
     forever begin   
     fork

        begin
         src_fifo[0].get(src);
         src.print();
         src_cg.sample();
        end
     
       begin
         dst_fifo[addr].get(dst);
         dst.print();
         dst_cg.sample();
       end
    join
   compare(src,dst);
   end
endtask
 
  task compare(write_xtn src,rd_xtn dst);
       if(src.header==dst.header)
            $display("success");
       else
         $display("failed");
        if(src.payload==dst.payload)
             $display("success");
        else
            $display("failed");
        if(src.parity==dst.parity)
              $display("sucess");
         else
             $display("failed");
    endtask
endclass
