# Task: close the two Moufang holes via ARTIN LINEARIZATION (fresh route)

Project: Lean 4 (v4.28.0) + Mathlib. Package: Stage2 (composition-algebra
doubling laws, ~13 lemmas PROVEN including LEFT and RIGHT ALTERNATIVE
laws, orthogonal commutation, associator skew, Teichmueller, polar) +
Target. Two holes remain in Stage2: the pair around the right Moufang
identity.

## History you must respect (why this is a fresh route)

A previous 11h attempt produced a CIRCULAR decomposition: it introduced
`associator_product_entry_right` -
`((x*y)*z)*y - (x*y)*(z*y) = ((x*y)*z - x*(y*z))*y` - which on expansion
IS the right Moufang identity restated (subtract-and-rearrange), then
"closed" `mul_right_moufang` from it by `grind`. DO NOT decompose into
product-entry reshuffles of the goal. Any intermediate you introduce must
be PROVEN from the alternative laws, not equivalent to the target.

Also on record (kernel-relevant): the originally proposed
`associator_mul_right` (without the minus sign) is FALSE - octonion
counterexample `x = e1, y = e2, z = e4` gives `2 e5` vs `-2 e5`. The
corrected sign version is fine as an intermediate IF you prove it.

## The intended route (Schafer ch. III, classical Artin linearization)

In any algebra, define the associator `[x,y,z] = (x*y)*z - x*(y*z)`. The
PROVEN alternative laws give `[x,x,y] = 0` and `[x,y,y] = 0`; hence the
associator is ALTERNATING (skew in adjacent arguments; the package's
associator-skew lemma may already state this). Linearize:
`[x,y,z] + [y,x,z] = 0` and `[x,y,z] + [x,z,y] = 0`.

Right Moufang `(u*v)*(w*v) = (u*(v*w))*v` follows by the standard
computation: expand `[u*v, w, v]`, `[u, v, w*v]`, `[u, v*w, v]` etc. and
combine using alternation - the classical derivation closes with linear
combinations of alternating-associator identities (no reshuffle of the
goal itself). Prove whichever linearized lemmas you need as named
intermediates from the alternative laws.

## Targets

Close BOTH Stage2 holes (`mul_right_moufang` and its companion) with
statements unchanged, from the proven alternative laws. All downstream
Stage2 consumers must remain unchanged and hole-free.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do not weaken or restate the target identities.
- Verify with `lake env lean` on the Stage2 file.

## Success criteria

Both holes closed from genuinely independent intermediates = full
success (this unlocks the repo's Hurwitz `finrank in {1,2,4,8}`
hole-free merge). If the linearization stalls, land the proven
linearized-associator lemmas + a precise report of the missing step.
