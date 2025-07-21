class source_seqr extends uvm_sequencer #(write_xtn);
    `uvm_component_utils(source_seqr)
    function new(string name="source_seqr",uvm_component parent);
       super.new(name,parent);
   endfunction
endclass

