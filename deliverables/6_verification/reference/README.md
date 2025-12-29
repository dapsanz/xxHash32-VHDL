This subdirectory contains a modified reference implementation written in C.

The test vectors are defined in test_vectors.c. Each scenario is labeled s1, s2, etc., where s1 corresponds to scenario 1.

Building:
- To build with debug output (prints intermediate results):
  make debug
- To build normally:
  make

Running:
After building, run:
  ./main
This runs scenario 5 by default.

To run a different scenario:
  ./main sx
where x is the scenario number.
Example (scenario 3):
  ./main s3
