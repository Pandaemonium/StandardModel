import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# Lambda / gravity / matter as the 0 / 2 / 4 moments of one spectral functional

Rung L5.  We package the three physical loci — the cosmological constant `Λ`, gravity, and
matter — as the order-0, order-2 and order-4 moments of a *single* finite rational spectral
functional

  `S(D) = a0 · tr 1 + a2 · tr (D^2) + a4 · tr (D^4)`

built from one finite rational Dirac operator `D` carried on a 4-dimensional space.  A
"deformation" is any move `D ↦ D + Pert` with `Pert` an arbitrary rational matrix (a gauge move, a
channel coupling, a soldering decoration).

The structural payload (`order0_deformation_invariant`) is that the order-0 term `a0 · tr 1` sees
*only* the dimension/count `tr 1 = n`, never the operator: it is literally invariant under every
deformation `D ↦ D + Pert`.  Hence `Λ` has no channel pathway — no operator physics can reach it —
and its only degree of freedom is the count statistic `tr 1 = n`.  This is the finite dissolution
of the magnitude problem.

Honest scope: this is a finite polynomial-moment *avatar* of the spectral action; the physical
identifications (order 0 ↔ Λ, order 2 ↔ gravity, order 4 ↔ matter) stay at confidence level [C].
-/

namespace LambdaMomentHierarchy

open Matrix

/-! ## The single functional and its three moments -/

/-- Order-0 moment (the `Λ` / count / volume term): `a0 · tr 1`.
The operator argument `_M` is deliberately **ignored** — this is the channel-blindness core.
`tr 1` sees only the dimension, never the Dirac operator. -/
def order0 {n : ℕ} (a0 : ℚ) (_M : Matrix (Fin n) (Fin n) ℚ) : ℚ :=
  a0 * (1 : Matrix (Fin n) (Fin n) ℚ).trace

/-- Order-2 moment (gravity / curvature / soldering term): `a2 · tr (D^2)`. -/
def order2 {n : ℕ} (a2 : ℚ) (M : Matrix (Fin n) (Fin n) ℚ) : ℚ := a2 * (M ^ 2).trace

/-- Order-4 moment (matter / Yang–Mills / Higgs term): `a4 · tr (D^4)`. -/
def order4 {n : ℕ} (a4 : ℚ) (M : Matrix (Fin n) (Fin n) ℚ) : ℚ := a4 * (M ^ 4).trace

/-- The single finite spectral functional as the sum of its three moments. -/
def S {n : ℕ} (a0 a2 a4 : ℚ) (M : Matrix (Fin n) (Fin n) ℚ) : ℚ :=
  order0 a0 M + order2 a2 M + order4 a4 M

/-! ## The explicit rational carrier `D` (dimension `n = 4`)

`D = Dgrav + Dmatter` splits into a nonzero soldering (gravity) part with coupling `2` and a
nonzero matter part with coupling `3`. -/

/-- Gravity / soldering part: an off-diagonal soldering block with coupling `2`. -/
def Dgrav : Matrix (Fin 4) (Fin 4) ℚ := !![0, 2, 0, 0; 2, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0]

/-- Matter part: a diagonal matter block with coupling `3`. -/
def Dmatter : Matrix (Fin 4) (Fin 4) ℚ := !![0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 3, 0; 0, 0, 0, 3]

/-- The full explicit rational Dirac operator, gravity plus matter. -/
def D : Matrix (Fin 4) (Fin 4) ℚ := Dgrav + Dmatter

/-- A general two-coupling family: soldering coupling `g`, matter coupling `m`. -/
def Dfam (g m : ℚ) : Matrix (Fin 4) (Fin 4) ℚ :=
  !![0, g, 0, 0; g, 0, 0, 0; 0, 0, m, 0; 0, 0, 0, m]

/-- An explicit rational deformation `Pert` (a soldering-channel coupling). -/
def Pert : Matrix (Fin 4) (Fin 4) ℚ := !![0, 1, 0, 0; 1, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0]

/-- Non-degeneracy: both the gravity and the matter parts are nonzero. -/
theorem parts_nonzero : Dgrav ≠ 0 ∧ Dmatter ≠ 0 := by
  refine ⟨?_, ?_⟩
  · intro h
    have := congrFun (congrFun h 0) 1
    simp [Dgrav] at this
  · intro h
    have := congrFun (congrFun h 2) 2
    simp [Dmatter] at this

/-! ## Target 1 — the moment hierarchy

One functional, three moments.  Using the two-coupling family `Dfam g m`, the order-0 term carries
**neither** coupling (it is the pure count `a0 · 4`), while the order-2 term carries the soldering
coupling `g` and the order-4 term carries the matter coupling `m`.  The full action is exactly the
sum of the three. -/
theorem moment_hierarchy (a0 a2 a4 g m : ℚ) :
    order0 a0 (Dfam g m) = a0 * 4 ∧
    order2 a2 (Dfam g m) = a2 * (2 * g ^ 2 + 2 * m ^ 2) ∧
    order4 a4 (Dfam g m) = a4 * (2 * g ^ 4 + 2 * m ^ 4) ∧
    S a0 a2 a4 (Dfam g m)
      = a0 * 4 + a2 * (2 * g ^ 2 + 2 * m ^ 2) + a4 * (2 * g ^ 4 + 2 * m ^ 4) := by
  have h0 : order0 a0 (Dfam g m) = a0 * 4 := by
    unfold order0; rw [Matrix.trace_one, Fintype.card_fin]; norm_num
  have t2 : ((Dfam g m) ^ 2).trace = 2 * g ^ 2 + 2 * m ^ 2 := by
    simp [Matrix.trace, Matrix.diag, pow_succ, pow_zero, Matrix.mul_apply,
      Fin.sum_univ_four, Dfam]
    ring
  have t4 : ((Dfam g m) ^ 4).trace = 2 * g ^ 4 + 2 * m ^ 4 := by
    simp [Matrix.trace, Matrix.diag, pow_succ, pow_zero, Matrix.mul_apply,
      Fin.sum_univ_four, Dfam]
    ring
  have h2 : order2 a2 (Dfam g m) = a2 * (2 * g ^ 2 + 2 * m ^ 2) := by
    unfold order2; rw [t2]
  have h4 : order4 a4 (Dfam g m) = a4 * (2 * g ^ 4 + 2 * m ^ 4) := by
    unfold order4; rw [t4]
  refine ⟨h0, h2, h4, ?_⟩
  unfold S
  rw [h0, h2, h4]

