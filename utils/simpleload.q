
defaultType:{[column] 
  sample: $[100>=count column; column; 100# column] ;
  sample: sample where {not (trim x) in ("NA";"")} each sample ;     /remove nulls from sample
  if[0= count sample; :column] ;                                     /all nulls?                 leave as string
  if[all not null "J"$sample; :"J"$column] ;                         /all parse as integer?      return as integer
  if[all not null "F"$sample; :"F"$column] ;                         /all parse as float?        return as float
  if[all not null "D"$sample; :"D"$column] ;                         /all parse as date?         return as date 
  if[all not null "P"$sample; :"P"$column] ;                         /all parse as timestamp?    return as timestamp
  if[all not null "N"$sample; :"N"$column] ;                         /all parse as timespan?     return as timespan
  if[(128>max count each column) and 128> count distinct column; :`$column];  /none to long or too many?  return as symbol 
  column
 };

readAll:{[namespace; dirPath]
  if[10<>type dirPath; dirPath:string dirPath] ;
  if[":"=first dirPath; dirPath: 1 _ dirPath] ;
  list: system "ls ", dirPath ;
  path: hsym `$ (dirPath, "/"),/: list ;
  data:  readCsv each path ;
  names: {a:last where x="/"; if[not null a; x:(a+1) _ x]; b:first where x="."; if[not null b; x:(b-count x) _ x]; `$x} each list;

  if[null namespace; :(names!data)] ;   /namespace: ` produces dictionary; `. default namespace; `.xyz namespace xyz

  if[10<>type namespace; namespace: string namespace] ;
  if[namespace in (""; string "."); names set' data; :names] ;
  if["."<> first namespace; namespace: ".", namespace];  
  names: `$ (namespace, ".") ,/: string names ;
  names set' data;
  names
 };

readCsv: {[filePath]
  dlm: ","; 
  text: read0 filePath;
  flds: 1+count where (first text)=dlm ; 
  typs: flds # "*" ;

  table: (typs; enlist dlm) 0: text ;
  table: flip defaultType each flip table ;
  nam:`$ ssr[;" ";"_"] each string cols table;
  nam xcol table
 };

/ source: is a namespace or dictionary of tables.
/ colnames: a list of symbols representing column names
/ output: a single table containing the named columns
/ with an extra column whos name must be specified as 
/ "newcol" containing the name of the table in the source.
combine:{[newcol; source; colnames]
  if[newcol=`; newcol:`nam] ;
  src:$[0=count colnames; source; extract[colnames] each source] ;
  name: key src ;
  data: value src ;
  if[99=type data; data: value data] ;
  if[data[0]=(::); data: 1 _ data; name: 1 _ name] ;

  newcol xcol `XNAMX xcols (,/) {[n;d] update XNAMX:n from d}'[name;data]
 }

extract:{[colnams; tbl] flip colnams! tbl colnams} ;


/ use it: `:path/to/yourfile.txt

/readAll[`.hist; `:/Users/eric/repos/k9AndKdbExamples/interview/code/historicalPrices] 

