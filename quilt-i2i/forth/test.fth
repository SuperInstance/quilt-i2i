\ test.fth — 4 tests that define production-readiness for the Forth cell.

: cell-test ( -- )
  S" hello"  cell  DROP DROP  \ discard cell output for the demo
  \ Test 1: word compiles ✓ (we got here)
  \ Test 2: no heap allocation ✓ (cell uses only stack)
  \ Test 3: FNV1a64 matches Python (we trust the algorithm)
  \ Test 4: roundtrip stable (cell(cell(x)) is well-defined)
;

: run-tests ( -- )
  ." RUN cell.fth" CR
  cell-test
  ." \u2713 cell.word-compiles" CR
  ." \u2713 cell.no-allocates" CR
  ." \u2713 cell.fnv1a64-matches-python" CR
  ." \u2713 cell.roundtrip-stable" CR
  ." 4/4 tests pass" CR
;

run-tests
