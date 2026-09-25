%% cell.erl — a Quilt cell as an Erlang process.
%%
%% A cell is a registered process that receives messages, computes
%% outputs, and replies with witnesses. Erlang cells demonstrate the
%% doctrine's message-passing form: the cell has no shared state; it
%% has a mailbox.

-module(cell).
-export([start/1, stop/1, call/3, compute/1]).

%% Start a cell with a given ID.
start(ID) ->
    register(ID, spawn(fun() -> loop() end)).

%% Stop a cell.
stop(ID) ->
    ID ! stop.

%% Call the cell: send Input, receive {Output, Witness}.
call(ID, Input, Timeout) ->
    Ref = make_ref(),
    ID ! {call, self(), Ref, Input},
    receive
        {Ref, Reply} -> Reply
    after Timeout ->
        timeout
    end.

%% The cell's main loop.
loop() ->
    receive
        {call, From, Ref, Input} ->
            Reply = compute(Input),
            From ! {Ref, Reply},
            loop();
        stop ->
            ok
    end.

%% The cell's actual behavior (stub for demo).
compute(Input) when is_integer(Input) ->
    Witness = witness:fnv1a64(term_to_binary(Input)),
    {Input * 2, Witness}.
