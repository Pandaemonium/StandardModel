# Derive the two-body interaction V from the carrier's closure geometry (hadron C->M)

PROOF + DESIGN job (the deep step; a rigorous obstruction map if it resists).
Context: `src/InteractingTwoBody.lean` (the landed below-threshold bound state) +
`src/BindingDefect.lean` (Delta = -kappa).

## Situation (finite mathematical-physics program: mass = obstruction to null transport)

`InteractingTwoBody.interacting_boundState_below_threshold` (M) proves: for an
attractive `V = !![0,-kappa,0; -kappa,0,0; 0,0,0]` on the two-particle sector, the
least eigenvalue is strictly below the free constituent threshold when kappa>0 - a
genuine finite bound state. Its ONE remaining grade-C step is that `V`'s *scale* is
the closure strength kappa (= -Delta, the kernel-proved block binding defect) but
its rank-one attractive *form* is MODELLED, not DERIVED from the carrier's closure
geometry. Closing that C->M is the deepest open hadron step.

## Target

1. **Derive V from the carrier.** The one-particle sector is the mass block
   `B(lam,kappa) = lam.I + i.kappa.K` (K the closure curvature). The genuine
   two-body interaction should be the second-quantization / two-body projection of
   the carrier's *closure* operator `Q_C` (or the closure part `i.kappa.K`) onto the
   antisymmetric two-particle space `Lambda^2(sector)` - NOT a hand-drawn rank-one
   V. Construct `V_derived := (the two-body closure operator on Lambda^2)` from the
   carrier data, state its exact finite Lean form (an explicit matrix on the C(3,2)
   =3-dim pair space, built from B's off-diagonal closure entries).
2. **The theorem.** Prove that `V_derived` (a) has strength set by kappa (matching
   Delta=-kappa), and (b) yields a least eigenvalue of `freeH2 + V_derived` strictly
   below the constituent threshold when kappa>0 - i.e. the SAME below-threshold
   bound-state conclusion as the modelled V, but now with V DERIVED. If the derived
   V's form differs from the modelled one, prove the bound state for the derived V
   directly (small-matrix eigenvalue computation).
3. **If V_derived does NOT bind** (e.g. its projection is repulsive or zero on
   Lambda^2), that is a crucial NEGATIVE finding: report it precisely - it would
   mean the closure geometry alone does not produce hadronic binding, and the
   modelled attractive V was smuggling in physics the carrier doesn't supply.
   Give the exact computation showing bind vs no-bind.

Deliver `V_derived` + the below-threshold theorem for it (upgrading the hadron seed
C->M), OR the precise negative result. Either outcome is high-value: it either makes
the finite hadron mass first-principles, or honestly bounds what the closure
geometry can produce. Run `lake env lean`; keep existing content intact; commit+push.
Provenance: all-mass solo run 2026-07-08 [orig]; the hadron C->M step.
