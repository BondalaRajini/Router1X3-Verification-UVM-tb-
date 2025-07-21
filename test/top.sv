module  router_tb;
   import uvm_pkg::*;
   import router_test_pkg::*;
   bit clk;
   always #5 clk=~clk;
   source_if sif(clk);
   dest_if dif0(clk);
   dest_if dif1(clk);
   dest_if dif2(clk);
router_top DUV(clk,(sif.rst),(dif0.read_enb),(dif1.read_enb),(dif2.read_enb),(sif.data_in),
(sif.pkt_valid),(dif0.data_out),(dif1.data_out),(dif2.data_out),(dif0.valid_out),
(dif1.valid_out),(dif2.valid_out),(sif.error),(sif.busy));

property stable_data;
     @(posedge clk) sif.busy |=> $stable(sif.data_in);
endproperty
property busy_check;
      @(posedge clk) $rose(sif.pkt_valid) |=> sif.busy;
endproperty

property vld_out_check;
     @(posedge clk)   $rose(sif.pkt_valid)|-> ##3 (dif0.valid_out | dif1.valid_out |dif2.valid_out);
endproperty

property read0;
     @(posedge clk) dif0.valid_out  |-> ##[0:29] dif0.read_enb;
endproperty

property read1;
     @(posedge clk) dif1.valid_out  |-> ##[0:29] dif1.read_enb;
endproperty

property read2;
     @(posedge clk) dif2.valid_out  |-> ##[0:29] dif2.read_enb;
endproperty

property read0_ch;
       @(posedge clk) $fell(dif0.valid_out) |=> !dif0.read_enb;
endproperty
property read1_ch;
       @(posedge clk) $fell(dif1.valid_out) |=> !dif1.read_enb;
endproperty

property read2_ch;
       @(posedge clk) $fell(dif2.valid_out) |=> !dif2.read_enb;
endproperty

a:assert property(stable_data)
    $display("stable data is success");
   else 
       $display("stable data is failed");
a2: cover property(stable_data);

b:assert property(busy_check)
    $display("busy_check is success");
   else 
       $display("busy_check is failed");
b2: cover property(busy_check);

c:assert property(vld_out_check)
    $display("vld_out_check is success");
   else 
       $display("vld_out_check is failed");
c2: cover property(vld_out_check);

d:assert property(read0)
    $display("read0 is success");
   else 
       $display("read0 data is failed");
d2: cover property(read0);

e:assert property(read1)
    $display("read1 is success");
   else 
       $display("read1 data is failed");
e2: cover property(read1);

f:assert property(read2)
    $display("read2 is success");
   else 
       $display("read2 data is failed");
f2: cover property(read2);

g0:assert property(read0_ch)
    $display("read0_ch is success");
   else 
       $display("read0_ch data is failed");
g1: cover property(read0_ch);

g2:assert property(read1_ch)
    $display("read1_ch is success");
   else 
       $display("read1_ch data is failed");
g3: cover property(read1_ch);

g4:assert property(read2_ch)
    $display("read2_ch is success");
   else 
       $display("read2_ch data is failed");
g5: cover property(read2_ch);



    
   initial begin
			`ifdef VCS
         		$fsdbDumpvars(0, router_tb);
        		`endif

          uvm_config_db #(virtual source_if) ::set(null,"*","source_if",sif);
          uvm_config_db #(virtual dest_if) ::set(null,"*","dif0",dif0);
          uvm_config_db #(virtual dest_if) ::set(null,"*","dif1",dif1);
          uvm_config_db #(virtual dest_if) ::set(null,"*","dif2",dif2);
          run_test();
   end
endmodule
    
