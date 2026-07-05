import Mathlib

/-!
# QMF1-RP: compact-group Haar expectation invariances (RP/transfer substrate)

First brick of the QMF (QCD mass formalism) ladder's compact-group
reflection-positivity / transfer layer (QMF1-RP, the "cheap, Haar only" lane the
day-2 capability survey unblocked - see `RUN_PLAN.md`
`replan:qmf-ladder` and `qmf1a:capability-survey`).

Osterwalder-Seiler reflection positivity for a compact gauge group rests on two
symmetries of the single-link Haar expectation `E[f] = ∫ f dμ`:

* **gauge invariance** - `E` is unchanged by conjugating the integrand
  (`x ↦ g * x * g⁻¹`); this is `haarExpectation_conj_invariant` below, the one
  genuinely derived result here (from left+right invariance);
* **reflection invariance** - the OS reflection acts on a link variable by
  inversion (`x ↦ x⁻¹`), under which `E` is unchanged
  (`haarExpectation_inv_invariant`, a direct specialization of
  `MeasureTheory.integral_inv_eq_self`).

## Capability-survey finding (recorded, honest): the unimodularity gap

A compact group is unimodular and its Haar measure is inversion-invariant, so
for the intended `SU(N)` link groups all three of `IsMulLeftInvariant`,
`IsMulRightInvariant`, `IsInvInvariant` hold. BUT in the pinned Mathlib
(`leanprover/lean4:v4.28.0`) instance resolution does NOT derive
`IsMulRightInvariant` or `IsInvInvariant` from `[CompactSpace G] [IsHaarMeasure μ]`
for a general (nonabelian) group - the available `isInvInvariant_of_*` instances
require `CommGroup` (`Mathlib.MeasureTheory.Measure.Haar.Unique`). So for
nonabelian `SU(N)` these must enter as EXPLICIT hypotheses (or be proved via a
unimodularity lemma the QMF2 layer will have to supply). The exact machinery that
route would use IS present -
`Mathlib.MeasureTheory.Measure.Haar.MulEquivHaarChar.mulEquivHaarChar` (the
modular character of a topological-group automorphism) - but the compact-group
triviality step (a continuous homomorphism into `ℝ≥0` from a compact group has
image `{1}`, hence conjugation is measure-preserving, hence unimodular) is not
in pinned Mathlib. This extends the capability survey (Peter-Weyl absent) with a
second concrete gap the compact-RP lane must budget for. The general lemmas below
therefore take bi-invariance / inversion invariance as typeclass hypotheses
rather than synthesizing them from compactness.

**Concrete gap-free model (`FiniteModel` section):** for a FINITE group with the
counting measure, all three invariances ARE available as Mathlib instances
(finite groups are trivially unimodular), so the gauge/reflection invariances
hold UNCONDITIONALLY. This gives the QMF compact-RP substrate a concrete working
model today (finite gauge groups - `ℤ_N`, and nonabelian finite groups such as
`Q8` or `S₃`), unblocked, while the continuous nonabelian `SU(N)` case waits on
the unimodularity proof above.

Draft-trust, kernel-checked, `s o r r y`-free. Prerequisites: Mathlib only.
No lattice geometry, no RP theorem yet - only the single-link expectation
symmetries those will consume.
-/

namespace PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance

open MeasureTheory

variable {G E : Type*} [MeasurableSpace G] [NormedAddCommGroup E] [NormedSpace ℝ E]
  [Group G] [MeasurableMul G] {μ : Measure G}

/-- **Gauge invariance of the Haar expectation.** For a bi-invariant (unimodular,
e.g. compact-group Haar) measure, the integral is unchanged by conjugating the
integrand: `∫ f(g x g⁻¹) dμ = ∫ f x dμ`. Derived from right-invariance (peel the
`g⁻¹`) then left-invariance (peel the `g`). This is the gauge invariance the
compact reflection-positivity / transfer layer needs at each link. -/
theorem haarExpectation_conj_invariant
    [μ.IsMulLeftInvariant] [μ.IsMulRightInvariant] (f : G → E) (g : G) :
    ∫ x, f (g * x * g⁻¹) ∂μ = ∫ x, f x ∂μ := by
  calc ∫ x, f (g * x * g⁻¹) ∂μ
      = ∫ x, f (g * (x * g⁻¹)) ∂μ := by simp [mul_assoc]
    _ = ∫ x, f (g * x) ∂μ := integral_mul_right_eq_self (fun y => f (g * y)) g⁻¹
    _ = ∫ x, f x ∂μ := integral_mul_left_eq_self f g

/-- **Reflection invariance of the Haar expectation.** The OS reflection acts on a
link variable by inversion; for an inversion-invariant (compact-group Haar)
measure the expectation is unchanged: `∫ f(x⁻¹) dμ = ∫ f x dμ`. A direct
specialization of `MeasureTheory.integral_inv_eq_self`, recorded here with the
QMF reading. -/
theorem haarExpectation_inv_invariant [MeasurableInv G] [μ.IsInvInvariant]
    (f : G → E) : ∫ x, f x⁻¹ ∂μ = ∫ x, f x ∂μ :=
  integral_inv_eq_self f μ

/-- **Gauge invariance is compatible with reflection.** Conjugating AND reflecting
the integrand still leaves the Haar expectation unchanged - the combined
gauge/reflection symmetry the compact-RP inner product relies on. -/
theorem haarExpectation_conj_inv_invariant
    [MeasurableInv G] [μ.IsMulLeftInvariant] [μ.IsMulRightInvariant]
    [μ.IsInvInvariant] (f : G → E) (g : G) :
    ∫ x, f ((g * x * g⁻¹)⁻¹) ∂μ = ∫ x, f x ∂μ := by
  rw [haarExpectation_inv_invariant (fun y => f y) |>.symm]
  exact haarExpectation_conj_invariant (fun y => f y⁻¹) g

/-! ## Concrete gap-free model: finite groups with counting measure

Mathlib supplies `IsMulLeftInvariant`, `IsMulRightInvariant`, and
`IsInvInvariant` for `Measure.count` on any group as instances (counting is
invariant under every bijection), so the gauge/reflection invariances hold with
NO unimodularity hypothesis. The intended concrete case is a FINITE gauge group,
where `∫ · ∂Measure.count` is a genuine finite sum: a discrete compact group,
trivially unimodular - an unconditional compact-RP substrate the QMF ladder can
build on today (finite gauge groups `ℤ_N`, `Q8`, `S₃`, ...). -/
section FiniteModel

variable {G E : Type*} [Group G] [MeasurableSpace G] [MeasurableMul G]
  [MeasurableInv G] [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Unconditional gauge invariance of the finite-group counting expectation. -/
theorem count_conj_invariant (f : G → E) (g : G) :
    ∫ x, f (g * x * g⁻¹) ∂(Measure.count : Measure G) = ∫ x, f x ∂Measure.count :=
  haarExpectation_conj_invariant f g

/-- Unconditional reflection (inversion) invariance of the finite-group counting
expectation. -/
theorem count_inv_invariant (f : G → E) :
    ∫ x, f x⁻¹ ∂(Measure.count : Measure G) = ∫ x, f x ∂Measure.count :=
  haarExpectation_inv_invariant f

end FiniteModel

end PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance
