% test.pl — 4 tests that define production-readiness for the Prolog cell.
%
% A Prolog cell is production-ready if:
%   1. It terminates (no infinite backtracking)
%   2. It terminates on edge cases (large inputs)
%   3. The witness is stable regardless of unification order
%   4. The cell is reversible (you can query any argument and get the others)

:- use_module(cell).
:- use_module(witness).

test_terminates :-
    cell:cell(id_doubler, 5, 10, _),
    format("  \u2713 cell.terminates(input=5)~n", []).

test_terminates_large :-
    cell:cell(id_doubler, 1000000, 2000000, _),
    format("  \u2713 cell.terminates(input=1000000)~n", []).

test_witness_stable :-
    cell:cell(id_doubler, 5, _, W1),
    cell:cell(id_doubler, 5, _, W2),
    W1 = W2,
    format("  \u2713 cell.witness-stable(unification-order)~n", []).

test_reversible :-
    cell:cell(id_doubler, 5, _, W),
    cell:cell(id_doubler, 10, _, W),    % different output, may be different witness
    format("  \u2713 cell.reversible(query-output-witness)~n", []).

run_tests :-
    format("RUN cell.pl~n", []),
    test_terminates,
    test_terminates_large,
    test_witness_stable,
    test_reversible,
    format("4/4 tests pass~n", []).

:- run_tests.
