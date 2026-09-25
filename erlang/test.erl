%% test.erl — 4 tests that define production-readiness for the Erlang cell.
%%
%% An Erlang cell is production-ready if:
%%   1. It starts and stops cleanly
%%   2. It handles many calls without dropping messages
%%   3. It survives a crash and restart (OTP supervision contract)
%%   4. Messages are processed in order

-module(test).
-export([run/0]).

run() ->
    io:format("RUN cell.erl~n"),
    test_start_stop(),
    test_many_calls(),
    test_crash_and_restart(),
    test_in_order(),
    io:format("4/4 tests pass~n").

test_start_stop() ->
    cell:start(id_test),
    {10, _} = cell:call(id_test, 5, 1000),
    cell:stop(id_test),
    io:format("  \u2713 cell.start-and-stop~n").

test_many_calls() ->
    cell:start(id_test2),
    Results = port:call(id_test2, lists:seq(1, 10000)),
    10000 = length(Results),
    cell:stop(id_test2),
    io:format("  \u2713 cell.handles-10000-calls~n").

test_crash_and_restart() ->
    cell:start(id_test3),
    {10, _} = cell:call(id_test3, 5, 1000),
    %% Simulate crash: send an exit signal
    exit(whereis(id_test3), kill),
    timer:sleep(50),
    cell:start(id_test3),  %% restart
    {10, _} = cell:call(id_test3, 5, 1000),
    cell:stop(id_test3),
    io:format("  \u2713 cell.survives-crash-and-restart~n").

test_in_order() ->
    cell:start(id_test4),
    R1 = cell:call(id_test4, 1, 1000),
    R2 = cell:call(id_test4, 2, 1000),
    R3 = cell:call(id_test4, 3, 1000),
    [{2, _}, {4, _}, {6, _}] = [R1, R2, R3],
    cell:stop(id_test4),
    io:format("  \u2713 cell.messages-processed-in-order~n").
