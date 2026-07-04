# YM1 Lemma 2b: independent-plaquette ensemble expectation bridge (2026-07-04)

Continuation of the overnight YM run
(`AgentTasks/overnight-ym-run-2026-07-03/`), executing the morning report's
recommended action 1: connect `Theorem2AreaLaw.lean`'s iterated-convolution
identity to an actual ensemble EXPECTATION VALUE.

## What was proved (all kernel-checked, draft tree)

New module: `PhysicsSM/Draft/NullEdge/GateYM/IndependentPlaquetteEnsemble.lean`
(wired into the `GateYM` aggregator).

- `orderedProd`: ordered noncommutative product of a plaquette tuple, via
  `List.ofFn`/`List.prod` (deliberately NOT `Finset.prod`, which needs
  commutativity); `orderedProd_revInv` is the tuple-level
  `(a*b)^(-1) = b^(-1) a^(-1)`.
- `sum_weight_orderedProdInv_eq_iterConv` (Lemma 2b core): for ANY `w`, `chi`,
  `sum_(U : Fin m -> G) (prod_i w(U_i)) * chi((orderedProd U)^(-1) * A)
  = iterConv w chi m A`. The observable inversion is forced by the
  oracle-pinned `h^(-1) * A` convolution order; proof is induction with
  `Fin.consEquiv` head/tail splitting.
- `sum_weight_orderedProd_eq_iterConv_of_inv`: for inversion-symmetric `w`
  (Wilson weight under unitarity), the UN-inverted holonomy observable works;
  proof by the involutive reverse-and-invert change of variables on tuples.
- `partition`, `loopNumerator`, `loopExpectation`: the independent-plaquette
  ensemble over a finite plaquette type `nu` with ordered loop region
  `e : Fin m -> nu` (embedding, comb order).
- `partition_eq_pow`: `Z = (sum_g w g)^(card nu)`.
- `loopNumerator_factor_of_equiv` / `loopNumerator_factor`: out-of-region
  plaquettes integrate out. Design note: the split is transported along a
  `Fin m + complement ~ nu` SUM-TYPE enumeration
  (`Equiv.sumArrowEquivProdArrow`, `Equiv.Set.sumCompl`), not a subtype
  predicate split - the first attempt with `Equiv.piEquivPiSubtypeProd`
  hit a `Set.fintypeRange` vs `Subtype.fintype` instance mismatch in `calc`
  blocks. Abstract-type statements make instances unify instead of
  re-synthesize; recorded here as a reusable pattern.
- `loopExpectation_eq_iterConv_div` (**Lemma 2b**):
  `<W> = iterConv w chi m 1 / (sum_g w g)^m`.
- `wilson_loop_expectation_area_law` (**Theorem 2, independent-plaquette
  form**): for the Wilson local weight of a unitary `rho` and simple complex
  `FDRep` `R`, `<W_R> = chi_R(1) * wilsonNormalizedGamma^m` EXACTLY - the
  area law as a true expectation value.
- `norm_wilson_loop_expectation`: `|<W_R>| = |chi_R(1)| * |gamma|^m`, i.e.
  exponential decay in the area whenever `|gamma| < 1` (confinement-shaped
  norm form).

Claim label: **finite identity**. Axiom footprint of every theorem above:
`[propext, Classical.choice, Quot.sound]`. No `s o r r y`, no
`n a t i v e _ d e c i d e`.

## Sanity checks performed

- `m = 1, 2` hand expansion of `iterConv` against the tuple sum (matches,
  including the `(hk)^(-1)` order reversal).
- Trivial representation: observable is constantly `1`, numerator equals
  partition, expectation `= 1`; formula gives `gamma_norm = 1`,
  `chi(1) = 1`. Consistent.

## What remains for freeze Theorem 2 (explicit)

The tree-gauge change of variables: the LINK-field ensemble
(`LatticeEnsemble`/`PlaquetteEnsemble`) on a 2D open rectangle pushes forward
to this independent-plaquette ensemble, with the rectangular Wilson loop
becoming the ordered product of enclosed plaquette variables. This needs the
2D lattice geometry (spanning-tree gauge-fixing bijection) and is the natural
next Aristotle design/strategy target for YM1.

## Verification commands run

- `lake env lean PhysicsSM/Draft/NullEdge/GateYM/IndependentPlaquetteEnsemble.lean`
  (clean, no warnings)
- `lake build PhysicsSM.Draft.NullEdge.GateYM.IndependentPlaquetteEnsemble`
- `lake build PhysicsSM.Draft.NullEdge.GateYM` (aggregate, 8054 jobs, green)
- `#print axioms` audit on all nine public theorems (footprints above)
