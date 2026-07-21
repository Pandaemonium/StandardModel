import PhysicsSM.Draft.NullEdge.DixonWeakLadders

/-!
# [SUPERSEDED] The eq-31 weak CAR conjecture file - resolution record

**Status: SUPERSEDED 2026-07-18 (same day); retained for provenance. No open
conjectures remain here - the `s o r r y`-marked reading-(A) statements were
REMOVED once the kernel closed the semantics question.**

This file briefly pre-registered two operator readings of Furey eq-31 (reading
(A): element right-multiplication restricted to the ideal `L = v_w Cl(4)`;
reading (B): bar operators), with a kill-condition. The investigation resolved
the question the same day, in three kernel steps recorded in:

1. `DixonWeakCARTau3.lean` - the eq-30 transcription fix (`tau_3`, not
   `tau_1`) AND the anti-Fock element dictionary (`omega omega‡ = 0`,
   `tau_3 = 0` as ELEMENTS): every element-product reading - including this
   file's reading (A), which used element products `(v_w * c) * beta` - is
   UNFAITHFUL. The kill-condition fired in the sharpest possible way: not the
   translation but the SEMANTICS was wrong.
2. `CompositionWeakLadders.lean` - the faithful semantics is COMPOSITION
   operators (nested left mults); the four global colour cores of eq-31 are
   kernel-landed there.
3. `CompositionWeakCAR.lean` - the Dixon-level assembly of the full eq-31 CAR
   from those cores.

The weak vacuum below is retained (still meaningful as an element literal and
used in provenance discussions), with the caution that Fock-style reasoning
about it is only valid at the OPERATOR level.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DixonWeakCARConjecture

open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonWeakLadders

/-- The weak leptonic vacuum `v_w = beta_1‡ beta_2‡ beta_2 beta_1` (eq. 32),
left-associated, as a Dixon ELEMENT literal. CAUTION (kernel,
`DixonWeakCARTau3`): element products do not satisfy the Fock relations; use
the composition-operator realization for any CAR/ideal reasoning. -/
def vw : Dixon := ((betaH1dag * betaH2dag) * betaH2) * betaH1

end PhysicsSM.Draft.NullEdge.DixonWeakCARConjecture
