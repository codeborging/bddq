/ Experments in Avoiding Recursion in q

// Descend takes in a table, an id column, a 
// parent id column, and an id value. The function uses these inputs to 
// perform a descent through the table to find all the descendants of the given id, using scan
// not recursion.

descend:{[tbl; icol; pcol; id]
  children:{[tbl;icol;pcol;id] (tbl icol) where (tbl pcol) in id} ;
  raze (children[tbl;icol;pcol;]\) enlist id
 }

// Children takes three arguments: ID, PID, and tier. 
// It filters the ID values where the PID is 
// in the tier list and returns the result. 
children:{[ID;PID;tier] ID where PID in tier};

/ Add next tier of children based on the IDs in the last sublist
addNextTier:{[ID;PID;acc] acc,: children[ID;PID;] each last acc; acc};

/ Here is a test set for the descend function

testSetNew[`:tests/descend.csv; `:ddummy.q]
addDoc["descend"; "returns a list of the descendent IDs of the root ID in the given table tbl."];
describeArg["tbl"; "a table with a column of IDs and a column of parent IDs"];
describeArg["idcol"; "the name of the column in tbl that contains the IDs as a symbol"];
describeArg["pidcol"; "the name of the column in tbl that contains the parent IDs as a symbol"];
describeArg["id"; "the ID of the root node we are descending from"];
describeResult["descend"; "a list of the descendent IDs of the root ID in the given table tbl, including the root ID."];
addTest[{(asc descend[.car.autoparts;`ID;`Super_Component_ID;1]) ~ `s#0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16};"find the children of car."];
addTest[{(asc descend[.car.autoparts;`ID;`Super_Component_ID;2]) ~ `s#2 3 4 5 8 9};"find the children of engine."];
addTest[{(asc descend[.car.deep_university_physics_hierarchy;`ID;`Super_Component_ID;2]) ~ `s#2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100};""];
addTest[{(asc descend[.car.deep_university_physics_hierarchy;`ID;`Super_Component_ID;2]) ~ 
  `s#2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 
   19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 
   36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 
   58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 
   83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100};""];

rdescend:{[tbl;idcol;pidcol;id]
   ID: tbl idcol;    / Get a vector of IDs 
   PID: tbl pidcol;  / and the parallel parent IDs
  (raze/) rdescend1[tbl;ID;PID;enlist id]
    }

rdescend1:{[tbl;ID;PID;ids]
    kids: children[ID;PID;ids];
    // if there are no children, return the current node
    if[0=count kids;:ids];
    // otherwise, return the current node and the descendents of the children
    ids,rdescend1[tbl;ID;PID;] each kids
    }

addDoc["rdescend"; "returns a list of the descendent IDs of the root ID in the given table tbl recursively."];
describeArg["tbl"; "a table with a column of IDs and a column of parent IDs"];
describeArg["idcol"; "the name of the column in tbl that contains the IDs as a symbol"];
describeArg["pidcol"; "the name of the column in tbl that contains the parent IDs as a symbol"];
describeArg["id"; "the ID of the root node we are descending from"];
describeResult["rdescend"; "a list of the descendent IDs of the root ID in the given table tbl, including the root ID."];
addTest[{(asc rdescend[.car.autoparts;`ID;`Super_Component_ID;1]) ~ `s#1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16};"find the children of car."];
addTest[{(asc rdescend[.car.autoparts;`ID;`Super_Component_ID;2]) ~ `s#2 3 4 5 8 9};"find the children of engine."];
addTest[{(asc rdescend[.car.deep_university_physics_hierarchy;`ID;`Super_Component_ID;2]) ~ `s#2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100};""];
addTest[{(asc rdescend[.car.deep_university_physics_hierarchy;`ID;`Super_Component_ID;2]) ~ 
  `s#2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 
   19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 
   36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 
   58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 
   83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100};""];


