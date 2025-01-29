/ `bdd.q` is a program designed to facilitate the documentation and
/ testing of a q function. It allows you to define the name of a function,
/ provide a detailed specification of its functionality, describe each
/ argument and the return value, and provide test cases.

/ The functions that end users of this package need to be aware of are:

/ - **testSetNew**: Specifies where the tests should be stored.
/ - **addDoc**: Defines the function name and provides a description of what it does.
/ - **describeArg**: Describes the arguments of the function.
/ - **describeResult**: Details the expected results of calling this function. 
/ - **addTest**: Constructs a test that will be runnable using `k4unit.q` 

/ ============== ============== ============== ============== ============== ==============

/ testSetNew[filePathCSV; filePathQtmp]: Initializes a new test set for documentation and testing.
/ - filePathCSV: file where bdd will write tests defined in k4unit.q format.
/ - filePathQtmp: file where bdd will write comments to be used as prompts for ai code generation 
testSetNew:{[filePathCSV;filePathQtmp]
    / delete file at stringPath if it exists
    if[not (key[filePathCSV]~());hdel[filePathCSV]];
    filePathCSV 0: enlist "action,ms,bytes,lang,code,repeat,minver,comment";   
    bddCurrentTestSet:: filePathCSV; 
    bddCurrentDummyQfile:: filePathQtmp; 
    };
 
/wrapIfNeeded: wraps a string in string quotes if it has a comma in it to support CSV format
wrapIfNeeded:{[st]
  if[(st like "*,*") and (st like "*\"*"); 'notSupportedBothCommaAndQuote ];
  $[st like "*,*"; "\"" , st, "\""; st]
  };

 /removeSetBracket removes the brackets from a string 
 /if they exist as the first and last characters.

removeSetBracketAndNewlines:{[st]
  st1: ssr[st;"\n";""]; 
  $[(st1[0] ~ "{") and (st1[(count st1) - 1] ~ "}"); st1[1+til (count st1) - 2]; st1]
  };

/ Replace single sets of double quotes with two double quotes in x
quoteQuotes: { 
  $[count x > 0; ssr[x;"\"";"\\\""]; x]
 };
 
// addTest[funcName; args; expectedResult; description]: Adds a new test case to the current test set.
// - `funcName` is a symbol representing the name of the function to be tested.
// - `args` is a list of arguments to be passed to the function during the test.
// - `expectedResult` specifies the expected output of the function when invoked with `args`.
// - `description` is a string providing a brief description of the test case, explaining what it tests for.

/ addTest[testString; comment]: Add a test case to the current test set.
/ - testString: A "q" statement evaluating an expression and comparing the actual to the expected result,
/     This becomes the "code" field in a new row of the csv file, 
/     also written as a comment in the dummy "q" file. 
/ - comment: A comment describing the test. 
/     This becomes the "comment" field in the new row of the csv file
/     It is not currrently written to the dummy "q" file.
addTest:{[testString; comment]
  st: str testString;
  st1: quoteQuotes removeSetBracketAndNewlines st;
  addTestCSV[st1; comment];
  addTestQ[st1; comment];
 };

addTestCSV:{[testString; comment]
  start: "true,0,0,q,";
  after: ",1,,";
  end: "\n";
  htxt:hopen bddCurrentTestSet;  
  htxt[(start,(wrapIfNeeded testString)),after, comment, end];
  hclose htxt;
    };

addTestQ:{[testString; comment]
  start: "//    test:";
  end: " \n" ;
  htxt:hopen bddCurrentDummyQfile;  
  htxt[(start,testString),end];
  hclose htxt;
    };


/ addDoc[funtionName; comment] provides a comment describing a function to be tested.
/  1. The function name followed by the comment are written as a comment in the dummy "q" file.
/  2. Same thing written as the "code" field in a new row with action="comment" in the k4unit csv file. 
addDoc:{ [functionName;comment]
  addDocCSV[functionName;comment];
  addDocQ[functionName;comment];
    };

addDocCSV:{[functionName;comment]
  start: "comment,0,0,q,";
  end: ",1,,\n" ;
  htxt:hopen bddCurrentTestSet;  
  htxt[(start,functionName," ",comment),end];
  hclose htxt;
    }; 

addDocQ:{[functionName;comment]
  start: "// ";
  end: ". \n" ;
  htxt:hopen bddCurrentDummyQfile;  
  htxt[(start,functionName, " is a Q function which ",comment),end];
  hclose htxt;
    }; 

/ describeArg[argName;comment]  
/  Adds a comment describing an argument to the last function described by "addDoc" to the dummy q file.
/  Typically, each "addDoc" is followed by a "describeArg" for each argument to that function.
/  Nothing is added to the k4unit csv file.
describeArg:{[argName;comment]
  describeArgQ[argName;comment];
    };

describeArgQ:{[argName;comment]
  start: "    // argument: ";
  end: ". \n" ;
  htxt:hopen bddCurrentDummyQfile;  
  htxt[(start,argName, " is ",comment),end];
  hclose htxt;
    };

/ describeResult[functionName;comment]
/  This adds a comment describing the function's return value to the] dummy "q" file.
/  Typically, this is placed immediately after the last "describeArg" entry for this function.
/  Nothing is added to the k4Unit csv file. 
describeResult: {[functionName;comment]
  start: "// ";
  end: " \n" ;
  htxt:hopen bddCurrentDummyQfile;  
  htxt[(start,functionName, " returns ",comment),end];
  hclose htxt;
    }; 

/ Function to run tests and display the results
/ This function sets up the test environment, runs the tests, filters out failed tests,
/ checks if all tests passed, displays the test results, and returns the test results.

runTests:{
  delete from KUTR; 
  KUltf[bddCurrentTestSet];  / Set up the test environment
  KUrt[];  / Run the tests
  ft::select code: trunc[50] each str each code, timestamp from KUTR where not ok;
  er::$[0=count ft; (); checkVector reverse "~" vs str exec last code from KUTR where not ok] ;
  result: $[(count ft) ~ 0; "All tests passed"; ft];  / Check if all tests passed
  result  / Return the test results
 };

/ Get the right row 
findRow: {
 index: $[x >= 0; x; ((count ft) + x)];   
 ft index
 }

/ trucate a char vector y to x length
trunc:{$[x<count y;x#y;y]}

/ convert to string, but leave strings alone
str:{10=type x; x; string x} ;

/ get dimensions of a nested list
shape:{$[0=d:depth x; 
  0#0j; 
  d#{first raze over x}each(d{each[x;]}\count)@\:x]
  }; 

/ checkVector[list-of-q-statements]
/  Evaluates the statements, producing a list of descriptions of the results 
checkVector: {evaluate each x}  ;
evaluate:{  
  result: .Q.trp[ value; 0N!x; {[e;bt] 0N!formatError[e; .Q.sbt bt]} ] ;
  checkResult result
 } ; 

formatError:{[e;sbt]
   e:$[10=type e; e; string e] ;
   sbt:"\n ", trim first "\n" vs sbt ;
   "Error: ", ltrim $[("error"~ lower 5# e) and e[5] in (" "; ":"); 6_e; e]
 };

checkResult:{
  out:()!() ;
  out[`]: (::) ;
  out[`isList]: 0<=type x ; 
  out[`length]: count x   ;   
  out[`shape]: "" ; /shape x    ;
  out[`type]: getType x   ;   
  out[`avg]:  agg[avg] x  ;
  out[`min]:  agg[min] x  ;
  out[`max]:  agg[max] x  ;
  if[(10=type x) and "Error:"~6#x; out[`type]:`error] ;
  `_ out  
 } ; 

getType:{[x]
  num:abs type x ; 
  if[num<20; :atypes num] ;
  if[num within (20;76); :"enum"] ;
  if[num within (77;97); :"type ", num] ;
  if[num=98; :"table"] ;
  if[num=99; :$[98= type key x; "keyed table"; "dictionary"]] ;
  if[num within (100;111); :"function"] ;
  if[num>111; :"type ", num] ;
 };

agg:{[f;v] @[f; (raze/) v; 0n]} ;
atypes:(0 1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19h)!("general"; "boolean"; "guid"; "byte";
  "short"; "int"; "long"; "real"; "float"; "char"; "symbol"; "timestamp"; "month"; "date"; "datetime";
  "timespan"; "minute"; "second"; "time") ;

