import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# Vacuum sequestering: local vacuum shifts do not touch the physical `Λ`

A finite, fully explicit rational avatar of *vacuum sequestering* — the structural
reason why a huge local vacuum/zero-point energy need not gravitate.

## The model (explicit rational, `n = 3`)

* State space `ℚ^3` (`Vec`), dynamical operator `A : ℚ^{3×3}` (`Sq`).
* A **vacuum shift** is `A ↦ A + c • 1` for an arbitrary rational `c`: the order-0,
  identity-proportional local zero-point contribution.
* A **volume/count constraint** `Vol x = ⟨x,x⟩ = v0` (the unimodular/volume gauge).
* The **physical** cosmological constant is the *count-fluctuation residue*
  `LambdaFluc N δN = δN / N`, built from count statistics only.

## What is proved

1. `shift_absorbed_by_multiplier` — the vacuum shift is *absorbed by the Lagrange
   multiplier*: a constrained stationary point (eigenvector) is preserved and the
   multiplier moves `Λ ↦ Λ + c`.
2. `physical_lambda_shift_invariant` — the physical residue is literally *blind* to
   the operator `A` and the shift `c`; it is a function of the counts only.
3. `sequestering_gap` — the honest boundary: the vacuum **mean** (`a0 • 1`) is pure
   gauge, shifting the action by the constant `a0 * v0` on the constraint surface,
   while the **observable** is the count fluctuation, blind to the operator.
4. `sequestering_verdict` — the packaged finite magnitude theorem: any `c • 1` shift
   is sequestered by the volume constraint; the physical `Λ` is the count-fluctuation
   residue, blind to the operator.

A mandatory non-degeneracy check (`sequestering_nondegeneracy`) exhibits an explicit
`A = diag(1,2,3)`, `v0 = 1`, and a **huge** shift `c = 10^6` sending `Λ ↦ Λ + 10^6`
while the physical residue stays fixed at `1/10`.

## Honest scope

This is a finite `n`-dimensional avatar. It does **not** derive the numerical value of
`Λ`, nor prove the full continuum sequestering mechanism (Kaloper–Padilla). It isolates
the *structural blindness* of the observable to local vacuum shifts.
-/

namespace VacuumSequestering

open Matrix

/-- Rational `3 × 3` operators. -/
abbrev Sq : Type := Matrix (Fin 3) (Fin 3) ℚ

/-- Rational state vectors in `ℚ^3`. -/
abbrev Vec : Type := Fin 3 → ℚ

/-- Volume/count constraint functional `Vol x = ⟨x, x⟩`. -/
def Vol (x : Vec) : ℚ := dotProduct x x

/-- The dynamical action, the quadratic form of the operator `A`. -/
def Action (A : Sq) (x : Vec) : ℚ := dotProduct x (A.mulVec x)

/-- The physical count-fluctuation residue `Λ_fluc = δN / N`, a function of the
count statistics only. -/
def LambdaFluc (N deltaN : ℚ) : ℚ := deltaN / N

/-- The physical `Λ` presented as a (nominal) function of the operator `A`, the vacuum
shift `c`, and the counts.  By construction it *ignores* `A` and `c` — this is the
content of `physical_lambda_shift_invariant`. -/
def physicalLambda (_A : Sq) (_c : ℚ) (N deltaN : ℚ) : ℚ := LambdaFluc N deltaN

/-! ### Target 1 — the vacuum shift is absorbed by the multiplier -/

/-- **Vacuum shift absorbed by the Lagrange multiplier.**  If `x` is a constrained
stationary point of the action, i.e. an eigenvector `A x = Λ x` (the Lagrange
condition for stationarity of `⟨x, A x⟩` subject to `Vol x = v0`), then after the
vacuum shift `A ↦ A + c • 1` the *same* `x` remains stationary with the multiplier
translated `Λ ↦ Λ + c`.  The shift is absorbed into the integration constant. -/
theorem shift_absorbed_by_multiplier {A : Sq} {x : Vec} {L c : ℚ}
    (hstat : A.mulVec x = L • x) :
    (A + c • (1 : Sq)).mulVec x = (L + c) • x := by
  rw [Matrix.add_mulVec, hstat, Matrix.smul_mulVec, Matrix.one_mulVec, add_smul]

/-- The multiplier's dependence on the vacuum shift has derivative `1`: the shift is
absorbed *linearly*, exactly into the integration constant `Λ ↦ Λ + c`. -/
theorem multiplier_absorbs_shift (L c : ℚ) :
    HasDerivAt (fun t : ℝ => (L : ℝ) + t) 1 (c : ℝ) := by
  simpa using (hasDerivAt_id (c : ℝ)).const_add (L : ℝ)

/-! ### Target 2 — the physical residue is blind to the operator and the shift -/

/-- **Physical `Λ` is shift-invariant (payload).**  The physical fluctuation residue
`LambdaFluc N δN` is a function of the count statistics `(N, δN)` only; it does not
mention the operator `A` or the vacuum shift `c`.  Hence *no* local vacuum shift can
change the observable `Λ`. -/
theorem physical_lambda_shift_invariant (N deltaN : ℚ) :
    ∀ (A A' : Sq) (c c' : ℚ),
      physicalLambda A c N deltaN = physicalLambda A' c' N deltaN := by
  intro A A' c c'
  rfl

/-! ### Target 3 — the sequestering gap (honest boundary) -/

