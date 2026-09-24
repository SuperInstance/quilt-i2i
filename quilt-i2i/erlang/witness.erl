%% witness.erl — FNV-1a 64-bit witness as an Erlang function.

-module(witness).
-export([fnv1a64/1]).

-define(FNV1A64_OFFSET, 16#cbf29ce484222325).
-define(FNV1A64_PRIME,  16#100000001b3).
-define(MASK64,         16#ffffffffffffffff).

fnv1a64(Binary) ->
    foldl(fun(B, Acc) -> ((Acc bxor B) * ?FNV1A64_PRIME) band ?MASK64 end,
          ?FNV1A64_OFFSET,
          binary_to_list(Binary)).
