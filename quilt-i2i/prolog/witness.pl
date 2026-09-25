% witness.pl — FNV-1a-64 witness as a Prolog goal.
%
% FNV-1a 64-bit offset basis and prime.
% fnv1a_offset: 0xcbf29ce484222325
% fnv1a_prime:  0x100000001b3

:- module(witness, [fnv1a64/2]).

fnv1a64(String, Hash) :-
    fnv1a64_offset(Offset),
    string_codes(String, Codes),
    foldl(fnv_step, Codes, Offset, Hash).

fnv1a64_offset(14695981039346656037).   % 0xcbf29ce484222325
fnv1a64_prime(1099511628211).          % 0x100000001b3

fnv_step(Code, State, New) :-
    fnv1a64_prime(Prime),
    X is State xor Code,
    New is (X * Prime) mod 18446744073709551616.
