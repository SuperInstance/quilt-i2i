% cell.pl — a Quilt cell as a Prolog fact + rule.
%
% A cell is a relation: cell(ID, Input, Output, Witness).
% Calling cell(id_1, 5, X, W) unifies X=10, W=witness(5).
%
% Prolog cells demonstrate the doctrine's relational form: the cell is
% the agreement between the input term and the witness term.

:- module(cell, [cell/4, witness_of/2]).

% A simple cell: input doubled, witness computed by fnv1a64
cell(id_doubler, Input, Output, Witness) :-
    Input >= 0,
    Output is Input * 2,
    witness_of(Input, Witness).

% Witness is the FNV-1a-64 hash of the input (stub — full impl in witness.pl)
witness_of(Input, Witness) :-
    hex_hash(Input, Witness).

% Stub hash function (replace with real FNV-1a-64 in witness.pl)
hex_hash(N, Hash) :-
    Hash is (N * 2654435761) mod 4294967296.
