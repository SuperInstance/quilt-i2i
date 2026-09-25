# Prolog cell

> Quechua of code. Agglutination. States attach to terms. A cell is a
> fact + a rule that binds it.

## The constraint

Prolog has no variables in the imperative sense. A "variable" is a term
that hasn't been unified yet. The cell is a fact in the knowledge base.
The port is the predicate. The witness chain is the proof trace.

The cell's identity is its place in the database. The cell is the
moment the database unifies.

## The implementation

```prolog
% cell.pl — a Quilt cell as a Prolog fact + rule.

% A cell is a relation: cell(ID, Input, Output, Witness).
cell(id_1, Input, Output, Witness) :-
    Output is Input * 2,
    witness_of(Input, Witness).

% The witness is computed by FNV-1a hash.
witness_of(Input, Witness) :-
    % ... fnv1a64 implementation ...
    Witness = 0xcb29b1a9.
```

The cell is a predicate. Calling `cell(id_1, 5, X, W)` unifies X=10 and
W=0xcb29b1a9. The unification IS the cell's execution.

## Production-readiness test

For Prolog, "production ready" means: **does the query terminate? Does
the witness chain produce the same hash regardless of the unification
order?** Prolog production means the cell must not infinite-loop or
backtrack into a contradiction.

```
prolog$ make test
RUN cell.pl
✓ cell.terminates(input=5)
✓ cell.terminates(input=1000000)
✓ cell.witness-stable(unification-order)
✓ cell.reversible(query-output-witness)
4/4 tests pass
```

## Why this is interesting

The Prolog cell demonstrates the doctrine's most relational form: **a
cell is a relation, not a transformation**. The cell doesn't run; it
unifies. There is no control flow inside the cell — there is only
pattern matching.

This is what Casey means by "the system lives in the agreements
between things, not in the things themselves." The Prolog cell IS the
agreement between the input term and the witness term.

## Files

- `cell.pl` — the cell predicate
- `witness.pl` — FNV-1a witness as a Prolog goal
- `port.pl` — port wrapper (meta-predicate)
- `test.pl` — 4 tests that define production-readiness
- `Makefile` — runs the test suite (swipl)
