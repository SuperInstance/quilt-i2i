\ witness.fth — FNV-1a 64-bit witness implementation.
\
\ A witness is the receipt that this cell ran with this input and
\ produced this output. The witness lives on the stack.

HEX
FNV1A64-BASE    CONSTANT  FNV1A64-OFFSET
CBF29CE484222325 CONSTANT  FNV1A64-PRIME

: fnv-step  ( c u -- u )
  DUP >R XOR R>
  FNV1A64-PRIME UM* DROP
;

: witness-of  ( addr n -- u )
  FNV1A64-OFFSET
  BOUNDS ?DO
    I C@ fnv-step
  LOOP
;

\ Verify two inputs produce the same witness.
: witness-match?  ( a1 n1 a2 n2 -- flag )
  >R >R witness-of  R> R> witness-of  =
;
