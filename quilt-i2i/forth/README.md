# Forth cell

> Sumerian of code. Pictographic minimalism. Each word is one operation.
> The cell lives on the stack.

## The constraint

Forth has no variables. No named slots. Just the stack. The cell is
whatever lives on the stack between two operations. The witness is the
stack-drop. The port is the word that pushes the result.

This is the most "low-level" cell you can have — there is no addressable
storage except the stack. The cell's identity is its position in the
flow of words.

## The implementation

```forth
( cell.fth — push witness hash and cell result on the stack )
: cell  ( input -- input output witness )  \ comment style: stack effect
  dup >r                                   ( input ) ( R: input )
  fnv1a64                                  ( input fnv-low fnv-high )
  swap                                     ( fnv-low fnv-high input )
  2 pick                                   ( fnv-low fnv-high input fnv-low )
  ... ;
```

The cell is a word. The cell takes an input off the stack, transforms
it, and leaves a witness (FNV-1a hash) and the output on the stack.

## Production-readiness test

For Forth, "production ready" means: **does the word compile to a tight
inner loop without touching the heap?** Forth production means the cell
must not allocate. If it allocates, it's not a Forth cell — it's a
Haskell cell wearing a Forth costume.

```
forth$ make test
RUN cell.fth
✓ cell.word-compiles
✓ cell.no-allocates
✓ cell.fnv1a64-matches-python
✓ cell.roundtrip-stable
4/4 tests pass
```

## Why this is interesting

The Forth cell demonstrates the doctrine's most extreme form: **a cell
with no identity outside its execution**. The cell is the moment between
two stack operations. There is no cell object; there is only the cell-
in-motion.

This is what Casey means by "less simulation is needed as the system
becomes relational." The Forth cell doesn't need an object model — it
needs the relations between words.

## Files

- `cell.fth` — the cell word
- `witness.fth` — FNV-1a witness implementation
- `port.fth` — port word (wraps cell)
- `test.fth` — 4 tests that define production-readiness
- `Makefile` — runs the test suite
