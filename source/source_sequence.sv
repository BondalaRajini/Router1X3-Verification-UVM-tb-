class source_sequence extends uvm_sequence #(write_xtn);
    `uvm_object_utils(source_sequence)
    bit[1:0] addr;
     function new(string name="source_sequence");
        super.new(name);
     endfunction
   task body();
      if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"bit",addr))
          `uvm_fatal("config","cannot get() addr_config from uvm_config_db.Have you set() it")
    endtask
      
endclass

class small_seq extends source_sequence;
   `uvm_object_utils(small_seq)
    function new(string name="small_seq");
       super.new(name);
   endfunction
   task body();
           super.body();
       req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {header[1:0]==addr;header[7:2] inside{[1:20]};});
        finish_item(req);
   endtask
endclass 
  
class medium_seq extends source_sequence;
   `uvm_object_utils(medium_seq)
      function new(string name="medium_seq");
       super.new(name);
   endfunction
   
   
   task body();
             super.body();
             req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {header[1:0]==addr;header[7:2] inside{[21:40]};});
        finish_item(req);
      
   endtask
endclass 

class large_seq extends source_sequence;
   `uvm_object_utils(large_seq)
  
   function new(string name="large_seq");
       super.new(name);
   endfunction
     
   task body();
      super.body();
       req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {header[1:0]==addr;header[7:2] inside{[41:63]};});
        finish_item(req);
       
   endtask
endclass 
  