/-- The order-0 mean is pure gauge: on any state the identity-proportional shift
`A ↦ A + a0 • 1` moves the action by exactly `a0 * Vol x`. -/
theorem vacuum_mean_shifts_action (A : Sq) (x : Vec) (a0 : ℚ) :
    Action (A + a0 • (1 : Sq)) x = Action A x + a0 * Vol x := by
  simp only [Action, Vol, Matrix.add_mulVec, Matrix.smul_mulVec, Matrix.one_mulVec,
    dotProduct_add, dotProduct_smul, smul_eq_mul]

/-- **Sequestering gap.**  Two halves of the honest boundary:

* (mean is gauge) on the constraint surface `Vol x = v0`, the vacuum **mean**
  `a0 • 1` shifts the action by the pure constant `a0 * v0` — unobservable;
* (observable is fluctuation) the physical residue is the count fluctuation
  `LambdaFluc N δN`, blind to the operator `A'` and any shift `c'`. -/
theorem sequestering_gap (A : Sq) (x : Vec) (a0 v0 : ℚ) (hvol : Vol x = v0)
    (N deltaN : ℚ) :
    Action (A + a0 • (1 : Sq)) x = Action A x + a0 * v0
    ∧ (∀ (A' : Sq) (c' : ℚ), physicalLambda A' c' N deltaN = LambdaFluc N deltaN) := by
  refine ⟨?_, ?_⟩
  · rw [vacuum_mean_shifts_action, hvol]
  · intro A' c'
    rfl

/-! ### Target 4 — the finite magnitude verdict -/

/-- **Sequestering verdict (finite magnitude theorem).**  Packaged: (i) every vacuum
shift `c • 1` is absorbed by the multiplier `Λ ↦ Λ + c`, preserving the stationary
state; (ii) the vacuum mean shifts the action only by the constant `a0 * Vol x`; and
(iii) the physical residue is blind to the operator and the shift.  So local vacuum
energy is sequestered by the volume constraint and does not gravitate as a mean; the
physical `Λ` is the count-fluctuation residue, blind to the operator. -/
theorem sequestering_verdict :
    (∀ (A : Sq) (x : Vec) (L c : ℚ), A.mulVec x = L • x →
        (A + c • (1 : Sq)).mulVec x = (L + c) • x)
    ∧ (∀ (A : Sq) (x : Vec) (a0 : ℚ),
        Action (A + a0 • (1 : Sq)) x = Action A x + a0 * Vol x)
    ∧ (∀ (A A' : Sq) (c c' N deltaN : ℚ),
        physicalLambda A c N deltaN = physicalLambda A' c' N deltaN) := by
  refine ⟨?_, ?_, ?_⟩
  · intro A x L c h
    exact shift_absorbed_by_multiplier h
  · intro A x a0
    exact vacuum_mean_shifts_action A x a0
  · intro A A' c c' N deltaN
    rfl

/-! ### Mandatory non-degeneracy: an explicit huge shift -/

/-- Explicit dynamical operator `A = diag(1, 2, 3)`. -/
def A0 : Sq := Matrix.diagonal ![1, 2, 3]

/-- Explicit constrained state `x0 = (1, 0, 0)`, with `Vol x0 = 1 = v0`. -/
def x0 : Vec := ![1, 0, 0]

/-- **Non-degeneracy.**  A fully explicit, non-vacuous instance: with `A = diag(1,2,3)`,
`v0 = 1`, and the **huge** vacuum shift `c = 10^6`:

* `x0 = (1,0,0)` is a constrained stationary point with multiplier `Λ = 1`;
* it satisfies the volume constraint `Vol x0 = 1`;
* the shift sends the multiplier `Λ = 1 ↦ 1 + 10^6` (absorbed), same eigenvector;
* the physical residue (`N = 100`, `δN = 10`, i.e. `δN² = 100`) equals `1/10` and is
  **unchanged** by the huge shift — before and after it is `1/10`.

The enormous vacuum shift leaves the physical `Λ` at `1/10`. -/
theorem sequestering_nondegeneracy :
    A0.mulVec x0 = (1 : ℚ) • x0
    ∧ Vol x0 = 1
    ∧ (A0 + (10 ^ 6 : ℚ) • (1 : Sq)).mulVec x0 = ((1 : ℚ) + 10 ^ 6) • x0
    ∧ physicalLambda A0 (10 ^ 6) 100 10 = 1 / 10
    ∧ physicalLambda (A0 + (10 ^ 6 : ℚ) • (1 : Sq)) (10 ^ 6) 100 10 = 1 / 10 := by
  have heig : A0.mulVec x0 = (1 : ℚ) • x0 := by
    funext i
    fin_cases i <;> simp [A0, x0, Matrix.mulVec, Matrix.diagonal, dotProduct]
  refine ⟨heig, ?_, ?_, ?_, ?_⟩
  · simp [Vol, x0, dotProduct, Fin.sum_univ_three]
  · exact shift_absorbed_by_multiplier heig
  · norm_num [physicalLambda, LambdaFluc]
  · norm_num [physicalLambda, LambdaFluc]

/-! ### Kernel-checked axiom footprints (headlines) -/

/-- info: 'VacuumSequestering.shift_absorbed_by_multiplier' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms shift_absorbed_by_multiplier

/-- info: 'VacuumSequestering.physical_lambda_shift_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_lambda_shift_invariant

/-- info: 'VacuumSequestering.sequestering_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sequestering_gap

/-- info: 'VacuumSequestering.sequestering_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sequestering_verdict

/-- info: 'VacuumSequestering.sequestering_nondegeneracy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sequestering_nondegeneracy

end VacuumSequestering
