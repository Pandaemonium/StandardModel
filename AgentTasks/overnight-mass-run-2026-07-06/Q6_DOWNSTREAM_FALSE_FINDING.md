# RED-FLAG FINDING: the Q6 downstream KP conclusions are FALSE as stated

Date: 2026-07-06 (overnight all-mass run). Discovered by Aristotle job A3
(`b6f17681`, the "close the two downstream Q6 sorries" job), which correctly
REFUSED to fabricate proofs and instead delivered kernel-checked refutations.
Verified by integration build (`lake env lean` clean, refutations `s o r r y`-free
at standard axioms).

## The finding

Two theorems in `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` that
carried "hard but presumed-true" `s o r r y`s since the four-day YM run are in
fact **mathematically FALSE**, even with the self-incompatibility hypothesis
`hself` (and, for the tail bound, even with the exact coercivity hypothesis):

1. **`kp_convergence_bound_of_selfIncompatible`** (the `exp(energyOf)`-AMPLIFIED
   cluster-sum bound `<= S.energy g0`). FALSE.
2. **`kp_tail_bound`** (the metric distance-tail bound with `exp(-mR)` decay).
   FALSE.

## Why they are false (mechanism)

The `KPCondition` here (`sum_{h !~ g} |w h| exp(energy h) <= energy g`) controls
the PLAIN (un-amplified) cluster sum. The false targets ask for the
`exp(energyOf)`-AMPLIFIED sum. Adding `hself` fixes the single-polymer diagonal
term, but it simultaneously makes every repeated-slot cluster `K_n` CONNECTED,
and those extra clusters add positive amplified mass beyond the `energy g0`
budget.

## Kernel-checked counterexamples (verified negatives, standard axioms, no sorry)

- **`SelfIncompatCex.selfIncompat_convergence_bound_false`**: single-polymer
  system `incompatible = True`, `weight = 3 e^-3`, `energy = 3` (KP holds with
  equality); coefficient `1/2` on the two-slot cluster gives amplified mass
  `|1/2| * (3 e^-3)^2 * e^6 = 9/2 > 3 = energy`. Refutes (1).
- **`TailCex.tail_bound_false`**: metric single-polymer system `weight = e^-1`,
  `energy = 1`, unit distance, `m = R = 1`, satisfying KP + `hself` + `hcoerce`;
  plain reaching-cluster sum `e^-1 + (1/2) e^-2 > e^-1 = energy * exp(-(mR))`.
  Refutes (2).

## The correct, PROVABLE replacement

- **`kp_convergence_bound_of_selfIncompatible_plain`**: the PLAIN (un-amplified)
  absolute cluster sum over clusters touching `g0` is `<= S.energy g0`. Proved
  from `kp_partial_sum_bound` + the `hself` diagonal consequence; depends only on
  the existing crux `pairSum_le_expBound` (introduces no new `s o r r y`).

## Current integration state (this commit)

- The refutations and the corrected `_plain` version are INTEGRATED (sorry-free).
- The two FALSE originals are KEPT with their `s o r r y`s BUT now carry
  docstrings stating they are false and pointing to the refutations (A3's
  "preserve verbatim, revise in tandem" choice). They are contained entirely in
  the draft/`s o r r y` layer - NO trusted (sorry-free) theorem depends on them,
  and the GateYM aggregator was already not-`s o r r y`-free (Q6 crux).

## REQUIRED FOLLOW-UP (tandem revision - NOT done tonight; needs coordination)

`StrongCouplingPolymerMap.plaquetteKP_convergence_bound_of_plaquetteKPBound`
CONSUMES the false `kp_convergence_bound_of_selfIncompatible`. That downstream
lemma's approach is therefore a DEAD END (built on a false lemma via the sorry).
It must be revised to consume `kp_convergence_bound_of_selfIncompatible_plain`
(the plain sum) instead - which likely changes the downstream KP-map statement
shape (plain vs amplified). This is a multi-file refactor touching
`StrongCouplingPolymerMap.lean` (four-day-run / codex lane) and should be done
with the file owner aware. Until then, the false originals remain as documented
handoffs. Once revised, DELETE the two false theorems.

## Discipline note

This is exactly the kernel-checked NEGATIVE the project rewards (cf.
`kp_convergence_bound_false`, the standing bare-KP disproof). The `exp(energyOf)`
amplification is the wrong shape; the plain KP sum is the right one. Do not
resurrect the amplified form.
