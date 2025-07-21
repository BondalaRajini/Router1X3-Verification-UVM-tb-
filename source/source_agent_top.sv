class source_agt_top extends uvm_env;
    `uvm_component_utils(source_agt_top)
      source_agt s_agt;
     
      function new(string name="s_agt",uvm_component parent);
           super.new(name,parent);
      endfunction
     
     function void build_phase(uvm_phase phase);
            s_agt=source_agt::type_id::create("s_agt",this);
     endfunction
endclass
