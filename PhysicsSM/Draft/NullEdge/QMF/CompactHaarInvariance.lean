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

## Capability-survey finding, now CLOSED: nonabelian compact unimodularity

A compact group is unimodular and its Haar measure is inversion-invariant, so
for the intended `SU(N)` link groups all three of `IsMulLeftInvariant`,
`IsMulRightInvariant`, `IsInvInvariant` hold. This is a genuine gap in pinned
Mathlib (`leanprover/lean4:v4.28.0`): instance resolution does NOT derive
`IsMulRightInvariant` or `IsInvInvariant` from `[CompactSpace G] [IsHaarMeasure μ]`
for a general (nonabelian) group - the available `isInvInvariant_of_*` instances
require `CommGroup` (`Mathlib.MeasureTheory.Measure.Haar.Unique`).

The `Compact` section below CLOSES it, for ANY compact group (abelian or not):
`compactGroup_haar_isMulRightInvariant` and `compactGroup_haar_isInvInvariant`
prove right- and inversion-invariance from compactness alone, via the classical
argument (a right-translate / inverse-pushforward of a left-invariant Haar
measure is again left-invariant, so by `isMulInvariant_eq_smul_of_compactSpace`
it is a scalar multiple `c • μ`, and `c = 1` because the total mass `μ Set.univ`
is finite and nonzero on a compact group). No modular-character machinery needed.
This extends the capability survey (Peter-Weyl absent) with a gap now filled -
the compact-RP lane can use unconditional bi-invariance for nonabelian `SU(N)`.

**Concrete gap-free model (`FiniteModel` section):** for a FINITE group with the
counting measure, all three invariances are also available directly as Mathlib
instances - a concrete working model (finite gauge groups) with no analysis at
all.

Draft-trust, kernel-checked, `s o r r y`-free. Prerequisites: Mathlib only.
No lattice geometry, no RP theorem yet - only the single-link expectation
symmetries those will consume.
-/

namespace PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance

open MeasureTheory MeasureTheory.Measure

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

/-! ## Compact groups are unimodular: closing the invariance gap

For ANY compact topological group, right- and inversion-invariance of a Haar
measure are proved from compactness alone, so the gauge/reflection invariances
above hold with no bi-invariance hypothesis. This unblocks nonabelian `SU(N)`. -/
section Compact

variable {G : Type*} [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [MeasurableSpace G] [BorelSpace G]

/-- **A compact group is unimodular**: a left-invariant Haar measure on a compact
group is also right-invariant. A right-translate `μ.map (· * g)` of `μ` is again
left-invariant (left/right translations commute), hence
`= haarScalarFactor • μ` by `isMulInvariant_eq_smul_of_compactSpace`; evaluating
at `Set.univ` (finite and nonzero on a compact group) forces the scalar to `1`. -/
theorem compactGroup_haar_isMulRightInvariant (μ : Measure G) [μ.IsHaarMeasure] :
    μ.IsMulRightInvariant := by
  refine ⟨fun g => ?_⟩
  set ν : Measure G := μ.map (· * g) with hν
  have hmeas : Measurable (fun x : G => x * g) := measurable_mul_const g
  have hsmul : ν = ν.haarScalarFactor μ • μ :=
    isMulInvariant_eq_smul_of_compactSpace ν μ
  have huniv : ν Set.univ = μ Set.univ := by
    rw [hν, Measure.map_apply hmeas MeasurableSet.univ, Set.preimage_univ]
  have hpos : μ Set.univ ≠ 0 := by
    simp only [ne_eq, measure_univ_eq_zero]; exact NeZero.ne μ
  have hfin : μ Set.univ ≠ ⊤ := measure_ne_top μ Set.univ
  have hc : (ν.haarScalarFactor μ : ENNReal) * μ Set.univ = μ Set.univ := by
    have h := huniv
    rw [hsmul, Measure.smul_apply, ENNReal.smul_def] at h
    exact h
  have hc1 : (ν.haarScalarFactor μ : ENNReal) = 1 :=
    (ENNReal.mul_eq_left hpos hfin).mp (by rw [mul_comm]; exact hc)
  have hcnnreal : ν.haarScalarFactor μ = 1 := by exact_mod_cast hc1
  rw [hsmul, hcnnreal, one_smul]

/-- **A Haar measure on a compact group is inversion-invariant.** Same argument
applied to the inverse-pushforward `μ.inv`, which is left-invariant since `μ` is
(now) right-invariant. -/
theorem compactGroup_haar_isInvInvariant (μ : Measure G) [μ.IsHaarMeasure] :
    μ.IsInvInvariant := by
  have : μ.IsMulRightInvariant := compactGroup_haar_isMulRightInvariant μ
  set ν : Measure G := μ.inv with hν
  have hmeas : Measurable (fun x : G => x⁻¹) := measurable_inv
  have hsmul : ν = ν.haarScalarFactor μ • μ :=
    isMulInvariant_eq_smul_of_compactSpace ν μ
  have huniv : ν Set.univ = μ Set.univ := by
    rw [hν, Measure.inv, Measure.map_apply hmeas MeasurableSet.univ, Set.preimage_univ]
  have hpos : μ Set.univ ≠ 0 := by
    simp only [ne_eq, measure_univ_eq_zero]; exact NeZero.ne μ
  have hfin : μ Set.univ ≠ ⊤ := measure_ne_top μ Set.univ
  have hc : (ν.haarScalarFactor μ : ENNReal) * μ Set.univ = μ Set.univ := by
    have h := huniv
    rw [hsmul, Measure.smul_apply, ENNReal.smul_def] at h
    exact h
  have hc1 : (ν.haarScalarFactor μ : ENNReal) = 1 :=
    (ENNReal.mul_eq_left hpos hfin).mp (by rw [mul_comm]; exact hc)
  have hcnnreal : ν.haarScalarFactor μ = 1 := by exact_mod_cast hc1
  exact ⟨by rw [← hν, hsmul, hcnnreal, one_smul]⟩

/-- **Unconditional gauge invariance on a compact group.** The bi-invariance
hypothesis of `haarExpectation_conj_invariant` is now discharged from
compactness. -/
theorem compact_haarExpectation_conj_invariant (μ : Measure G) [μ.IsHaarMeasure]
    (f : G → E) (g : G) : ∫ x, f (g * x * g⁻¹) ∂μ = ∫ x, f x ∂μ := by
  haveI := compactGroup_haar_isMulRightInvariant μ
  exact haarExpectation_conj_invariant f g

/-- **Unconditional reflection invariance on a compact group.** -/
theorem compact_haarExpectation_inv_invariant (μ : Measure G) [μ.IsHaarMeasure]
    (f : G → E) : ∫ x, f x⁻¹ ∂μ = ∫ x, f x ∂μ := by
  haveI := compactGroup_haar_isInvInvariant μ
  exact haarExpectation_inv_invariant f

end Compact

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
