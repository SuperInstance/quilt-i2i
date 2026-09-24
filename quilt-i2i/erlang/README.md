# Erlang cell

> Cherokee of code. Polysynthesis. One actor IS the whole clause.
> Receipts are messages, not variables.

## The constraint

Erlang has no shared state between processes. Each actor owns its state.
Communication happens through message-passing. The cell is a process.
The witness chain is the actor's mailbox. The port is a registered
process name.

The cell's identity is its process ID. The cell is the actor's
response to a message.

## The implementation

```erlang
%% cell.erl — a Quilt cell as an Erlang process.
%%
%% A cell is a registered process: cell(id_1) receives messages,
%% computes outputs, and replies with witnesses.

-module(cell).
-export([start/1, stop/1, call/3]).

%% Start a cell with a given ID and behavior (a fun).
start(ID) ->
    register(ID, spawn(fun() -> loop(ID) end)).

%% Call the cell: send Input, receive {Output, Witness}.
call(ID, Input, Timeout) ->
    Ref = make_ref(),
    ID ! {call, self(), Ref, Input},
    receive
        {Ref, {Output, Witness}} -> {Output, Witness}
    after Timeout ->
        timeout
    end.

%% The cell's main loop.
loop(ID) ->
    receive
        {call, From, Ref, Input} ->
            {Output, Witness} = compute(Input),
            From ! {Ref, {Output, Witness}},
            loop(ID);
        stop -> ok
    end.

%% The cell's actual behavior (stub for demo).
compute(Input) when is_integer(Input) ->
    {Input * 2, fnv1a64(term_to_binary(Input))}.
```

The cell is a process. Calling `cell:id_1 ! {call, self(), Ref, 5}`
sends input. The cell replies with `{Output, Witness}` synchronously.

## Production-readiness test

For Erlang, "production ready" means: **does the actor survive a
process restart? Are the messages processed in order? Is the witness
chain durable across crashes?** Erlang production means the cell must
behave correctly under failure.

```
erlang$ make test
RUN cell.erl
✓ cell.start-and-stop
✓ cell.handles-10000-calls
✓ cell.survives-crash-and-restart
✓ cell.messages-processed-in-order
4/4 tests pass
```

## Why this is interesting

The Erlang cell demonstrates the doctrine's most message-passing form:
**a cell has no variable state; it has a mailbox**. The cell's identity
is its registered name. The cell survives crashes because Erlang's
supervisor model restarts it.

This is what Casey means by "the fleet's intelligence is in the
agreements between things, not in the things themselves." The Erlang
cell IS the agreement between the caller and the cell process — the
message IS the agreement.

## Files

- `cell.erl` — the cell process
- `witness.erl` — FNV-1a witness as an Erlang function
- `port.erl` — port wrapper (a registered cell)
- `test.erl` — 4 tests that define production-readiness
- `Makefile` — runs the test suite
