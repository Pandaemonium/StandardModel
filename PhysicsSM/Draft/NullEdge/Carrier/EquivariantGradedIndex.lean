/-
# The equivariant graded index: the program's candidate organizing theorem

DRAFT (kernel-clean; no `s o r r y`). The structural core of the finite
equivariant-index framework proposed in Fable call-03 (Part A), overnight
all-mass run 2026-07-08. Full design + corollary map:
`AgentTasks/overnight-allmass-run-2026-07-08/CALL03_UNIFIER_S6WITNESS_MASSGAP.md`.
Strategy / over-claim analysis for this file: `src/ORGANIZING_THEOREM_STRATEGY.md`.

## The framework (why one theorem organizes §§4, 6, 8)

Three gradings the program discovered separately - the chirality `Gamma`,
the closure bivector `b = sigma_z (x) 1` (S1-CC), and the
edge-orientation-reversal grading of the GW structure - are all ODD
elements of ONE symmetry group acting on the decorated complex; gauge
transformations and the reflection `R` (C4) are EVEN elements. The master
invariant is the equivariant supertrace `tr(Gamma g | sector)`, and its
three uses are `g = 1` (McKean-Singer index protection,
`chiralIndex_eq_graded_dimension`), `g = R` (the C4 sectored pinning), and
"an odd element exists" (S1-CC: the closure form has an exact supersymmetry,
so its Witten index vanishes sector-by-sector, forcing balanced inertia).
In the code `b` and the C4 witness grading are LITERALLY the same matrix
`sigma_z` - that identity is the framework, not a coincidence.

## What this file lands (the structural core + the provable-half identities)

The master object is the **equivariant graded (super)trace**
`sdim_g(A) := tr(Gamma * g * A)`, a `ℂ`-linear functional on operators.
The organizing theorem's *provable half* is the collection of exact finite
identities this functional satisfies; the *aspirational half* (a topological
index theorem a la Atiyah-Singer) is NOT claimed - see the strategy note.

Structural core (unchanged):
* `IsOddInvolutionFor`, `IsEvenSymmetryFor`: the shared data (an odd
  involution grading, an even commuting symmetry).
* `chiralProduct_involution`: `C := Gamma * W` is an involution.
* `sector_pins_W_fixed`: common eigenvectors of `Gamma` and `C` are `W`-fixed.

Provable-half graded-trace identities (the sharpest true finite statements):
* `graded_trace_odd_vanishes`: `sdim_g` of an *odd* operator is `0`
  (the finite McKean-Singer supersymmetric cancellation).
* `gamma_pow_comm`, `graded_trace_odd_power_vanishes`: `tr(Gamma * D^(2k+1)) = 0`
  - only *even* powers of the Dirac operator (i.e. functions of `D^#D`) can
  contribute to the supertrace: the finite "localizes to `D^#D`" statement.
* `graded_trace_sum`: `sdim_g(Sum_i Q_i) = Sum_i sdim_g(Q_i)` - additivity;
  "unification is decomposition" over an arbitrary channel index.
* `graded_budget_decomposition`: the exact Dirac-square budget
  `4 D^#D = Q_A + Q_C + 4 Q_T + 4 E_#` becomes ONE equivariant graded
  identity relating the four channels' graded indices to the total.
* `graded_trace_sector_split`: `sdim(A) = sdim_{P_+}(A) + sdim_{P_-}(A)` for
  the reflection sectors `P_+- = (1 +- R)/2` - the C4 isotypic refinement.

## Claim boundary

Provable half only (finite linear algebra: trace cyclicity + eigenvalue
pairing). This file makes NO topological-index claim: there is no base space,
no family of Dirac operators, no K-theory class, and no characteristic-class
formula. The finite "index" here is literally `str(ker D)` and is computed
directly, not by topology (manuscript S2a is explicit about this). The
remaining substance - L3 `graded_supertrace_localizes_to_kernel` (finrank
form of McKean-Singer), L4 `sector_involution_pinning` (the `dim >= |nu|`
counting, C4), the balanced-inertia capstone (L2, `anticonj_charpoly_eq` ->
`n_+ = n_-`), and the RG-Schur bridge (L5) - are documented M-targets that
need the spectral/eigenspace `finrank` API and are handed off.

