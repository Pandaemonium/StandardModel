# Claude adversarial cross-family review: ExactFlowL2GroupCapstone (ad6685ad)

- Reviewer: interactive Claude Code (claude family), adversarial pass
- Builder: Codex (Aristotle ad6685ad)
- Work item: `CONT-FOURIER-001`
- Source: `PhysicsSM/Draft/NullEdge/ExactFlowL2GroupCapstone.lean` (130 lines),
  sha256 089a6c04... verified
- Date: 2026-07-13

## Verdict: ACCEPT

## The six required checks

1. **Composition order for left matrix action.** `momMult_add_time`:
   `momMult m (s+t) k = (momMult m s k).comp (momMult m t k)`, via
   `exactFlow_add_time` (matrix product `exactFlow s * exactFlow t`) and
   `map_mul` (toEuclideanCLM is multiplicative). `.comp` applies `momMult t`
   first then `momMult s`, matching `U(s)U(t) v = U(s)(U(t) v)` for the left
   matrix action. Correct.

2. **Representative-safe L2 CLASS equality (not global pointwise).**
   `momMultL2Isometry_add_time` rewrites the composition via
   `variablePointwiseL2Isometry_comp`, then proves equality with `Lp.ext`
   (equality of `Lp` equivalence classes) and `filter_upwards [... coeFn ...]`
   (a.e. agreement of representatives). The pointwise `momMult_add_time` is
   applied only on the a.e.-defined representative values
   (`appliedRepresentative`, `ContinuousLinearMap.comp_apply`). This is genuine
   L2-class equality via a.e. representative agreement -- NOT a global pointwise
   identity. Exactly the representative-safe structure required.

3. **Fourier conjugation transports the group law.**
   `positionExactFlowL2Isometry_add_time` applies `fourierTransformₗᵢ.injective`,
   rewrites three times with `fourier_positionExactFlowL2Isometry` (the intertwining
   `F ∘ positionFlow = momMult ∘ F`), and reduces to
   `momMultL2Isometry_add_time`. Correct transport to position-space L2.

4. **Inverse controls and strong-continuity control -- order and scope.**
   `momMultL2Isometry_mul_neg_time` (momentum space): `U(t)∘U(-t) = id` via
   add_time + `add_neg_cancel` + zero_time. `positionExactFlowL2Isometry_neg_time_mul`
   (position space): `U(-t)∘U(t) = id` via add_time + `neg_add_cancel` + zero_time.
   Each is the stated order on the stated space. `position_orbit_continuous_control`
   re-exports the already-proved strong (fixed-state) continuity
   `positionExactFlowL2Orbit_continuous` -- strong, not operator-norm.

5. **Guards.** All SIX declarations carry `#guard_msgs` blocks pinning
   `[propext, Classical.choice, Quot.sound]` (every theorem in the file is
   guarded).

6. **Docstring scope.** Explicit: "group laws on L2 equivalence classes, not
   pointwise representative equalities ... No generator domain, Schwartz
   invariance, position-space PDE, walk limit, or Lorentz statement follows from
   this file alone." No overclaim of generator/Schwartz/PDE/continuum/Lorentz.

## Overclaim tests

Vacuity: none (composes genuine nontrivial `momMult`/`exactFlow` isometries).
Hollow telescoping: none -- the L2-class group law does not follow trivially from
the pointwise one; it requires the representative-safe composition
(`variablePointwiseL2Isometry_comp` + `Lp.ext` + a.e. coeFn). Docstring overreach:
none. False shape: none -- this is a strongly continuous one-parameter GROUP law
on L2 (group law + both inverse orders + strong continuity), correctly NOT
claimed as a Stone generator/unitary-group-with-domain.

## Independent verification

- `lake build PhysicsSM.Draft.NullEdge.ExactFlowL2GroupCapstone`: Build
  completed successfully (8050 jobs), exit 0. All six `#guard_msgs` blocks fired
  and passed; axiom footprint `[propext, Classical.choice, Quot.sound]`,
  build-enforced.

## Narrowest defensible claim

The exact Dirac momentum multiplier and its Fourier-conjugated position-space
form each satisfy the one-parameter group law `U(s+t) = U(s) U(t)` on L2
equivalence classes, with the displayed momentum- and position-space inverse
controls and the previously established strong (fixed-state) continuity of every
orbit. This assembles a strongly continuous one-parameter group STRUCTURE on the
spinor-valued L2 space; it provides no infinitesimal generator or domain (no
Stone theorem), no Schwartz invariance, no position-space PDE, no walk limit, and
no Lorentz statement.
