/-
# The Rayleigh-Ritz keystone: the budget functional's ground value is a mass

DRAFT (kernel-clean; no `s o r r y`). The finite Rayleigh-Ritz keystone the
all-mass program calls its "single most valuable next theorem" (manuscript
`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`, S4 rail 3 / S10 crux
0): the object `M^2 := 4 ev(D^2)` that the four-channel mass budget decomposes
is only a *quadratic functional*; it becomes a genuine *mass* (a spectral
quantity) exactly at the ground state of a positive physical sector. This file
lands that upgrade: on a finite-dimensional sector carrying a definite inner
product, an ordinary-self-adjoint `T` whose real quadratic form is bounded
below by `c > 0` has its Rayleigh-quotient infimum attained *as a genuine
eigenvalue* that is `> 0`.

## The two load-bearing gaps this theorem exposes (both honestly open)

This is the CONDITIONAL keystone. It proves the implication "positive definite
sector `=>` genuine positive squared-mass eigenvalue." Two things it does NOT
close, surfaced by two independent expert reviews (Fable call-04, Aristotle
strengthening job 4bf9899f) that converged on them:

1. **The positive sector must exist (the hypothesis).** `T` must be *ordinary*
   self-adjoint on a *definite* inner-product space - i.e. the physical sector
   must be `J`-positive, not merely `J`-nondegenerate. A pre-registered probe
   this run (`Scripts/oracle/probe_s1cc_aperture_grading.py`,
   `AgentTasks/overnight-allmass-run-2026-07-08/S1CC_APERTURE_GRADING_FINDING.md`)
   shows the current single-doublet S1-CC witness has NO such sector: the
   closure grading `b` balances the aperture's Krein form `J Q_A` as well as
   `J Q_C`, so the whole operator is balanced there. The hypothesis `hpos`
   (`c > 0` form lower bound) is therefore NOT vacuously satisfiable on the
   existing model; a genuine multi-edge carrier (larger Clifford algebra,
   closure bivector distinct from chirality) is needed to instantiate it.
   Note carefully: `aperture_dominance_pos` (a sibling draft file) bounds the
   *Hermitian* form `Re<x,(A+C)x>`; the mass lives in the *Krein* form
   `J(A+C)`, and it is the Krein form that is obstructed. The two are distinct.

2. **The eigenvalue is not yet the kinematic mass (`det P`).** This theorem
   yields the least eigenvalue of `T = D^#D|_sector`, an operator-spectral
   quantity. The trusted S3 theorem is about `det P`, a Gram/Pluecker invariant
   of a state's momentum. Identifying the two - `min spec(D^#D | P) = det P` of
   the ground bundle - is a SEPARATE bridge theorem, is not proved here, and
   (per the Aristotle audit) may be false as stated. It is the program's
   deepest open link and is pre-registered as a conjecture (manuscript S10).

So this file upgrades the budget from "a quadratic functional" to "an
eigenvalue" - real progress - but not yet to "*the* mass of S3".

## Provenance

Statement and Lean proof: Aristotle strengthening job `4bf9899f-3e31-42f8
-82ab-a6cbfa2b5780` (2026-07-08), which selected this as the highest-value next
theorem and proved it against Mathlib - [orig]/[import]. Uses
`LinearMap.IsSymmetric.hasEigenvalue_iInf_of_finiteDimensional` (the finite
spectral / Rayleigh-quotient-min-on-the-compact-sphere theorem) and `le_ciInf`.
The honest hypothesis analysis (definite sector, and the two open gaps) is the
audit's central point; cross-confirmed by Fable call-04 and the aperture
-grading probe. Clean-room: proof re-checked here under the pinned toolchain,
not trusted from the cloud build.
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMass

open ContinuousLinearMap

/-- **Rayleigh-Ritz keystone (`sector_ground_mass`).** On a finite-dimensional
physical sector `H` carrying its induced *definite* inner product (this is where
`J`-positivity of the sector is used: only then is `H` a genuine inner product
space and `T = D^#D|_H` *ordinary*-self-adjoint on it), if `T` is symmetric and
its real quadratic form `reApplyInnerSelf` is bounded below by `c > 0`, then the
infimum of the Rayleigh quotient is a genuine eigenvalue of `T` (attained, the
least eigenvalue) and is `> 0`. So `min spec(T)` is a genuine positive
squared-mass. See the module docstring for the two gaps this does NOT close (the
sector must exist; the eigenvalue is not yet `det P`). -/
theorem sector_ground_mass
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] [Nontrivial H]
    (T : H →L[ℂ] H) (hT : (T : H →ₗ[ℂ] H).IsSymmetric)
    (c : ℝ) (hc : 0 < c)
    (hpos : ∀ x : H, c * ‖x‖ ^ 2 ≤ T.reApplyInnerSelf x) :
    Module.End.HasEigenvalue (T : H →ₗ[ℂ] H)
        (((⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ)) : ℂ)
      ∧ 0 < (⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ) := by
  haveI : Nonempty { x : H // x ≠ 0 } := by
    obtain ⟨y, hy⟩ := exists_ne (0 : H); exact ⟨⟨y, hy⟩⟩
  have hbound : c ≤ (⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ) := by
    apply le_ciInf
    intro x
    have hx2 : (0 : ℝ) < ‖(x : H)‖ ^ 2 := by
      have := norm_ne_zero_iff.mpr x.2; positivity
    rw [ContinuousLinearMap.rayleighQuotient, le_div_iff₀ hx2]
    simpa [mul_comm] using hpos x
  exact ⟨hT.hasEigenvalue_iInf_of_finiteDimensional, lt_of_lt_of_le hc hbound⟩

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMass.sector_ground_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sector_ground_mass

end PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMass
