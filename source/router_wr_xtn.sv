
// router transaction class
class write_xtn extends uvm_sequence_item;
   `uvm_object_utils(write_xtn)
    bit pkt_valid,error,busy,rst; 
    rand bit[7:0] header;
   // rand bit pkt_valid;
   rand bit [7:0] payload[];
  // rand bit rst;
     bit [7:0] parity;
    constraint a{ header[1:0]!=2'b11;}
    constraint b{ payload.size==header[7:2];}
    constraint c{ header[7:2]!=0;}
//    constraint c{rst dist{ 1:=50,0:=1};}

  function new(string name="write_xtn");
     super.new(name);
  endfunction
  
  function void do_copy(uvm_object rhs);
     write_xtn rhs_;
     if(!$cast(rhs_,rhs))
          `uvm_fatal("do_copy","cast of the rhs object failed")
      super.do_copy(rhs);
      this.header=rhs_.header;
      this.payload=rhs_.payload;
      // this.pkt_valid=rhs_.pkt_valid;
      // this.rst=rhs_.rst;
  endfunction
  
  function bit do_compare(uvm_object rhs,uvm_comparer comparer);
      write_xtn rhs_;
      if(!$cast(rhs_,rhs))
         begin
         `uvm_fatal("do_compare","cast of the rhs object failed")
         return 0;
       end
      return   super.do_compare(rhs,comparer) && this.header==rhs_.header && this.payload==rhs_.payload;
  endfunction
   
  function void do_print(uvm_printer printer);
     super.do_print(printer);
    //                   srting name                              bitstream value          size       radix for printing
    printer.print_field( "header",                                  this.header,            8,          UVM_BIN                );
  foreach(payload[i])
    printer.print_field(  $sformatf("payload[%0d]",i),              this.payload[i],        8,          UVM_DEC                );
    printer.print_field( "parity",                                  this.parity,            8,          UVM_DEC                );
  endfunction 
 
  function void post_randomize();
      parity^=header;
      foreach(payload[i])
         parity^=payload[i];
  endfunction 
 endclass 
