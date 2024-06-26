push:{[nam;itm] s:get nam; if[0=count s; `nam set s,: (::)]; nam set s,:$[0<=type itm; enlist itm;itm]};
pop:{[nam] s:get nam; if[1>=count s; :(::)]; a:last s; nam set -1 _ s; a}
top:{[nam] last get nam} ;
size:{[nam] count get nam} ;
ns:(); 

