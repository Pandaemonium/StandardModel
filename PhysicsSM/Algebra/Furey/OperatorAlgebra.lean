import PhysicsSM.Algebra.Furey.OperatorRepresentations

/-!
# Algebra.Furey.OperatorAlgebra

This module builds on `PhysicsSM.Algebra.Furey.OperatorRepresentations` to
prove that the operator-level color maps and charge map form the expected
finite-dimensional representation on the eight-state space `J`.

## Contents

- **Phase 1**: Complete color transition tables for all six off-diagonal
  color operators on all eight basis states.
- **Phase 2**: Matrix-unit composition identities on `J`.
- **Phase 3**: SU(3)-style commutator identities on `J`.
- **Phase 4**: Charge conservation — color operators commute with `Q_op` on `J`.
- **Phase 5**: Invariant subspace definitions and stability theorems.

## Critical convention

All operator compositions use the non-associative convention:
  `(Lmul a).comp (Lmul b)` means `x ↦ a * (b * x)`
This is NOT the same as `Lmul (a * b)` in a non-associative algebra.

Source: Furey, arXiv:1806.00612.
Provenance: clean-room formalization building on kernel-checked action tables
in `MinimalLeftIdeal.lean` and `OperatorRepresentations.lean`.

All theorems in this file are trusted finite-coordinate computations.
-/

namespace PhysicsSM.Algebra.Furey.MinimalLeftIdeal

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Furey.LadderOperators

/-!
## Phase 1: Complete Color Transition Tables

The existing file proves a subset of color transitions. Here we complete the
action tables for all six off-diagonal color operators on all eight basis states.

### Full action table (computed from the Cl(6) action table):

| Op     | omega | v1  | v2  | v3  | v4  | v5   | v6   | nu  |
|--------|-------|-----|-----|-----|-----|------|------|-----|
| T12_op |   0   |  0  | v1  |  0  |  0  |   0  |  v5  |  0  |
| T21_op |   0   | v2  |  0  |  0  |  0  |  v6  |   0  |  0  |
| T13_op |   0   |  0  |  0  | v1  |  0  |   0  | -v4  |  0  |
| T31_op |   0   | v3  |  0  |  0  | -v6 |   0  |   0  |  0  |
| T23_op |   0   |  0  |  0  | v2  |  0  |  v4  |   0  |  0  |
| T32_op |   0   |  0  | v3  |  0  | v5  |   0  |   0  |  0  |

The signs in the anti-down triplet (v4, v5, v6) arise from the minus signs
in the dagger action table (e.g., `alpha2_dag * v4 = -v1`).
-/

-- ============================================================================
-- T12_op complete table
-- ============================================================================

-- T12_op_omega, T12_op_v1, T12_op_v2, T12_op_v3, T12_op_nu already in
-- OperatorRepresentations.lean.

/-- `T12_op` annihilates the first anti-down color state `v4`.
    Calculation: alpha2_dag * v4 = -v1, then alpha1 * (-v1) = 0. -/
theorem T12_op_v4 : T12_op v4 = 0 := by
  simp [T12_op, act_a2d_v4, act_a1_v1]

/-- `T12_op` annihilates the second anti-down color state `v5`.
    Calculation: alpha2_dag * v5 = 0. -/
theorem T12_op_v5 : T12_op v5 = 0 := by
  simp [T12_op, act_a2d_v5]

/-- `T12_op` maps `v6` to `v5` in the anti-down sector.
    Calculation: alpha2_dag * v6 = v3, then alpha1 * v3 = v5. -/
theorem T12_op_v6 : T12_op v6 = v5 := by
  simp [T12_op, act_a2d_v6, act_a1_v3]

-- ============================================================================
-- T21_op complete table
-- ============================================================================

-- T21_op_v1, T21_op_v2 already in OperatorRepresentations.lean.

/-- `T21_op` annihilates `omega`. -/
theorem T21_op_omega : T21_op omega = 0 := by
  simp [T21_op, act_a1d_omega]

/-- `T21_op` annihilates `v3`. -/
theorem T21_op_v3 : T21_op v3 = 0 := by
  simp [T21_op, act_a1d_v3]

/-- `T21_op` annihilates `v4`.
    Calculation: alpha1_dag * v4 = v2, then alpha2 * v2 = 0. -/
theorem T21_op_v4 : T21_op v4 = 0 := by
  simp [T21_op, act_a1d_v4, act_a2_v2]

/-- `T21_op` maps `v5` to `v6` in the anti-down sector.
    Calculation: alpha1_dag * v5 = v3, then alpha2 * v3 = v6. -/
theorem T21_op_v5 : T21_op v5 = v6 := by
  simp [T21_op, act_a1d_v5, act_a2_v3]

/-- `T21_op` annihilates `v6`. -/
theorem T21_op_v6 : T21_op v6 = 0 := by
  simp [T21_op, act_a1d_v6]

/-- `T21_op` annihilates `nu`.
    Calculation: alpha1_dag * nu = v6, then alpha2 * v6 = 0. -/
theorem T21_op_nu : T21_op nu = 0 := by
  simp [T21_op, act_a1d_nu, act_a2_v6]

-- ============================================================================
-- T13_op complete table
-- ============================================================================

-- T13_op_v1, T13_op_v3 already in OperatorRepresentations.lean.

/-- `T13_op` annihilates `omega`. -/
theorem T13_op_omega : T13_op omega = 0 := by
  simp [T13_op, act_a3d_omega]

/-- `T13_op` annihilates `v2`. -/
theorem T13_op_v2 : T13_op v2 = 0 := by
  simp [T13_op, act_a3d_v2]

