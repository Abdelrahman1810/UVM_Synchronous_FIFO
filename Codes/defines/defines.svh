`define OFF_ALL item.constraint_mode(0);
`define ON(constraint) item.constraint.constraint_mode(1);

`define create_comp(type, name) type::type_id::create(name, this);
`define create_obj(type, name) type::type_id::create(name);

`define asrt_prp(content) assert property (@(posedge clk) disable iff(!rst_n) (content)); 
`define cov_prp(content) cover property (@(posedge clk) disable iff(!rst_n) (content)); 

`define asrt_fn assert final
`define cov_fn cover final

`define same_seq (rd_en && wr_en && !empty && !full)

`define Func_new_p(name_) \
function new(string name = name_, uvm_component parent = null); \
    super.new(name, parent); \
endfunction //new()

`define Func_new(name_) \
function new(string name = name_); \
    super.new(name); \
endfunction //new()