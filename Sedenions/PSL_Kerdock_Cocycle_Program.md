# PSL(2,7), Kerdock, and Cocycle Program

This workstream sits between the finite algebra theorem and the deeper
Barnes-Wall/Kerdock interpretation.

## Motivation

The count:

```text
168 primitive unit zero-divisor directions
```

matches:

```text
|PSL(2,7)| = |GL(3,2)| = 168.
```

This is not itself a theorem.  The theorem to seek is an explicit signed group
action.

## Unsigned Action

The seven nonzero elements of `F_2^3` carry the natural `GL(3,2)` action.  In
the sedenion indexing:

```text
a = (h,i),  i in F_2^3.
```

The nonzero `i` labels are the likely strut or Fano-plane coordinates.

First test:

```text
Does GL(3,2) permute the 42 mixed assessor supports?
```

Expected answer: yes for the unsigned supports, after the convention is fixed.

## Signed Action

The real question is whether the action preserves the Cayley-Dickson signs.

For `g in GL(3,2)`, compare:

```text
omega((h,i),(h',j))
```

with:

```text
omega((h,g i),(h',g j)).
```

Possible outcomes:

- exact preservation;
- preservation up to a gauge change `e_a -> epsilon(a) e_a`;
- preservation only on zero-divisor plaquettes;
- no sign preservation.

The best theorem would be:

```text
The sedenion zero-divisor plaquette complex carries a GL(3,2)-equivariant
signed affine-plane system, up to gauge.
```

## Kerdock / Z4 Direction

The unsigned code `C_ZD` is not expected to be the Nordstrom-Robinson code and
should not be advertised that way.  The plausible route is subtler:

```text
signed C_ZD -> Z_4 lift -> Kerdock / Delsarte-Goethals neighborhood.
```

Tasks:

1. Convert the plaquette signs into a `Z_4` phase function.
2. Test whether the phase function is quadratic.
3. Search for a `Z_4`-linear code whose Gray image or shortened image matches
   the signed geometry.
4. Compare automorphism groups with the `GL(3,2)` action.
5. Only then compare to Kerdock, Preparata, or Barnes-Wall glue data.

## Flavor-Physics Link

`PSL(2,7)` appears in flavor-model literature, but the safe bridge here is
finite and algebraic:

```text
signed zero-divisor geometry -> explicit PSL(2,7)-equivariant object.
```

Only after that should one ask whether this object has any relation to
phenomenological flavor groups.
