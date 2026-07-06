import Mathlib

/-!
# Fradkin–Shenker Higgs–confinement complementarity: the finite, honest core

This file formalizes the **finite** kernel-grade core of the Fradkin–Shenker theorem on
Higgs–confinement complementarity for a `ℤ/2ℤ` gauge–Higgs system.

## The honest claim

The Fradkin–Shenker result is often summarized informally as *"Higgs = confinement"*.
That slogan is **not** what is proved here, and it is not what the theorem says. The precise,
honest content is a statement about the **connectivity of the phase diagram**:

* **Complementarity = phase-diagram connectivity.** The "Higgs" region and the "confinement"
  region of coupling space are *continuously connected*: there is a path in coupling space
  joining a Higgs-like point to a confinement-like point along which every gauge-invariant
  bulk observable is analytic — there is **no bulk phase transition / no thermodynamic
  singularity** separating them.

* **Complementarity is NOT mechanism identity.** The Higgs mechanism and confinement remain
  *distinct physical mechanisms*. The theorem says only that they need not be separated by a
  singular phase boundary; it does **not** assert that they are "the same thing".

At **finite volume** this connectivity statement is completely rigorous and elementary: the
partition function of a finite lattice `ℤ/2ℤ` gauge–Higgs model is a finite sum of exponentials,
hence a **strictly positive, real-analytic (indeed entire) function of the couplings with no
zeros**. Consequently `log Z`, and every ratio-of-analytic expectation value ("Wilson-line /
Fradkin–Shenker order parameter"), is analytic on all of coupling space, and in particular along
*any* path connecting a Higgs-like point to a confinement-like point. This is exactly the finite
avatar of "no bulk singularity separates the phases".

The genuine Fradkin–Shenker theorem promotes this to the thermodynamic (infinite-volume) limit
inside an explicit region of the `(β, κ)` plane; that infinite-volume analytic-continuation
statement is *not* attempted here. What is proved is the finite, unconditional core.

## The model

We use a single square plaquette `ℤ/2ℤ` gauge–Higgs model:

* four gauge (link) variables `U₀, U₁, U₂, U₃ ∈ {±1}`, encoded as `Fin 4 → Bool`;
* four Higgs (site) variables `φ₀, φ₁, φ₂, φ₃ ∈ {±1}`, encoded as `Fin 4 → Bool`;
* the Wilson plaquette term `U₀U₁U₂U₃` with gauge coupling `β`;
* the gauge-invariant Higgs hopping term `∑ᵢ φᵢ Uᵢ φᵢ₊₁` with hopping coupling `κ`.

The action is `S(config; β, κ) = β · (plaquette) + κ · (hopping)` and the partition function is
`Z(β, κ) = ∑_config exp (S(config; β, κ))`.

## Main results

* `partitionFunction_pos` : `0 < Z β κ` for all couplings (strict positivity, no zeros).
* `partitionFunction_analytic` : `Z` is real-analytic (`ContDiff ℝ ω`) jointly in `(β, κ)`.
* `logPartition_analytic` : `log Z` is real-analytic everywhere (no singularity anywhere).
* `expectPlaquette_analytic` : the plaquette expectation value (a gauge-invariant order
  parameter) is real-analytic everywhere.
* `logPartition_analytic_along_path` / `expectPlaquette_analytic_along_path` : the same
  quantities are analytic along the explicit straight-line path connecting the Higgs-like point
  to the confinement-like point — the finite Fradkin–Shenker connectivity statement.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.FradkinShenkerFinite

open scoped BigOperators ContDiff

set_option autoImplicit false

/-- A `ℤ/2ℤ` spin `{±1}` encoded by a `Bool` (`true ↦ +1`, `false ↦ -1`). -/
noncomputable def z2 (b : Bool) : ℝ := if b then 1 else -1

/-- A configuration of the single-plaquette gauge–Higgs model: four gauge/link variables
(first component) and four Higgs/site variables (second component). -/
abbrev Config : Type := (Fin 4 → Bool) × (Fin 4 → Bool)

/-- The Wilson plaquette `U₀ U₁ U₂ U₃ ∈ {±1}` for a configuration. -/
noncomputable def plaquette (c : Config) : ℝ :=
  z2 (c.1 0) * z2 (c.1 1) * z2 (c.1 2) * z2 (c.1 3)

/-- The gauge-invariant Higgs hopping energy `∑ᵢ φᵢ Uᵢ φᵢ₊₁` (indices mod 4). -/
noncomputable def hopping (c : Config) : ℝ :=
  ∑ i : Fin 4, z2 (c.2 i) * z2 (c.1 i) * z2 (c.2 (i + 1))

/-- The (Euclidean) action `β · plaquette + κ · hopping`. -/
noncomputable def action (β κ : ℝ) (c : Config) : ℝ :=
  β * plaquette c + κ * hopping c

/-- The finite-volume partition function `Z(β, κ) = ∑_config exp (S(config; β, κ))`. -/
noncomputable def partitionFunction (β κ : ℝ) : ℝ :=
  ∑ c : Config, Real.exp (action β κ c)

/-- The unnormalized plaquette observable `∑_config plaquette · exp(S)`. -/
noncomputable def plaquetteWeighted (β κ : ℝ) : ℝ :=
  ∑ c : Config, plaquette c * Real.exp (action β κ c)

/-- The plaquette **expectation value** `⟨U₀U₁U₂U₃⟩` — a gauge-invariant order parameter
(a Fradkin–Shenker / Wilson-loop observable). -/
noncomputable def expectPlaquette (β κ : ℝ) : ℝ :=
  plaquetteWeighted β κ / partitionFunction β κ

/-! ### Strict positivity: the partition function has no zeros -/

/-- The partition function is a strictly positive finite sum of exponentials; in particular it
never vanishes. This is the finite core of "no bulk singularity": `Z > 0` everywhere. -/
theorem partitionFunction_pos (β κ : ℝ) : 0 < partitionFunction β κ := by
  unfold partitionFunction
  apply Finset.sum_pos
  · intro c _; exact Real.exp_pos _
  · exact ⟨(fun _ => true, fun _ => true), Finset.mem_univ _⟩

/-- Restatement of strict positivity as non-vanishing. -/
theorem partitionFunction_ne_zero (β κ : ℝ) : partitionFunction β κ ≠ 0 :=
  (partitionFunction_pos β κ).ne'

/-! ### Analyticity in the couplings -/

/-- The action is (jointly) real-analytic in the couplings `(β, κ)`. -/
theorem action_analytic (c : Config) :
    ContDiff ℝ ω (fun p : ℝ × ℝ => action p.1 p.2 c) := by
  unfold action
  fun_prop

/-- The partition function is real-analytic (`ContDiff ℝ ω`, hence entire and `C^∞`) jointly in
`(β, κ)`: a finite sum of analytic exponentials of analytic (affine) actions. -/
theorem partitionFunction_analytic :
    ContDiff ℝ ω (fun p : ℝ × ℝ => partitionFunction p.1 p.2) := by
  unfold partitionFunction
  apply ContDiff.sum
  intro c _
  exact Real.contDiff_exp.comp (action_analytic c)

/-- The weighted plaquette numerator is real-analytic jointly in `(β, κ)`. -/
theorem plaquetteWeighted_analytic :
    ContDiff ℝ ω (fun p : ℝ × ℝ => plaquetteWeighted p.1 p.2) := by
  unfold plaquetteWeighted
  apply ContDiff.sum
  intro c _
  exact contDiff_const.mul (Real.contDiff_exp.comp (action_analytic c))

/-- `log Z` is real-analytic on **all** of coupling space: there is no singularity anywhere,
because `Z > 0` everywhere. -/
theorem logPartition_analytic :
    ContDiff ℝ ω (fun p : ℝ × ℝ => Real.log (partitionFunction p.1 p.2)) :=
  partitionFunction_analytic.log (fun p => partitionFunction_ne_zero p.1 p.2)

/-- The plaquette expectation value (order parameter) is real-analytic on all of coupling space:
a ratio of analytic functions with nowhere-vanishing denominator. -/
theorem expectPlaquette_analytic :
    ContDiff ℝ ω (fun p : ℝ × ℝ => expectPlaquette p.1 p.2) :=
  plaquetteWeighted_analytic.div partitionFunction_analytic
    (fun p => partitionFunction_ne_zero p.1 p.2)

/-! ### The explicit Higgs → confinement path and the connectivity statement -/

/-- A **Higgs-like** coupling point: strong Higgs hopping, weak gauge coupling. -/
noncomputable def higgsPoint : ℝ × ℝ := (1 / 2, 2)

/-- A **confinement-like** coupling point: strong gauge coupling, weak Higgs hopping. -/
noncomputable def confinementPoint : ℝ × ℝ := (2, 0)

/-- The explicit straight-line path in coupling space connecting the Higgs-like point
(`couplingPath 0`) to the confinement-like point (`couplingPath 1`). -/
noncomputable def couplingPath (t : ℝ) : ℝ × ℝ :=
  ((1 - t) • higgsPoint.1 + t • confinementPoint.1,
   (1 - t) • higgsPoint.2 + t • confinementPoint.2)

@[simp] theorem couplingPath_zero : couplingPath 0 = higgsPoint := by
  simp [couplingPath]

@[simp] theorem couplingPath_one : couplingPath 1 = confinementPoint := by
  simp [couplingPath]

/-- The coupling path is real-analytic in the path parameter. -/
theorem couplingPath_analytic : ContDiff ℝ ω couplingPath := by
  unfold couplingPath higgsPoint confinementPoint
  fun_prop

/-- The partition function is strictly positive at every point of the path — no zero is
encountered along the way. -/
theorem partitionFunction_pos_along_path (t : ℝ) :
    0 < partitionFunction (couplingPath t).1 (couplingPath t).2 :=
  partitionFunction_pos _ _

/-- **Finite Fradkin–Shenker connectivity (free energy).** The free energy `log Z` is
real-analytic along the entire Higgs → confinement path: there is no thermodynamic singularity
separating the Higgs-like point from the confinement-like point in this finite model. -/
theorem logPartition_analytic_along_path :
    ContDiff ℝ ω (fun t : ℝ => Real.log (partitionFunction (couplingPath t).1 (couplingPath t).2)) :=
  logPartition_analytic.comp couplingPath_analytic

/-- **Finite Fradkin–Shenker connectivity (order parameter).** The gauge-invariant plaquette
expectation value varies analytically along the entire Higgs → confinement path: it has no
singularity as one interpolates between the two "phases". -/
theorem expectPlaquette_analytic_along_path :
    ContDiff ℝ ω (fun t : ℝ => expectPlaquette (couplingPath t).1 (couplingPath t).2) :=
  expectPlaquette_analytic.comp couplingPath_analytic

/-! ### The honest statement, packaged

`FradkinShenkerFiniteComplementarity` records the honest content as a single proposition:
there is an explicit path from a Higgs-like point to a confinement-like point along which

* the partition function never vanishes, and
* both the free energy `log Z` and a gauge-invariant order parameter are real-analytic,

i.e. the two regions are **continuously connected with no bulk singularity between them**. This
is *connectivity of the phase diagram*, and deliberately says nothing about the two mechanisms
being identical. -/
def FradkinShenkerFiniteComplementarity : Prop :=
  (couplingPath 0 = higgsPoint) ∧
  (couplingPath 1 = confinementPoint) ∧
  (∀ t : ℝ, partitionFunction (couplingPath t).1 (couplingPath t).2 ≠ 0) ∧
  ContDiff ℝ ω (fun t : ℝ => Real.log (partitionFunction (couplingPath t).1 (couplingPath t).2)) ∧
  ContDiff ℝ ω (fun t : ℝ => expectPlaquette (couplingPath t).1 (couplingPath t).2)

/-- The finite Fradkin–Shenker complementarity statement holds: the Higgs-like and
confinement-like points are joined by an explicit path with no zero of `Z` and along which the
free energy and a gauge-invariant order parameter are analytic. -/
theorem fradkinShenker_finite_complementarity : FradkinShenkerFiniteComplementarity :=
  ⟨couplingPath_zero, couplingPath_one,
   fun _ => partitionFunction_ne_zero _ _,
   logPartition_analytic_along_path,
   expectPlaquette_analytic_along_path⟩

end PhysicsSM.Draft.NullEdge.GateI1.FradkinShenkerFinite
