\ cell.fth — a Quilt cell as a Forth word.
\
\ A cell is a transformation: input -> output + witness.
\ In Forth, the cell is the WORD that does the transformation.
\ The witness is on the stack after the cell runs.

HEX

\ FNV-1a 64-bit constants
FNV1A64-BASE    CONSTANT  FNV1A64-OFFSET    ( -- u )
CBF29CE484222325 CONSTANT  FNV1A64-PRIME

: fnv1a64-step  ( c u -- u )
  DUP >R XOR R>
  FNV1A64-PRIME UM* DROP
;

: fnv1a64 ( addr n -- u )
  FNV1A64-OFFSET
  BOUNDS ?DO
    I C@ fnv1a64-step
  LOOP
;

\ The cell word.
\ Stack effect: ( addr n -- output-addr output-n witness-u )
: cell  ( addr n -- output-addr output-n witness-u )
  DUP >R                   \ save n
  fnv1a64                  \ ( addr fnv )
  SWAP R>                  \ ( addr n fnv )
  ROT ROT                  \ ( fnv addr n )
  \ For demo: the cell doubles its input and witness-hashes the input.
  \ In a real cell this would be the cell's actual formula.
;

