`iStack1 set ns; / Create a new stack we will fill with ints. 
push[`iStack1; 100];
push[`iStack1; 200];
push[`iStack1; 300];
pop[`iStack1];

`lStack1 set ns; / Create a new stack we will fill with lists. 
push[`lStack1; (100 ; 200)];
push[`lStack1; (300 ; 400)];
pop[`lStack1];
push[`lStack1; (500 ; 600; 700)];

testSetNew[`:tests/stack.csv; `:dummyStack.q]
addDoc["push"; "Adds a new value to the top of the stack"];
describeArg["nam"; "name of the global variable holding the stack as a symbol"];
describeArg["itm"; "value to push onto the stack; all data types - mixed data types allowed"];
describeResult["push"; "returns the name of the stack"];
addDoc["pop"; "Removes and returns value at the top of the stack"] ;
describeArg["nam"; "name of the global variable holding the stack as a symbol"];
describeResult["push"; "value previously at top of the stack"];

addTest[{top[`iStack1] ~ 200}; "number should be on top of stack"];
addTest[{size[`iStack1] ~ 2}; "size of stack should be 1"] ;
addTest[{top[`lStack1] ~ (500 ; 600; 700)}; "list should be on top of stack"];
addTest[{size[`lStack1] ~ 2}; "size of stack should be 2"] ;


