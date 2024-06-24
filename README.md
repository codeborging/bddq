# bdd.q: A Tool for AI Programming and Documenting with Tests in Q

## Overview

`bdd.q` is a program designed to facilitate the documentation and
testing of a q function. It allows you to define the name of a function,
provide a detailed specification of its functionality, describe each
argument and the return value, and provide test cases.

`bdd.q` is designed to also help a programmer make good use of "AI
Pair Programming" systems like:

* [GitHub Copilot](https://github.com/features/copilot)
* [Deep Seek](https://www.deepseek.com/)
* [Codeium](https://codeium.com/)

Many agree that test cases serve as excellent documentation because they:

- Provide clear examples of how functions are intended to be used.
- Ensure the documentation is always up-to-date, as successful test
  cases confirm the accuracy of the documented behavior.

This tool allows us to document our code and give AI systems a chance to
generate some of it for us based on careful specs with test cases. 

## Features

- **testSetNew**: Specifies where the tests should be stored.
- **addDoc**: Defines the function name and provides a description of what it does.
- **describeArg**: Describes the arguments of the function.
- **describeResult**: Details the expected results.
- **addTest**: Constructs a test that will be runnable using [`k4unit.q`](https://github.com/DataIntellectTech/TorQ/blob/master/tests/k4unit.q).

We call these above 5 functions in the code files with the q code we want to test.

See the example arecursion.q. 

## Usage

To use `bdd.q`, a programmer will load a file that includes calls to
the following functions: `testset new`, `addDoc`, `describeArg`, and
`addTest`. Once the setup is complete, running the `runTest` function
will execute the test cases, indicating which ones succeed and which
fail.

### Example Workflow

1. **Define the test set location**:

   ```q

   testSetNew[`:tests/descend.csv; `:ddummy.q]

   ```

2. **Add documentation for a function**:

   ```q
   addDoc["descend"; "returns a list of the descendent 
     IDs of the root ID in the given table tbl."];
   ```

3. **Describe an argument to the function**:

example: 

   ```q
   describeArg["tbl"; "a table with a column of IDs and a 
     column of parent IDs"];
   ```

4. **Describe the expected results**:

   ```q
   describeResult["descend"; "a list of the descendent 
      IDs of the root ID in the given table tbl, 
      including the root ID."];
   ```

5. **Add a test case**:

   ```q
   addTest[{(asc descend[.car.autoparts;`ID;`Super_Component_ID;2]) 
   ~ `s#2 3 4 5 8 9};"find the children of engine."];
   ```

6. **Run the tests**:

   ```q
   q)runTests[]

   2024.06.24T12:04:04.506 start
   2024.06.24T12:04:04.506 :tests/descend.csv 16 test(s)
   2024.06.24T12:04:04.511 end
   code                                                 timestamp              
   ----------------------------------------------------------------------------
   "(asc descend[.car.autoparts;`ID;`Super_Component_I" 2024.06.24T12:04:04.509

   ```

## Integration with Copilot

The system also generates a `dummy.q` file designed to be used by
tools like Copilot and Codium, enhancing the development experience by
providing context-aware suggestions.

## Conclusion

`bdd.q` combines function documentation and testing in a seamless
manner, helping programmers maintain accurate and reliable
codebases. By using this tool, you can ensure that your function
specifications and test cases are always in sync, boosting your
confidence in the correctness of your code.

## Here is how we get an example running

```
$ git clone git@github.com:codeborging/bddq.git
$ cd bddq/examples
$ q loader.q -p 6002
q)\l arecursion.q
q)runTests[]
2024.06.24T19:24:35.935 start
2024.06.24T19:24:35.935 :tests/descend.csv 8 test(s)
2024.06.24T19:24:35.937 end
"All tests passed"
```

