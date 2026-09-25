# quilt-i2i

> Low-level Quilt cells in distant language families. Each implementation
> shows how the language's *constraints* shape the cell — what production-
> ready means in each idiom.

The point is not to port the same code. The point is that each language's
constraints make a different cell. The cell is the same doctrine; the
shape of the doctrine is what each language carves out of it.

## The three languages

| Language | Constraint family | Why it's distant |
|----------|-------------------|-------------------|
| **Forth** | stack-machine, minimal words, postfix | Like Sumerian: pictographic minimalism. Each word is one operation. The cell lives on the stack. |
| **Prolog** | unification, facts+rules, no control flow | Like Quechua agglutination: states attach to terms. A cell is a fact + a rule that binds it. |
| **Erlang** | actors, mailboxes, no shared state | Like Cherokee polysynthesis: one actor IS the whole clause. Receipts are messages, not variables. |

## Why these three

Casey's doctrine: each language's constraints shape the test for
production-readiness. The test for a Forth cell is "does it compile to
the stack correctly?" The test for a Prolog cell is "does the
unification terminate?" The test for an Erlang cell is "does the actor
survive a process restart?" Three different tests, three different
definitions of done.

## The cell, in each language

```
forth/prolog/erlang$ cat README.md  # for each
```

Each implementation has:
- A single cell: input, output, witness
- A port wrapper (where the language permits)
- A witness chain (where the language permits)
- A production-readiness test that matches the language's idiom
- A short note on how the constraint shaped the implementation

## How to read this repo

Start at `forth/`. The stack is the cell. The witness is the drop.
Run the Forth, then the Prolog, then the Erlang. The differences in
implementation are the doctrine. The sameness of doctrine is the cell.

## Cross-language doctrine

> A cell is the smallest addressable unit. In each language, the cell is
> carved by the language's constraints. The cell survives the carving
> because the cell is the doctrine, not the code. The code is the
> rigging on the language's hull.

See `DOCTRINE.md` for the full writeup.