/-- `T13_op` annihilates `v4`. -/
theorem T13_op_v4 : T13_op v4 = 0 := by
  simp [T13_op, act_a3d_v4]

/-- `T13_op` annihilates `v5`.
    Calculation: alpha3_dag * v5 = -v1, then alpha1 * (-v1) = 0. -/
theorem T13_op_v5 : T13_op v5 = 0 := by
  simp [T13_op, act_a3d_v5, act_a1_v1]

/-- `T13_op` maps `v6` to `-v4` in the anti-down sector.
    Calculation: alpha3_dag * v6 = -v2, then alpha1 * (-v2) = -v4.
    The minus sign is a genuine feature of the operator action, not a
    convention error. -/
theorem T13_op_v6 : T13_op v6 = -v4 := by
  simp [T13_op, act_a3d_v6, act_a1_v2]

/-- `T13_op` annihilates `nu`.
    Calculation: alpha3_dag * nu = v4, then alpha1 * v4 = 0. -/
theorem T13_op_nu : T13_op nu = 0 := by
  simp [T13_op, act_a3d_nu, act_a1_v4]

-- ============================================================================
-- T31_op complete table
-- ============================================================================

-- T31_op_v1 already in OperatorRepresentations.lean.

/-- `T31_op` annihilates `omega`. -/
theorem T31_op_omega : T31_op omega = 0 := by
  simp [T31_op, act_a1d_omega]

/-- `T31_op` annihilates `v2`. -/
theorem T31_op_v2 : T31_op v2 = 0 := by
  simp [T31_op, act_a1d_v2]

/-- `T31_op` annihilates `v3`. -/
theorem T31_op_v3 : T31_op v3 = 0 := by
  simp [T31_op, act_a1d_v3]

/-- `T31_op` maps `v4` to `-v6` in the anti-down sector.
    Calculation: alpha1_dag * v4 = v2, then alpha3 * v2 = -v6.
    The minus sign is genuine. -/
theorem T31_op_v4 : T31_op v4 = -v6 := by
  simp [T31_op, act_a1d_v4, act_a3_v2]

/-- `T31_op` annihilates `v5`.
    Calculation: alpha1_dag * v5 = v3, then alpha3 * v3 = 0. -/
theorem T31_op_v5 : T31_op v5 = 0 := by
  simp [T31_op, act_a1d_v5, act_a3_v3]

/-- `T31_op` annihilates `v6`. -/
theorem T31_op_v6 : T31_op v6 = 0 := by
  simp [T31_op, act_a1d_v6]

/-- `T31_op` annihilates `nu`.
    Calculation: alpha1_dag * nu = v6, then alpha3 * v6 = 0. -/
theorem T31_op_nu : T31_op nu = 0 := by
  simp [T31_op, act_a1d_nu, act_a3_v6]

-- ============================================================================
-- T23_op complete table
-- ============================================================================

-- T23_op_v2, T23_op_v3 already in OperatorRepresentations.lean.

/-- `T23_op` annihilates `omega`. -/
theorem T23_op_omega : T23_op omega = 0 := by
  simp [T23_op, act_a3d_omega]

/-- `T23_op` annihilates `v1`. -/
theorem T23_op_v1 : T23_op v1 = 0 := by
  simp [T23_op, act_a3d_v1]

/-- `T23_op` annihilates `v4`. -/
theorem T23_op_v4 : T23_op v4 = 0 := by
  simp [T23_op, act_a3d_v4]

/-- `T23_op` maps `v5` to `v4` in the anti-down sector.
    Calculation: alpha3_dag * v5 = -v1, then alpha2 * (-v1) = -(-v4) = v4. -/
theorem T23_op_v5 : T23_op v5 = v4 := by
  simp [T23_op, act_a3d_v5, act_a2_v1]

/-- `T23_op` annihilates `v6`.
    Calculation: alpha3_dag * v6 = -v2, then alpha2 * (-v2) = 0. -/
theorem T23_op_v6 : T23_op v6 = 0 := by
  simp [T23_op, act_a3d_v6, act_a2_v2]

/-- `T23_op` annihilates `nu`.
    Calculation: alpha3_dag * nu = v4, then alpha2 * v4 = 0. -/
theorem T23_op_nu : T23_op nu = 0 := by
  simp [T23_op, act_a3d_nu, act_a2_v4]

-- ============================================================================
-- T32_op complete table
-- ============================================================================

-- T32_op_v2 already in OperatorRepresentations.lean.

/-- `T32_op` annihilates `omega`. -/
theorem T32_op_omega : T32_op omega = 0 := by
  simp [T32_op, act_a2d_omega]

/-- `T32_op` annihilates `v1`. -/
theorem T32_op_v1 : T32_op v1 = 0 := by
  simp [T32_op, act_a2d_v1]

/-- `T32_op` annihilates `v3`. -/
theorem T32_op_v3 : T32_op v3 = 0 := by
  simp [T32_op, act_a2d_v3]

/-- `T32_op` maps `v4` to `v5` in the anti-down sector.
    Calculation: alpha2_dag * v4 = -v1, then alpha3 * (-v1) = -(-v5) = v5. -/
theorem T32_op_v4 : T32_op v4 = v5 := by
  simp [T32_op, act_a2d_v4, act_a3_v1]

/-- `T32_op` annihilates `v5`. -/
theorem T32_op_v5 : T32_op v5 = 0 := by
  simp [T32_op, act_a2d_v5]

/-- `T32_op` annihilates `v6`.
    Calculation: alpha2_dag * v6 = v3, then alpha3 * v3 = 0. -/
theorem T32_op_v6 : T32_op v6 = 0 := by
  simp [T32_op, act_a2d_v6, act_a3_v3]

/-- `T32_op` annihilates `nu`.
    Calculation: alpha2_dag * nu = -v5, then alpha3 * (-v5) = 0. -/
theorem T32_op_nu : T32_op nu = 0 := by
  simp [T32_op, act_a2d_nu, act_a3_v5]

/-!
## Phase 2: Equality on `J` and matrix-unit identities

### `EqOnJ`

Two linear operators agree on the minimal left ideal `J` when they produce
the same output for every element of `J`.
-/

/-- Two linear maps agree on the span `J` of the eight basis states. -/
def EqOnJ (A B : ComplexOctonion →ₗ[Complex] ComplexOctonion) : Prop :=
  ∀ x : ComplexOctonion, x ∈ J → A x = B x

/-- `EqOnJ` is reflexive. -/
theorem EqOnJ_refl (A : ComplexOctonion →ₗ[Complex] ComplexOctonion) :
    EqOnJ A A := fun _ _ => rfl

/-- `EqOnJ` is symmetric. -/
theorem EqOnJ_symm {A B : ComplexOctonion →ₗ[Complex] ComplexOctonion}
    (h : EqOnJ A B) : EqOnJ B A := fun x hx => (h x hx).symm

/-- `EqOnJ` is transitive. -/
theorem EqOnJ_trans {A B C : ComplexOctonion →ₗ[Complex] ComplexOctonion}
    (h1 : EqOnJ A B) (h2 : EqOnJ B C) : EqOnJ A C :=
  fun x hx => (h1 x hx).trans (h2 x hx)

/--
To prove `EqOnJ A B`, it suffices to check equality on each of the eight
basis states. This is the workhorse lemma for all Phase 2–5 proofs.
-/
theorem EqOnJ_of_basis
    (A B : ComplexOctonion →ₗ[Complex] ComplexOctonion)
    (h : ∀ i : Fin 8, A (basisState i) = B (basisState i)) :
    EqOnJ A B := by
  intro x hx
  change x ∈ Submodule.span Complex (Set.range basisState) at hx
  refine Submodule.span_induction
    (p := fun x _ => A x = B x) ?mem ?zero ?add ?smul hx
  · rintro y ⟨i, rfl⟩
    exact h i
  · simp
  · intro x y _ _ hAx hAy
    rw [A.map_add, B.map_add, hAx, hAy]
  · intro a x _ hAx
    rw [A.map_smul, B.map_smul, hAx]

/-!
### Composition identities on basis states

Before proving full `EqOnJ` matrix-unit identities, we record the
composition actions on basis states.
-/

-- T12 ∘ T21 acts as: N1 - N2 projection-like on anti-up; similarly on anti-down
-- Specifically: T12(T21(vi)) for each i

/-- `T12_op ∘ T21_op` maps `v1` to `v1` (= N1_op − N2_op eigenvalue). -/
theorem T12_comp_T21_v1 : T12_op (T21_op v1) = v1 := by
  rw [T21_op_v1, T12_op_v2]

/-- `T12_op ∘ T21_op` annihilates `v2`. -/
theorem T12_comp_T21_v2 : T12_op (T21_op v2) = 0 := by
  rw [T21_op_v2]
  exact T12_op.map_zero

/-- `T12_op ∘ T21_op` annihilates `v3`. -/
theorem T12_comp_T21_v3 : T12_op (T21_op v3) = 0 := by
  rw [T21_op_v3]
  exact T12_op.map_zero

/-- `T21_op ∘ T12_op` annihilates `v1`. -/
theorem T21_comp_T12_v1 : T21_op (T12_op v1) = 0 := by
  rw [T12_op_v1]
  exact T21_op.map_zero

/-- `T21_op ∘ T12_op` maps `v2` to `v2`. -/
theorem T21_comp_T12_v2 : T21_op (T12_op v2) = v2 := by
  rw [T12_op_v2, T21_op_v1]

/-- `T21_op ∘ T12_op` annihilates `v3`. -/
theorem T21_comp_T12_v3 : T21_op (T12_op v3) = 0 := by
  rw [T12_op_v3]
  exact T21_op.map_zero

/-!
## Phase 3: SU(3)-Style Commutators

### Definitions
-/

/-- The commutator of two linear endomorphisms. -/
noncomputable def opComm (A B : ComplexOctonion →ₗ[Complex] ComplexOctonion) :
    ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  A.comp B - B.comp A

/-- Diagonal color operator H₁₂ = N₁ − N₂. -/
noncomputable def H12_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  N1_op - N2_op

/-- Diagonal color operator H₂₃ = N₂ − N₃. -/
noncomputable def H23_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  N2_op - N3_op

/-- Diagonal color operator H₁₃ = N₁ − N₃. -/
noncomputable def H13_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  N1_op - N3_op

-- Diagonal action table for H12_op
theorem H12_op_omega : H12_op omega = 0 := by
  simp [H12_op, N1_op_omega, N2_op_omega]

theorem H12_op_v1 : H12_op v1 = (-1 : Complex) • v1 := by
  simp [H12_op, N1_op_v1, N2_op_v1]

theorem H12_op_v2 : H12_op v2 = (1 : Complex) • v2 := by
  simp [H12_op, N1_op_v2, N2_op_v2]

theorem H12_op_v3 : H12_op v3 = 0 := by
  simp [H12_op, N1_op_v3, N2_op_v3]

theorem H12_op_v4 : H12_op v4 = 0 := by
  simp [H12_op, N1_op_v4, N2_op_v4]

theorem H12_op_v5 : H12_op v5 = (-1 : Complex) • v5 := by
  simp [H12_op, N1_op_v5, N2_op_v5]

theorem H12_op_v6 : H12_op v6 = (1 : Complex) • v6 := by
  simp [H12_op, N1_op_v6, N2_op_v6]

theorem H12_op_nu : H12_op nu = 0 := by
  simp [H12_op, N1_op_nu, N2_op_nu]

/-
============================================================================
Commutator [T12, T21] = H12 on J
============================================================================

The commutator `[T12_op, T21_op]` equals `-H12_op` on the ideal `J`.
    This is the SU(3) Chevalley relation for the (1,2) root.
    The minus sign arises because the number operators `N_k` count
    *occupied* modes rather than acting as color projections: the
    projection onto color `k` in the anti-up sector is `1 - N_k`, which
    reverses the sign relative to the naive matrix-unit expectation.
-/
theorem comm_T12_T21_eq_neg_H12 :
    EqOnJ (opComm T12_op T21_op) (-H12_op) := by
  -- By definition of commutator, we have [T12_op, T21_op] = T12_op.comp T21_op - T21_op.comp T12_op.
  unfold EqOnJ opComm H12_op;
  -- By definition of J, any element x in J can be written as a linear combination of the basis states.
  intro x hx
  obtain ⟨c, hc⟩ : ∃ c : Fin 8 → ℂ, x = ∑ i, c i • basisState i := by
    exact ( Finsupp.mem_span_range_iff_exists_finsupp.mp hx ) |> fun ⟨ c, hc ⟩ => ⟨ c, by simpa [ Finsupp.sum_fintype ] using hc.symm ⟩;
  simp_all +decide [ Fin.sum_univ_eight ];
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ] at *;
  simp +decide [ T12_op_v1, T12_op_v2, T12_op_v3, T12_op_v4, T12_op_v5, T12_op_v6, T12_op_omega, T12_op_nu, T21_op_v1, T21_op_v2, T21_op_v3, T21_op_v4, T21_op_v5, T21_op_v6, T21_op_omega, T21_op_nu, N1_op_omega, N1_op_v1, N1_op_v2, N1_op_v3, N1_op_v4, N1_op_v5, N1_op_v6, N1_op_nu, N2_op_omega, N2_op_v1, N2_op_v2, N2_op_v3, N2_op_v4, N2_op_v5, N2_op_v6, N2_op_nu ];
  abel1

/-
The commutator `[T13_op, T31_op]` equals `-H13_op` on `J`.
-/
theorem comm_T13_T31_eq_neg_H13 :
    EqOnJ (opComm T13_op T31_op) (-H13_op) := by
  intro x hx;
  -- By definition of $J$, we know that $x$ can be written as a linear combination of the basis elements.
  obtain ⟨c, hc⟩ : ∃ c : Fin 8 → Complex, x = ∑ i, c i • basisState i := by
    obtain ⟨ c, hc ⟩ := Finsupp.mem_span_range_iff_exists_finsupp.mp hx;
    exact ⟨ c, by simpa [ Finsupp.sum_fintype ] using hc.symm ⟩;
  unfold opComm H13_op;
  simp_all +decide [ Fin.sum_univ_eight ];
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ] at *;
  simp +decide [ T13_op_omega, T13_op_v1, T13_op_v2, T13_op_v3, T13_op_v4, T13_op_v5, T13_op_v6, T13_op_nu, T31_op_omega, T31_op_v1, T31_op_v2, T31_op_v3, T31_op_v4, T31_op_v5, T31_op_v6, T31_op_nu, N1_op_omega, N1_op_v1, N1_op_v2, N1_op_v3, N1_op_v4, N1_op_v5, N1_op_v6, N1_op_nu, N3_op_omega, N3_op_v1, N3_op_v2, N3_op_v3, N3_op_v4, N3_op_v5, N3_op_v6, N3_op_nu ];
  abel1

/-
The commutator `[T23_op, T32_op]` equals `-H23_op` on `J`.
-/
theorem comm_T23_T32_eq_neg_H23 :
    EqOnJ (opComm T23_op T32_op) (-H23_op) := by
  unfold opComm H23_op;
  -- By definition of $J$, we know that any element $x \in J$ can be written as a linear combination of the basis states.
  intro x hx
  obtain ⟨c, hc⟩ : ∃ c : Fin 8 → ℂ, x = ∑ i, c i • basisState i := by
    exact ( Finsupp.mem_span_range_iff_exists_finsupp.mp hx ) |> fun ⟨ c, hc ⟩ => ⟨ c, by simpa [ Finsupp.sum_fintype ] using hc.symm ⟩;
  simp_all +decide [ sub_eq_add_neg, Fin.sum_univ_eight ];
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ] at *;
  simp +decide [ T23_op_omega, T23_op_v1, T23_op_v2, T23_op_v3, T23_op_v4, T23_op_v5, T23_op_v6, T23_op_nu, T32_op_omega, T32_op_v1, T32_op_v2, T32_op_v3, T32_op_v4, T32_op_v5, T32_op_v6, T32_op_nu, N2_op_omega, N2_op_v1, N2_op_v2, N2_op_v3, N2_op_v4, N2_op_v5, N2_op_v6, N2_op_nu, N3_op_omega, N3_op_v1, N3_op_v2, N3_op_v3, N3_op_v4, N3_op_v5, N3_op_v6, N3_op_nu ];
  abel1

/-
The composition `[T12, T23] = T13` on `J` (Serre relation).
-/
theorem comm_T12_T23_eq_T13 :
    EqOnJ (opComm T12_op T23_op) T13_op := by
  intro x hx
  generalize_proofs at *;
  -- By definition of $J$, we know that $x$ can be written as a linear combination of the basis states.
  obtain ⟨c, hc⟩ : ∃ c : Fin 8 → Complex, x = ∑ i, c i • basisState i := by
    exact ( Finsupp.mem_span_range_iff_exists_finsupp.mp hx ) |> fun ⟨ c, hc ⟩ => ⟨ c, by simpa [ Finsupp.sum_fintype ] using hc.symm ⟩;
  -- Apply the linearity of the operators to expand the expression.
  simp [hc, Fin.sum_univ_eight, opComm];
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ];
  simp +decide [ T12_op_omega, T12_op_v1, T12_op_v2, T12_op_v3, T12_op_v4, T12_op_v5, T12_op_v6, T12_op_nu, T23_op_omega, T23_op_v1, T23_op_v2, T23_op_v3, T23_op_v4, T23_op_v5, T23_op_v6, T23_op_nu, T13_op_omega, T13_op_v1, T13_op_v2, T13_op_v3, T13_op_v4, T13_op_v5, T13_op_v6, T13_op_nu ];
  exact sub_eq_add_neg _ _

/-
The composition `[T21, T32] = -T31` on `J` (adjoint Serre relation).
    The minus sign is a genuine feature of the operator algebra in the
    XOR convention and is consistent with the anti-down sector signs.
-/
theorem comm_T21_T32_eq_neg_T31 :
    EqOnJ (opComm T21_op T32_op) (-T31_op) := by
  unfold EqOnJ;
  intros x hx
  have h_basis : ∃ c : Fin 8 → ℂ, x = ∑ i, c i • basisState i := by
    exact ( Finsupp.mem_span_range_iff_exists_finsupp.mp hx ) |> fun ⟨ c, hc ⟩ => ⟨ c, by simpa [ Finsupp.sum_fintype ] using hc.symm ⟩;
  obtain ⟨ c, rfl ⟩ := h_basis; simp +decide [ Fin.sum_univ_eight ] ;
  unfold opComm; simp +decide [ *, sub_eq_add_neg ] ;
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ];
  simp +decide [ T21_op_omega, T21_op_v1, T21_op_v2, T21_op_v3, T21_op_v4, T21_op_v5, T21_op_v6, T21_op_nu, T32_op_omega, T32_op_v1, T32_op_v2, T32_op_v3, T32_op_v4, T32_op_v5, T32_op_v6, T32_op_nu, T31_op_omega, T31_op_v1, T31_op_v2, T31_op_v3, T31_op_v4, T31_op_v5, T31_op_v6, T31_op_nu ];
  abel1

/-!
## Phase 4: Charge Conservation

Color operators commute with the electric charge operator `Q_op` on `J`.
This is because color transitions preserve the `Q_op` eigenvalue within the
anti-up and anti-down triplets, and annihilate the singlet states.
-/

/-
`Q_op` commutes with `T12_op` on `J`.
-/
theorem charge_conservation_T12 :
    EqOnJ (opComm Q_op T12_op) 0 := by
  unfold EqOnJ;
  intro x hx
  have h_basis : ∃ (c : Fin 8 → ℂ), x = ∑ i, c i • basisState i := by
    rw [ J ] at hx;
    rw [ Finsupp.mem_span_range_iff_exists_finsupp ] at hx;
    obtain ⟨ c, rfl ⟩ := hx; exact ⟨ c, by simp +decide [ Finsupp.sum_fintype ] ⟩ ;
  obtain ⟨ c, rfl ⟩ := h_basis;
  simp +decide [ opComm, Fin.sum_univ_eight ];
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ];
  simp +decide [ T12_op_omega, T12_op_v1, T12_op_v2, T12_op_v3, T12_op_v4, T12_op_v5, T12_op_v6, T12_op_nu, Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu ]

/-
`Q_op` commutes with `T21_op` on `J`.
-/
theorem charge_conservation_T21 :
    EqOnJ (opComm Q_op T21_op) 0 := by
  intro x hx
  have hx' : ∃ a b c d e f g h : Complex, x = a • omega + b • v1 + c • v2 + d • v3 + e • v4 + f • v5 + g • v6 + h • nu := by
    have h_span : x ∈ Submodule.span ℂ (Set.range basisState) := by
      exact hx;
    rw [ Submodule.mem_span_range_iff_exists_fun ] at h_span;
    obtain ⟨ c, rfl ⟩ := h_span; use c 0, c 1, c 2, c 3, c 4, c 5, c 6, c 7; simp +decide [ Fin.sum_univ_eight ] ;
    rfl;
  obtain ⟨ a, b, c, d, e, f, g, h, rfl ⟩ := hx';
  simp +decide [ opComm, Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu, T21_op_omega, T21_op_v1, T21_op_v2, T21_op_v3, T21_op_v4, T21_op_v5, T21_op_v6, T21_op_nu ]

/-
`Q_op` commutes with `T13_op` on `J`.
-/
theorem charge_conservation_T13 :
    EqOnJ (opComm Q_op T13_op) 0 := by
  intro x hx
  have h_basis : ∃ (c : Fin 8 → ℂ), x = ∑ i, c i • basisState i := by
    exact ( Finsupp.mem_span_range_iff_exists_finsupp.mp hx ) |> fun ⟨ c, hc ⟩ => ⟨ c, by simpa [ Finsupp.sum_fintype ] using hc.symm ⟩;
  obtain ⟨ c, rfl ⟩ := h_basis; simp +decide [ opComm ] ;
  simp +decide [ Fin.sum_univ_eight, T13_op_omega, T13_op_v1, T13_op_v2, T13_op_v3, T13_op_v4, T13_op_v5, T13_op_v6, T13_op_nu, Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu ];
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ];
  simp +decide [ T13_op_omega, T13_op_v1, T13_op_v2, T13_op_v3, T13_op_v4, T13_op_v5, T13_op_v6, T13_op_nu, Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu ]

/-
`Q_op` commutes with `T31_op` on `J`.
-/
theorem charge_conservation_T31 :
    EqOnJ (opComm Q_op T31_op) 0 := by
  unfold EqOnJ opComm;
  -- By definition of $J$, we know that every element in $J$ can be written as a linear combination of the basis states.
  intro x hx
  obtain ⟨c, hc⟩ : ∃ c : Fin 8 → ℂ, x = ∑ i, c i • basisState i := by
    have := Submodule.mem_span_range_iff_exists_fun ℂ |>.1 hx;
    tauto;
  simp +decide [ hc, Fin.sum_univ_eight ];
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ];
  simp +decide [ T31_op_omega, T31_op_v1, T31_op_v2, T31_op_v3, T31_op_v4, T31_op_v5, T31_op_v6, T31_op_nu, Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu ]

/-
`Q_op` commutes with `T23_op` on `J`.
-/
theorem charge_conservation_T23 :
    EqOnJ (opComm Q_op T23_op) 0 := by
  intro x hx;
  -- By definition of $J$, we can write $x$ as a linear combination of the basis elements.
  obtain ⟨c, hc⟩ : ∃ c : Fin 8 → ℂ, x = ∑ i, c i • basisState i := by
    obtain ⟨ c, hc ⟩ := Finsupp.mem_span_range_iff_exists_finsupp.mp hx;
    exact ⟨ c, by simpa [ Finsupp.sum_fintype ] using hc.symm ⟩;
  unfold opComm; simp_all +decide [ Fin.sum_univ_eight ] ;
  simp +decide [ show basisState 0 = omega from rfl, show basisState 1 = v1 from rfl, show basisState 2 = v2 from rfl, show basisState 3 = v3 from rfl, show basisState 4 = v4 from rfl, show basisState 5 = v5 from rfl, show basisState 6 = v6 from rfl, show basisState 7 = nu from rfl ] at *;
  simp +decide [ T23_op_omega, T23_op_v1, T23_op_v2, T23_op_v3, T23_op_v4, T23_op_v5, T23_op_v6, T23_op_nu, Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu ]

/-
`Q_op` commutes with `T32_op` on `J`.
-/
theorem charge_conservation_T32 :
    EqOnJ (opComm Q_op T32_op) 0 := by
  -- By definition of commutator, we have:
  unfold EqOnJ;
  unfold opComm;
  unfold J;
  intro x hx;
  rw [ Submodule.mem_span_range_iff_exists_fun ] at hx;
  obtain ⟨ c, rfl ⟩ := hx;
  simp +decide [ Fin.sum_univ_eight, basisState ];
  simp +decide [ Q_omega, Q_v1, Q_v2, Q_v3, Q_v4, Q_v5, Q_v6, Q_nu, T32_op_omega, T32_op_v1, T32_op_v2, T32_op_v3, T32_op_v4, T32_op_v5, T32_op_v6, T32_op_nu ]

/-!
## Phase 5: Invariant Subspaces

We define the four physical sectors as submodules of `ComplexOctonion` and
prove that the color operators preserve or annihilate each sector.
-/

/-- The singlet subspace spanned by the vacuum/idempotent `omega`. -/
noncomputable def J_singlet_low : Submodule Complex ComplexOctonion :=
  Submodule.span Complex {omega}

/-- The anti-up color triplet subspace spanned by `v1`, `v2`, `v3`. -/
noncomputable def J_up_color : Submodule Complex ComplexOctonion :=
  Submodule.span Complex {v1, v2, v3}

/-- The anti-down color triplet subspace spanned by `v4`, `v5`, `v6`. -/
noncomputable def J_down_color : Submodule Complex ComplexOctonion :=
  Submodule.span Complex {v4, v5, v6}

/-- The singlet subspace spanned by the neutrino state `nu`. -/
noncomputable def J_singlet_high : Submodule Complex ComplexOctonion :=
  Submodule.span Complex {nu}

/-- All color operators annihilate `omega`. -/
theorem color_ops_annihilate_omega :
    T12_op omega = 0 ∧ T21_op omega = 0 ∧
    T13_op omega = 0 ∧ T31_op omega = 0 ∧
    T23_op omega = 0 ∧ T32_op omega = 0 :=
  ⟨T12_op_omega, T21_op_omega, T13_op_omega,
   T31_op_omega, T23_op_omega, T32_op_omega⟩

/-- All color operators annihilate `nu`. -/
theorem color_ops_annihilate_nu :
    T12_op nu = 0 ∧ T21_op nu = 0 ∧
    T13_op nu = 0 ∧ T31_op nu = 0 ∧
    T23_op nu = 0 ∧ T32_op nu = 0 :=
  ⟨T12_op_nu, T21_op_nu, T13_op_nu,
   T31_op_nu, T23_op_nu, T32_op_nu⟩

/-
`T12_op` preserves the anti-up color triplet: it maps elements of
    `J_up_color` back into `J_up_color`.
-/
theorem T12_op_preserves_up_color (x : ComplexOctonion) (hx : x ∈ J_up_color) :
    T12_op x ∈ J_up_color := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · simp +decide [ J_up_color ];
    simp +decide [ T12_op_v1, T12_op_v2, T12_op_v3, Submodule.mem_span_insert, Submodule.mem_span_singleton ];
    exact ⟨ 1, 0, 0, by norm_num ⟩;
  · simp +decide [ J_up_color ];
  · simp +contextual [ map_add, J_up_color ];
    exact fun x y hx hy hx' hy' => Submodule.add_mem _ hx' hy';
  · intro a x hx hx'; simp_all +decide [ T12_op ] ;
    exact Submodule.smul_mem _ _ hx'

/-
`T21_op` preserves the anti-up color triplet.
-/
theorem T21_op_preserves_up_color (x : ComplexOctonion) (hx : x ∈ J_up_color) :
    T21_op x ∈ J_up_color := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · -- For each element in {v1, v2, v3}, we can verify that T21_op applied to it is in the span of {v1, v2, v3}.
    simp [T21_op_v1, T21_op_v2, T21_op_v3];
    exact Submodule.subset_span ( by simp +decide );
  · simp +decide;
  · exact fun x y hx hy hx' hy' => by simpa using Submodule.add_mem _ hx' hy';
  · simp_all +decide [ Submodule.smul_mem ]

/-
`T13_op` preserves the anti-up color triplet.
-/
theorem T13_op_preserves_up_color (x : ComplexOctonion) (hx : x ∈ J_up_color) :
    T13_op x ∈ J_up_color := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · simp +zetaDelta at *;
    exact ⟨ by rw [ T13_op_v1 ] ; exact Submodule.zero_mem _, by rw [ T13_op_v2 ] ; exact Submodule.zero_mem _, by rw [ T13_op_v3 ] ; exact Submodule.subset_span ( by norm_num ) ⟩;
  · unfold T13_op; aesop;
  · simp +zetaDelta at *;
    exact fun x y hx hy hx' hy' => Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => by simpa [ T13_op ] using Submodule.smul_mem _ a hx';

/-
`T31_op` preserves the anti-up color triplet.
-/
theorem T31_op_preserves_up_color (x : ComplexOctonion) (hx : x ∈ J_up_color) :
    T31_op x ∈ J_up_color := by
  induction hx using Submodule.span_induction <;> simp_all +decide [ J_up_color ];
  · rcases ‹_› with ( rfl | rfl | rfl ) <;> simp +decide [ *, Submodule.mem_span_insert, Submodule.mem_span_singleton ];
    · exact ⟨ 0, 0, 1, by simp +decide [ T31_op_v1 ] ⟩;
    · exact ⟨ 0, 0, 0, by simp +decide [ T31_op_v2 ] ⟩;
    · exact ⟨ 0, 0, 0, by simp +decide [ T31_op_v3 ] ⟩;
  · exact Submodule.add_mem _ ‹_› ‹_›;
  · exact Submodule.smul_mem _ _ ‹_›

/-
`T23_op` preserves the anti-up color triplet.
-/
theorem T23_op_preserves_up_color (x : ComplexOctonion) (hx : x ∈ J_up_color) :
    T23_op x ∈ J_up_color := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · simp +zetaDelta at *;
    exact ⟨ by rw [ T23_op_v1 ] ; exact Submodule.zero_mem _, by rw [ T23_op_v2 ] ; exact Submodule.zero_mem _, by rw [ T23_op_v3 ] ; exact Submodule.subset_span ( by simp +decide ) ⟩;
  · simp +decide;
  · simp +decide [ map_add ];
    exact fun x y hx hy hx' hy' => Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => by simpa [ T23_op ] using Submodule.smul_mem _ a hx';

/-
`T32_op` preserves the anti-up color triplet.
-/
theorem T32_op_preserves_up_color (x : ComplexOctonion) (hx : x ∈ J_up_color) :
    T32_op x ∈ J_up_color := by
  have h_span : ∀ x : ComplexOctonion, x ∈ J_up_color → T32_op x ∈ Submodule.span Complex {v1, v2, v3} := by
    intro x hx
    induction' hx using Submodule.span_induction with x hx ih;
    · rcases hx with ( rfl | rfl | rfl ) <;> norm_num [ T32_op_v1, T32_op_v2, T32_op_v3 ];
      exact Submodule.subset_span ( by norm_num );
    · simp +decide [ T32_op ];
    · aesop;
    · aesop;
  exact h_span x hx

/-
`T12_op` preserves the anti-down color triplet.
-/
theorem T12_op_preserves_down_color (x : ComplexOctonion) (hx : x ∈ J_down_color) :
    T12_op x ∈ J_down_color := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · simp +decide [ J_down_color ];
    simp +decide [ T12_op_v4, T12_op_v5, T12_op_v6, Submodule.mem_span_insert, Submodule.mem_span_singleton ];
    exact ⟨ 0, 1, 0, by norm_num ⟩;
  · simp +decide [ J_down_color ];
  · simp +zetaDelta at *;
    exact fun x y hx hy hx' hy' => Submodule.add_mem _ hx' hy';
  · exact fun a x hx₁ hx₂ => by simpa [ LinearMap.map_smul ] using Submodule.smul_mem _ a hx₂;

/-
`T21_op` preserves the anti-down color triplet.
-/
theorem T21_op_preserves_down_color (x : ComplexOctonion) (hx : x ∈ J_down_color) :
    T21_op x ∈ J_down_color := by
  refine' Submodule.span_induction _ _ _ _ hx <;> norm_num [ T21_op_v1, T21_op_v2, T21_op_v4, T21_op_v5, T21_op_v6 ];
  · exact Submodule.subset_span ( by simp +decide );
  · exact fun x y hx hy hx' hy' => Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => Submodule.smul_mem _ _ hx'

/-
`T13_op` preserves the anti-down color triplet.
-/
theorem T13_op_preserves_down_color (x : ComplexOctonion) (hx : x ∈ J_down_color) :
    T13_op x ∈ J_down_color := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · simp +decide [ J_down_color ];
    simp +decide [ T13_op_v4, T13_op_v5, T13_op_v6, Submodule.mem_span_insert, Submodule.mem_span_singleton ];
    exact ⟨ 1, 0, 0, by norm_num ⟩;
  · simp +decide;
  · simp +decide [ map_add ];
    exact fun x y hx hy hx' hy' => Submodule.add_mem _ hx' hy';
  · intro a x hx hx'; simp_all +decide [ J_down_color ] ;
    exact Submodule.smul_mem _ _ hx'

/-
`T31_op` preserves the anti-down color triplet.
-/
theorem T31_op_preserves_down_color (x : ComplexOctonion) (hx : x ∈ J_down_color) :
    T31_op x ∈ J_down_color := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · simp +decide [ J_down_color, Submodule.mem_span_insert, Submodule.mem_span_singleton ];
    refine' ⟨ ⟨ 0, 0, -1, _ ⟩, ⟨ 0, 0, 0, _ ⟩, ⟨ 0, 0, 0, _ ⟩ ⟩;
    · convert T31_op_v4 using 1;
      norm_num [ ComplexOctonion.ext_iff ];
    · simp +decide [ T31_op_v5 ];
    · simp +decide [ T31_op_v6 ];
  · simp +decide;
  · exact fun x y hx hy hx' hy' => by simpa using Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => by simpa [ T31_op ] using Submodule.smul_mem _ a hx';

/-
`T23_op` preserves the anti-down color triplet.
-/
theorem T23_op_preserves_down_color (x : ComplexOctonion) (hx : x ∈ J_down_color) :
    T23_op x ∈ J_down_color := by
  refine' Submodule.span_induction _ _ _ _ hx <;> simp_all +decide [ J_down_color ];
  · simp +decide [ T23_op_v4, T23_op_v5, T23_op_v6, Submodule.mem_span_insert, Submodule.mem_span_singleton ];
    exact ⟨ 1, 0, 0, by norm_num ⟩;
  · exact fun x y hx hy hx' hy' => Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => Submodule.smul_mem _ _ hx'

/-
`T32_op` preserves the anti-down color triplet.
-/
theorem T32_op_preserves_down_color (x : ComplexOctonion) (hx : x ∈ J_down_color) :
    T32_op x ∈ J_down_color := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · simp +decide [ J_down_color ];
    simp +decide [ T32_op_v4, T32_op_v5, T32_op_v6, Submodule.mem_span_insert, Submodule.mem_span_singleton ];
    exact ⟨ 0, 1, 0, by norm_num ⟩;
  · aesop;
  · simp +decide [ mul_add, left_mul_add ];
    exact fun x y hx hy hx' hy' => Submodule.add_mem _ hx' hy';
  · exact fun a x hx hx' => by simpa [ T32_op ] using Submodule.smul_mem _ a hx';

/-
`Q_op` acts as scalar `(-1 : Complex)` on `J_singlet_low`.
-/
theorem Q_op_scalar_on_singlet_low (x : ComplexOctonion) (hx : x ∈ J_singlet_low) :
    Q_op x = (-1 : Complex) • x := by
  -- By definition of J_singlet_low, we know that x can be written as a scalar multiple of omega.
  obtain ⟨c, hc⟩ : ∃ c : ℂ, x = c • omega := by
    exact Exists.elim ( Submodule.mem_span_singleton.mp hx ) fun c hc => ⟨ c, hc.symm ⟩;
  simp +decide [ hc, Q_omega ]

/-
`Q_op` acts as scalar `(-2/3 : Complex)` on `J_up_color`.
-/
theorem Q_op_scalar_on_up_color (x : ComplexOctonion) (hx : x ∈ J_up_color) :
    Q_op x = (-2 / 3 : Complex) • x := by
  refine' Submodule.span_induction _ _ _ _ hx;
  · rintro x ( rfl | rfl | rfl ) <;> norm_num [ Q_v1, Q_v2, Q_v3 ];
  · norm_num [ Q_op ];
  · simp +contextual [ *, smul_add ];
  · intro a x hx hx'; simp +decide [ hx', smul_smul, mul_comm ] ;

/-
`Q_op` acts as scalar `(-1/3 : Complex)` on `J_down_color`.
-/
theorem Q_op_scalar_on_down_color (x : ComplexOctonion) (hx : x ∈ J_down_color) :
    Q_op x = (-1 / 3 : Complex) • x := by
  unfold J_down_color at hx; simp_all +decide [ Submodule.mem_span_insert, Submodule.mem_span_singleton ] ;
  obtain ⟨ a, b, c, rfl ⟩ := hx; norm_num [ Q_v4, Q_v5, Q_v6 ] ;
  module

/-
`Q_op` acts as scalar `0` on `J_singlet_high`.
-/
theorem Q_op_scalar_on_singlet_high (x : ComplexOctonion) (hx : x ∈ J_singlet_high) :
    Q_op x = (0 : Complex) • x := by
  -- Since x is in the span of nu, we can write x as a scalar multiple of nu.
  obtain ⟨c, hc⟩ : ∃ c : Complex, x = c • nu := by
    exact Submodule.mem_span_singleton.mp hx |> Exists.imp fun c hc => hc.symm;
  rw [ hc, map_smul, Q_nu ] ; norm_num

end PhysicsSM.Algebra.Furey.MinimalLeftIdeal
