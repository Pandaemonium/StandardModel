Close the two DOWNSTREAM `s o r r y`s in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`:
`kp_convergence_bound_of_selfIncompatible` (line ~1296, `s o r r y` at ~1312)
and `kp_tail_bound` (line ~1339, `s o r r y` at ~1362). These are the Q6
convergence + metric-tail conclusions.

CRITICAL SCOPE: **Do NOT touch `pairSum_le_expBound` (the crux, line ~972) or
its `s o r r y` at line 986.** That crux is being worked in two other jobs. Your
job is the two downstream conclusions, which are provable NOW on top of the
ALREADY-PROVED partial-sum machinery - independent of whether the crux is
closed (the crux's `s o r r y` does not block you; you may invoke the theorems
that transitively depend on it).

START: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.
If broader `lake build` stalls, SKIP it and return best progress.

## What is ALREADY PROVED above your targets (use these directly)

- `kp_tree_sum_bound (S) (hdec) (hKP) (g0) (s)` :
  `s.sum (fun X => spanningTreeCount .../ n! * absWeight) <= |weight g0| * exp(energy g0)`
- `kp_partial_sum_bound (S) (hdec) (D) (hKP) (g0) (s)` :
  `s.sum (fun X => |D.coeff X| * absWeight X) <= |weight g0| * exp(energy g0)`
- `kp_cluster_summable (S) (hdec) (D) (hKP) (g0)` : `Summable (fun X => |D.coeff X| * absWeight X)`
- `kpPsi_le_exp`, `boundedTouchSum_le_kpPsi`, `clusterCoeff_absWeight_exp_nonneg`,
  `clusterCoeff_absWeight_nonneg`, and the `cexSystem` one-point counterexample
  (which shows `hself` is mathematically necessary - keep `hself` threaded).

## Target 1: `kp_convergence_bound_of_selfIncompatible`

```lean
theorem kp_convergence_bound_of_selfIncompatible
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (hself : forall g, S.incompatible g g)
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma) :
    (tsum (fun X : {X : Cluster S //
        X.Connected S hdec /\ X.Touches S g0} =>
      |D.coeff X.1| * X.1.absWeight S * Real.exp (X.1.energyOf S)))
        <= S.energy g0
```

This is the `exp(energyOf)`-weighted version. Note the RHS is `S.energy g0`
(bare energy), not `|weight g0| * exp(energy g0)`. The extra `exp(energyOf X)`
weight inside the sum and the `hself` hypothesis are what convert
`kp_partial_sum_bound`'s bound into this one - the KP condition with
self-incompatibility controls the `exp(energyOf)`-weighted sum. Route: relate
the `exp(energyOf)`-weighted cluster sum to the `kpPsi`/`boundedTouchSum` chain
already used by `kp_tree_sum_bound`, using `hself` so the `h = g0` diagonal term
enters the KP sum (that diagonal is exactly what the `cexSystem` counterexample
lacks). Prove `tsum <= ...` via `tsum_le_of_sum_le` on the summable nonneg
family (`kp_cluster_summable`-style summability with the `exp` weight;
`clusterCoeff_absWeight_exp_nonneg` gives nonnegativity).

## Target 2: `kp_tail_bound`

```lean
theorem kp_tail_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (hself : forall g, M.incompatible g g)
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (hKP : KPCondition M.toPolymerSystem hdec)
    (m : Real) (hm : 0 < m)
    (hcoerce : forall (X : Cluster M.toPolymerSystem),
        X.Connected M.toPolymerSystem hdec ->
        forall g0 : Gamma, X.Touches M.toPolymerSystem g0 ->
        forall i : Fin X.n, m * M.dist g0 (X.poly i)
          <= X.energyOf M.toPolymerSystem)
    (g0 : Gamma) (R : Real) (hR : 0 <= R) :
    (tsum (fun X : {X : Cluster M.toPolymerSystem //
        X.Connected M.toPolymerSystem hdec /\ X.ReachesFrom M g0 R} =>
      |D.coeff X.1| * X.1.absWeight M.toPolymerSystem))
        <= M.energy g0 * Real.exp (-(m * R))
```

Route: every cluster counted by `ReachesFrom g0 R` has some slot `i` with
`R <= dist g0 (poly i)`, so by `hcoerce`, `m*R <= energyOf X`, i.e.
`exp(-(energyOf X)) <= exp(-(m*R))`, i.e.
`1 <= exp(energyOf X) * exp(-(m*R))`. Multiply the summand by that `>= 1`
factor to dominate it by `|D.coeff| * absWeight * exp(energyOf) * exp(-(m*R))`,
then pull out `exp(-(m*R))` and apply
`kp_convergence_bound_of_selfIncompatible` (Target 1) to the
`exp(energyOf)`-weighted sum bounded by `M.energy g0`. Keep the metric/coercivity
argument in THIS theorem, not in the bare KP theorems.

## Constraints

- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. Preserve
  both statements verbatim. If you can only close one, close it and leave the
  other's `s o r r y` with a tightened handoff.
- Do NOT modify `pairSum_le_expBound` or any lemma above line 1290.
- `hself` MUST stay threaded - the `cexSystem` counterexample proves the bare
  (no-`hself`) shape is FALSE.
- If `lake build` stalls, SKIP it; return the proofs as a patch/text.
