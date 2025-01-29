// descend is a Q function which returns a list of the descendent IDs of the root ID in the given table tbl.. 
    // argument: tbl is a table with a column of IDs and a column of parent IDs. 
    // argument: idcol is the name of the column in tbl that contains the IDs as a symbol. 
    // argument: pidcol is the name of the column in tbl that contains the parent IDs as a symbol. 
    // argument: id is the ID of the root node we are descending from. 
// descend returns a list of the descendent IDs of the root ID in the given table tbl, including the root ID. 
//    test:(asc descend[.car.autoparts;`ID;`Super_Component_ID;1]) ~ `s#0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
//    test:(asc descend[.car.autoparts;`ID;`Super_Component_ID;2]) ~ `s#2 3 4 5 8 9 
//    test:(asc descend[.car.deep_university_physics_hierarchy;`ID;`Super_Component_ID;2]) ~ `s#2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 
//    test:(asc descend[.car.deep_university_physics_hierarchy;`ID;`Super_Component_ID;2]) ~  `s#2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18   19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35   36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57   58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82   83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 

descend:{[tbl;idcol;pidcol;id]
    // get the children of the root node
    children:select idcol from tbl where pidcol=id;
    // get the children of the children of the root node
    grandchildren:descend[tbl;idcol;pidcol;children];
    // return the root node, the children of the root node, and the children of the children of the root node
    raze id,children,grandchildren;
    }

    





// rdescend is a Q function which returns a list of the descendent IDs of the root ID in the given table tbl recursively.. 
    // argument: tbl is a table with a column of IDs and a column of parent IDs. 
    // argument: idcol is the name of the column in tbl that contains the IDs as a symbol. 
    // argument: pidcol is the name of the column in tbl that contains the parent IDs as a symbol. 
    // argument: id is the ID of the root node we are descending from. 
// rdescend returns a list of the descendent IDs of the root ID in the given table tbl, including the root ID. 
//    test:(asc rdescend[.car.autoparts;`ID;`Super_Component_ID;1]) ~ `s#1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
//    test:(asc rdescend[.car.autoparts;`ID;`Super_Component_ID;2]) ~ `s#2 3 4 5 8 9 
//    test:(asc rdescend[.car.deep_university_physics_hierarchy;`ID;`Super_Component_ID;2]) ~ `s#2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 
//    test:(asc rdescend[.car.deep_university_physics_hierarchy;`ID;`Super_Component_ID;2]) ~  `s#2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18   19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35   36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57   58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82   83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 
