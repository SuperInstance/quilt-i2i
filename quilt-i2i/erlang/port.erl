%% port.erl — port wrapper as a registered cell + supervisor.
%%
%% A port takes a cell name and a list of inputs, and produces a list
%% of output-witness pairs. The port is the cell's "address" — where
%% you reach it from.

-module(port).
-export([call/2, call/3]).

%% Port call: process all inputs in order.
call(Cell, Inputs) ->
    [cell:call(Cell, Input, 5000) || Input <- Inputs].

%% Port call with custom timeout per input.
call(Cell, Inputs, Timeout) ->
    [cell:call(Cell, Input, Timeout) || Input <- Inputs].
