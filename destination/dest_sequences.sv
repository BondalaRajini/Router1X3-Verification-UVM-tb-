class dest_sequences extends uvm_sequence #(rd_xtn);
  `uvm_object_utils(dest_sequences)
   function new(string name="dest_sequences");
       super.new(name);
   endfunction
endclass

class normal_sequence extends dest_sequences; 
      `uvm_object_utils(normal_sequence)
       
     function new (string name="normal_sequence");
       super.new(name);
     endfunction
    
    task body();
       req=rd_xtn::type_id::create("req");
       start_item(req);
       assert(req.randomize() with{cyc inside{[0:29]};});
       finish_item(req);
     endtask
endclass

class soft_sequence extends dest_sequences;
       `uvm_object_utils(soft_sequence)
        
        function new(string name="soft_sequence");
            super.new(name);
        endfunction
        
      task body();
        req=rd_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {cyc inside {[30:63]};});
        finish_item(req);
       endtask
endclass