## Provenance

Fable call-03 (2026-07-08), Part A - the organizing theorem and its Lean
design - [orig]/[interp]; the involution and trace algebra is elementary -
[import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Shared data (odd face).** `Gamma` is an odd involution for the
operator `X`: a Hermitian self-inverse grading anticommuting with `X`. The
additive-face hypothesis of the master theorem (S1-CC / index protection). -/
structure IsOddInvolutionFor (Gamma X : Matrix n n ℂ) : Prop where
  invol : Gamma * Gamma = 1
  herm : Gammaᴴ = Gamma
  anti : Gamma * X = -(X * Gamma)

/-- **Shared data (even face).** `g` is an even symmetry: it commutes with
both the operator `X` and the grading `Gamma`. The gauge group and the C4
reflection `R` are even elements. -/
structure IsEvenSymmetryFor (g X Gamma : Matrix n n ℂ) : Prop where
  commX : g * X = X * g
  commGamma : g * Gamma = Gamma * g

/-- **The chiral product is an involution (the sector-index heart).** For an
odd involution `Gamma` (`Gamma^2 = 1`) and a unitary `W` (`Wᴴ W = 1`) with
`Gamma W Gamma = Wᴴ` (the multiplicative face), `C := Gamma * W` satisfies
`C^2 = 1`. So `V` splits into `C`'s `+-1` eigenspaces, and together with
`Gamma`'s split this pins the `+-1` eigenvalues of `W` - the multiplicative
face of the same anticonjugation that gives the additive balanced inertia. -/
theorem chiralProduct_involution (Gamma W : Matrix n n ℂ)
    (hchiral : Gamma * W * Gamma = Wᴴ) (hU : Wᴴ * W = 1) :
    (Gamma * W) * (Gamma * W) = 1 := by
  rw [← mul_assoc (Gamma * W) Gamma W, hchiral, hU]

/-- **The sector mode-production heart (clause (iii), spectral-theorem-free).**
If a vector `v` is a common `s`-eigenvector of the grading `Gamma` and the
chiral product `C = Gamma W` for a sign `s` (`s^2 = 1`, so `s = +-1`), then
`v` is a fixed vector of `W`: `W v = v`. This is why BOTH the `(+1,+1)` and
`(-1,-1)` sectors of `(Gamma, C)` land in `ker(W - 1)` - the finite
mode-production fact behind the sectored pinning inequality (the finrank
counting `dim >= |nu|` is the remaining L4 step). No eigenvalues, no
spectral theorem - pure `mulVec` algebra. -/
theorem sector_pins_W_fixed (Gamma W : Matrix n n ℂ) (v : n → ℂ) (s : ℂ)
    (hGamma : Gamma * Gamma = 1) (hs : s * s = 1)
    (hGv : Gamma.mulVec v = s • v)
    (hCv : (Gamma * W).mulVec v = s • v) :
    W.mulVec v = v := by
  have h2 : Gamma.mulVec ((Gamma * W).mulVec v) = Gamma.mulVec (s • v) := by
    rw [hCv]
  rw [Matrix.mulVec_mulVec, ← mul_assoc, hGamma, one_mul, Matrix.mulVec_smul,
    hGv, smul_smul, hs, one_smul] at h2
  exact h2

/-! ## The provable half: exact finite graded-trace identities

The equivariant graded supertrace is `sdim_g(A) := (Gamma * g * A).trace`.
The following are the sharpest TRUE finite statements the framework supports.
They are pure linear algebra (trace cyclicity + a sign), NOT a topological
index theorem. -/

omit [DecidableEq n] in
/-- **Supersymmetric cancellation (finite McKean-Singer, `g`-equivariant).**
If `Gamma` anticommutes with an operator `X` (`X` is *odd*) and the even
symmetry `g` commutes with `X`, then the equivariant supertrace of `X`
vanishes: `tr(Gamma * g * X) = 0`. This is the finite algebraic heart of
"the supertrace sees only the kernel": odd contributions cancel between the
two chirality sectors. Only `[g, X] = 0` is needed here (not `[g, Gamma]`),
so the even-face commutation with `Gamma` is deliberately omitted. -/
theorem graded_trace_odd_vanishes (Gamma g X : Matrix n n ℂ)
    (hanti : Gamma * X = -(X * Gamma)) (hgX : g * X = X * g) :
    (Gamma * g * X).trace = 0 := by
  have h1 : Gamma * g * X = -(X * Gamma * g) := by
    have h0 : Gamma * g * X = Gamma * (g * X) := by rw [mul_assoc]
    rw [h0, hgX, ← mul_assoc, hanti, neg_mul, mul_assoc]
  have h2 : (Gamma * g * X).trace = (X * Gamma * g).trace := by
    rw [Matrix.trace_mul_comm (Gamma * g) X, mul_assoc]
  rw [h1, Matrix.trace_neg] at h2
  have ht : (X * Gamma * g).trace = 0 := self_eq_neg.mp (id (Eq.symm h2))
  rw [h1, Matrix.trace_neg, ht, neg_zero]

/-- If `Gamma` anticommutes with `D`, then `Gamma * D^m = (-1)^m • (D^m * Gamma)`:
the grading picks up the parity of the power. The engine behind
`graded_trace_odd_power_vanishes`. -/
theorem gamma_pow_comm (Gamma D : Matrix n n ℂ) (hanti : Gamma * D = -(D * Gamma)) :
    ∀ m : ℕ, Gamma * D ^ m = (-1 : ℂ) ^ m • (D ^ m * Gamma) := by
  intro m
  induction m with
  | zero => simp
  | succ k ih =>
    have step : Gamma * D ^ (k + 1) = (Gamma * D ^ k) * D := by rw [pow_succ, ← mul_assoc]
    rw [step, ih, Matrix.smul_mul, mul_assoc, hanti, mul_neg, ← mul_assoc, ← pow_succ,
        pow_succ (-1 : ℂ)]
    module

/-- **Localization to `D^#D` (finite McKean-Singer, odd powers).**
For a Dirac operator `D` anticommuting with the grading `Gamma`, the
supertrace of every *odd* power of `D` vanishes: `tr(Gamma * D^(2k+1)) = 0`.
Hence any supertrace that is a power series in `D` reduces to a series in the
*even* powers `D^(2k) = (D^#D)^k` - the finite face of "the supertrace of the
heat kernel localizes to `D^#D` / to the kernel of `D`." -/
theorem graded_trace_odd_power_vanishes (Gamma D : Matrix n n ℂ)
    (hanti : Gamma * D = -(D * Gamma)) (k : ℕ) :
    (Gamma * D ^ (2 * k + 1)).trace = 0 := by
  have h := gamma_pow_comm Gamma D hanti (2 * k + 1)
  have hsign : (-1 : ℂ) ^ (2 * k + 1) = -1 := by rw [pow_succ, pow_mul]; norm_num
  rw [hsign, neg_one_smul] at h
  have hcyc : (Gamma * D ^ (2 * k + 1)).trace = (D ^ (2 * k + 1) * Gamma).trace :=
    Matrix.trace_mul_comm _ _
  rw [h, Matrix.trace_neg] at hcyc
  have ht : (D ^ (2 * k + 1) * Gamma).trace = 0 := self_eq_neg.mp (id (Eq.symm hcyc))
  rw [h, Matrix.trace_neg, ht, neg_zero]

omit [DecidableEq n] in
/-- **Unification is decomposition (additivity of the graded index).**
The equivariant graded supertrace of a channel sum is the sum of the
per-channel graded supertraces: `sdim_g(Sum_i Q_i) = Sum_i sdim_g(Q_i)`.
This is the exact, general form of the organizing slogan. -/
theorem graded_trace_sum {ι : Type*} (s : Finset ι) (Gamma g : Matrix n n ℂ)
    (Q : ι → Matrix n n ℂ) :
    (Gamma * g * (∑ i ∈ s, Q i)).trace = ∑ i ∈ s, (Gamma * g * Q i).trace := by
  rw [Finset.mul_sum, Matrix.trace_sum]

omit [DecidableEq n] in
/-- **The Dirac-square budget as one equivariant graded identity.**
Given the four-channel budget `4 (D^# D) = Q_A + Q_C + 4 Q_T + 4 E_#`
(aperture/kinetic, closure/QCD, turn/Higgs, soldering/gravity), the four
channels' graded indices assemble into the total graded index:
`4 sdim_g(D^#D) = sdim_g(Q_A) + sdim_g(Q_C) + 4 sdim_g(Q_T) + 4 sdim_g(E_#)`.
This is the honest content of "the four channels ARE the graded pieces of one
equivariant index": an exact additive decomposition of the master functional.
It is NOT the claim that this common value is a topological invariant. -/
theorem graded_budget_decomposition
    (Gamma g Dsharp D QA QC QT E : Matrix n n ℂ)
    (hbudget : (4 : ℂ) • (Dsharp * D) = QA + QC + (4 : ℂ) • QT + (4 : ℂ) • E) :
    (4 : ℂ) • (Gamma * g * (Dsharp * D)).trace
      = (Gamma * g * QA).trace + (Gamma * g * QC).trace
        + (4 : ℂ) • (Gamma * g * QT).trace + (4 : ℂ) • (Gamma * g * E).trace := by
  have key : (Gamma * g * ((4 : ℂ) • (Dsharp * D))).trace
      = (Gamma * g * (QA + QC + (4 : ℂ) • QT + (4 : ℂ) • E)).trace := by rw [hbudget]
  simp only [Matrix.mul_smul, mul_add, Matrix.trace_add, Matrix.trace_smul,
    smul_eq_mul] at key ⊢
  linear_combination key

/-- **The C4 isotypic refinement (reflection-sectored split).**
For a reflection `R`, the graded index splits over the two sectors
`P_+- = (1 +- R)/2`: `sdim(A) = sdim_{P_+}(A) + sdim_{P_-}(A)`. This needs
only `P_+ + P_- = 1` (an algebraic identity in `ℂ`); that `P_+-` are the
`R`-eigenprojections is the extra input `R^2 = 1` used downstream to make the
per-sector values integers `nu_0(chi), nu_pi(chi)`. -/
theorem graded_trace_sector_split (Gamma R A : Matrix n n ℂ) :
    (Gamma * A).trace
      = (Gamma * ((2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) + R)) * A).trace
        + (Gamma * ((2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) - R)) * A).trace := by
  have hsum : (2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) + R) + (2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) - R)
      = 1 := by rw [← smul_add]; module
  calc (Gamma * A).trace
      = (Gamma * (((2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) + R)
            + (2 : ℂ)⁻¹ • ((1 : Matrix n n ℂ) - R)) * A)).trace := by rw [hsum, one_mul]
    _ = _ := by rw [add_mul, mul_add, Matrix.trace_add, mul_assoc, mul_assoc]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.chiralProduct_involution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiralProduct_involution

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.sector_pins_W_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sector_pins_W_fixed

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.graded_trace_odd_vanishes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms graded_trace_odd_vanishes

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.graded_trace_odd_power_vanishes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms graded_trace_odd_power_vanishes

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.graded_budget_decomposition' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms graded_budget_decomposition

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.graded_trace_sector_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms graded_trace_sector_split

end PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex
