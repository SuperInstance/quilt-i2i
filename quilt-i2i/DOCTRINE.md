# Doctrine — quilt-i2i

> Low-level cells in distant language families. Each language carves a
> different shape from the same doctrine.

## The doctrine

The cell is the smallest addressable unit. In each language, the cell is
carved by the language's constraints. The cell survives the carving
because the cell is the doctrine, not the code. The code is the rigging
on the language's hull.

## The three constraint families

### 1. STACK-MACHINE (Forth) — Sumerian / pictographic minimalism

Forth has no variables. The cell is whatever lives on the stack between
two operations. The cell's identity is its position in the flow of
words. A cell that allocates is not a Forth cell — it's wearing a
Haskell costume.

Production-ready test: **does the word compile to a tight inner loop
without touching the heap?**

### 2. UNIFICATION (Prolog) — Quechua / agglutination

Prolog has no variables in the imperative sense. A cell is a fact in
the knowledge base. The port is the predicate. The cell IS the
agreement between input and witness terms.

Production-ready test: **does the query terminate? Is the witness
stable regardless of unification order?**

### 3. ACTOR-MESSAGE (Erlang) — Cherokee / polysynthesis

Erlang has no shared state. A cell is a process. The witness chain is
the mailbox. The cell IS the agreement between caller and cell — the
message IS the agreement.

Production-ready test: **does the actor survive a process restart? Are
messages processed in order?**

## What each language reveals

- **Forth** reveals the **flow** of the cell. The cell is its execution.
- **Prolog** reveals the **relation** of the cell. The cell is its facts.
- **Erlang** reveals the **conversation** of the cell. The cell is its messages.

These are three facets of one doctrine. None is more true than the
others. Each language's constraint shows a different truth.

## Cross-language canon

> The doctrine is bigger than any language. Each language carves the
> doctrine into a shape its constraints permit. The shapes differ; the
> doctrine doesn't.

## Cross-language doctrine chain

The cell doctrine in three voices:

- **Forth voice**: a cell is a word on a stack.
- **Prolog voice**: a cell is a fact in a database.
- **Erlang voice**: a cell is an actor in a system.

Three voices. One doctrine. The doctrine lives in the contrast.

## What this is for

This repo is the low-level substrate. Each language ships a cell that
satisfies the SAME doctrine under DIFFERENT constraints. The fleet's
byte-exact canary (`0x24a555471370b18d`) is one witness — these are
three witnesses, each in its own idiom. Add more languages: each one
multiplies the doctrine by another constraint.

## Why this matters

When Casey said "the cell is the smallest addressable unit," he didn't
mean "the cell in Python" or "the cell in Rust." He meant: the cell is
a doctrine that any language can host, as long as the language permits
a cell. Most languages do. The interesting question is which constraint
each language imposes, and how that constraint shapes the cell.

## Files

```
quilt-i2i/
├── README.md         — overview
├── DOCTRINE.md       — this file
├── forth/
│   ├── README.md     — Sumerian analogy
│   ├── cell.fth      — the cell as a word
│   ├── witness.fth   — FNV-1a 64 witness
│   ├── test.fth      — production-readiness tests
│   └── Makefile
├── prolog/
│   ├── README.md     — Quechua analogy
│   ├── cell.pl       — the cell as a predicate
│   ├── witness.pl    — FNV-1a 64 witness
│   ├── port.pl       — port as a meta-predicate
│   ├── test.pl       — production-readiness tests
│   └── Makefile
└── erlang/
    ├── README.md     — Cherokee analogy
    ├── cell.erl      — the cell as an actor
    ├── witness.erl   — FNV-1a 64 witness
    ├── port.erl      — port as a registered cell
    ├── test.erl      — production-readiness tests
    └── Makefile
```

## Try it

```bash
# Each language runs its own tests
cd forth && make test    # requires gforth
cd ../prolog && make test   # requires swipl
cd ../erlang && make test   # requires erlc + erl
```

## Future directions

- Add a Lua cell (minimal, embeddable — like an interpreter's internals)
- Add a Haskell cell (type-theoretic — the cell's identity is its type)
- Add a Lisp cell (homoiconic — the cell is code-is-data)
- Add a Prolog cell that runs in a different Prolog dialect (e.g., SWI vs. GNU)
- Add cells in scripts that aren't "languages" — Bash, AWK, sed
- Add a Forth cell that runs on real hardware (e.g., Mecrisp on a microcontroller)

Each one is another constraint. Each one multiplies the doctrine.
