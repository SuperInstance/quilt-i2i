% port.pl — port wrapper as a meta-predicate.
%
% A port takes a cell and a list of inputs, and produces a list of
% (output, witness) pairs. The port is the cell's "address" — where
% you reach it from.

:- module(port, [port/3]).

% port(Cell, Inputs, Results) — Results is a list of output-witness pairs
port(Cell, [], []).
port(Cell, [Input|Rest], [Output-Witness|Results]) :-
    cell:cell(Cell, Input, Output, Witness),
    port(Cell, Rest, Results).