/-! ## Target 2 — the structural magnitude lemma: order-0 invariance

For **all** rational deformations `Pert` and any dimension `n`, the order-0 term is unchanged by
`D ↦ D + Pert`, and equals `a0 · n`.  There is no pathway from operator deformation into the
order-0 coefficient: `Λ` is blind to all dynamics; only the count `n` can move it. -/
theorem order0_deformation_invariant {n : ℕ} (a0 : ℚ)
    (Dop Pert : Matrix (Fin n) (Fin n) ℚ) :
    order0 a0 (Dop + Pert) = order0 a0 Dop ∧ order0 a0 Dop = a0 * (n : ℚ) := by
  refine ⟨rfl, ?_⟩
  unfold order0
  rw [Matrix.trace_one, Fintype.card_fin]

/-! ## Target 3 — contrast: only the count touches `Λ`

The same deformation `Pert` leaves the count `tr 1 = 4` fixed, yet **moves** both the gravity moment
`tr (D^2) : 26 → 36` and the matter moment `tr (D^4) : 194 → 324`.  So gravity and matter are
deformation-sensitive while `Λ` is not: only the dimension/count can move `Λ`. -/
theorem only_count_touches_lambda :
    (1 : Matrix (Fin 4) (Fin 4) ℚ).trace = 4 ∧
    (D ^ 2).trace = 26 ∧ ((D + Pert) ^ 2).trace = 36 ∧
    (D ^ 4).trace = 194 ∧ ((D + Pert) ^ 4).trace = 324 ∧
    ((D + Pert) ^ 2).trace ≠ (D ^ 2).trace ∧
    ((D + Pert) ^ 4).trace ≠ (D ^ 4).trace := by
  have e1 : (1 : Matrix (Fin 4) (Fin 4) ℚ).trace = 4 := by
    rw [Matrix.trace_one, Fintype.card_fin]; norm_num
  have e2 : (D ^ 2).trace = 26 := by
    simp [Matrix.trace, Matrix.diag, pow_succ, pow_zero, Matrix.mul_apply,
      Fin.sum_univ_four, D, Dgrav, Dmatter]; norm_num
  have e3 : ((D + Pert) ^ 2).trace = 36 := by
    simp [Matrix.trace, Matrix.diag, pow_succ, pow_zero, Matrix.mul_apply,
      Fin.sum_univ_four, D, Dgrav, Dmatter, Pert]; norm_num
  have e4 : (D ^ 4).trace = 194 := by
    simp [Matrix.trace, Matrix.diag, pow_succ, pow_zero, Matrix.mul_apply,
      Fin.sum_univ_four, D, Dgrav, Dmatter]; norm_num
  have e5 : ((D + Pert) ^ 4).trace = 324 := by
    simp [Matrix.trace, Matrix.diag, pow_succ, pow_zero, Matrix.mul_apply,
      Fin.sum_univ_four, D, Dgrav, Dmatter, Pert]; norm_num
  refine ⟨e1, e2, e3, e4, e5, ?_, ?_⟩
  · rw [e2, e3]; norm_num
  · rw [e4, e5]; norm_num

/-! ## Target 4 — the hierarchy verdict

One functional, three moments: `Λ` (order 0, count-only, channel-blind) / gravity (order 2,
soldering) / matter (order 4, channels).  The finite dissolution of the magnitude problem: `Λ` has
no channel pathway (order-0 invariance), so its only physics is count statistics. -/
theorem hierarchy_verdict :
    -- (a) `Λ` (order 0) is invariant under every deformation, in every dimension.
    (∀ (a0 : ℚ) {n : ℕ} (Dop Pert : Matrix (Fin n) (Fin n) ℚ),
        order0 a0 (Dop + Pert) = order0 a0 Dop) ∧
    -- (b) the single functional is exactly the sum of its three moments.
    (∀ (a0 a2 a4 : ℚ), S a0 a2 a4 D = order0 a0 D + order2 a2 D + order4 a4 D) ∧
    -- (c) yet gravity (order 2) and matter (order 4) genuinely move under the deformation `Pert`.
    ((D + Pert) ^ 2).trace ≠ (D ^ 2).trace ∧
    ((D + Pert) ^ 4).trace ≠ (D ^ 4).trace := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro a0 n Dop Pert; rfl
  · intro a0 a2 a4; rfl
  · exact (only_count_touches_lambda.2.2.2.2.2).1
  · exact (only_count_touches_lambda.2.2.2.2.2).2

/-! ## Kernel axiom footprint — exactly `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'LambdaMomentHierarchy.moment_hierarchy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms moment_hierarchy

/-- info: 'LambdaMomentHierarchy.order0_deformation_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms order0_deformation_invariant

/-- info: 'LambdaMomentHierarchy.only_count_touches_lambda' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms only_count_touches_lambda

/-- info: 'LambdaMomentHierarchy.hierarchy_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hierarchy_verdict

end LambdaMomentHierarchy
