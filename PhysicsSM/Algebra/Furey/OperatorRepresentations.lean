import Mathlib.LinearAlgebra.Basis.Submodule
import PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-!
# Algebra.Furey.OperatorRepresentations

This module packages the Furey minimal-left-ideal arithmetic from
`PhysicsSM.Algebra.Furey.MinimalLeftIdeal` as explicit complex-linear
operators.

The important mathematical point is the same one emphasized in the task files
and in the Aristotle results integrated here: `ComplexOctonion` is
non-associative.  A product such as `(alpha1 * alpha2_dag) * x` is therefore
not the same thing as the operator composition
`alpha1 * (alpha2_dag * x)`.  The latter is the object that appears in the
left-multiplication algebra used by Furey's construction.

The declarations below intentionally keep the operator layer separate from the
raw algebra-element layer in `MinimalLeftIdeal.lean`:

* `Lmul a` is the complex-linear map `x |-> a * x`.
* `J` is the complex span of the eight kernel-checked basis states.
* `T12_op`, ..., `T32_op` are color-changing operator compositions.
* `N1_op`, `N2_op`, `N3_op` are number-operator compositions.
* `Q_op` is the charge operator `(-1/3) * (N1 + N2 + N3)`.

Aristotle result `0bcaa9b0-9a92-48e0-a3a3-30969e8742aa` called the last
operator `Y_op` and described it as hypercharge.  During review we keep the
formal formula but rename the integrated operator to `Q_op`: the eigenvalues
proved here are exactly the electric-charge values already documented in
`MinimalLeftIdeal.lean`, not the conventional Standard Model weak
hypercharges.

Source: Furey, arXiv:1806.00612, together with Aristotle jobs
`0bcaa9b0-9a92-48e0-a3a3-30969e8742aa` and
`38b00d57-1e6d-4ace-aefc-d4e147739b4a`.
Provenance: clean-room integration of Aristotle output, reviewed against the
existing finite-coordinate theorems in `MinimalLeftIdeal.lean`.
-/

namespace PhysicsSM.Algebra.Furey.MinimalLeftIdeal

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Furey.LadderOperators

/-!
## Left multiplication as a linear map

Every operator in this file is built from individual left-multiplication maps.
This keeps the non-associative parenthesization visible:

`(Lmul a).comp (Lmul b)` means `x |-> a * (b * x)`.

It does not mean `x |-> (a * b) * x`.
-/

/-- Left multiplication distributes over addition in the right argument. -/
theorem left_mul_add (a x y : ComplexOctonion) :
    a * (x + y) = a * x + a * y := by
  ext <;> simp <;> ring

/--
Left multiplication commutes with the complex scalar action in the right
argument.  This is a coordinate theorem for the concrete complexified
octonions; it should not be read as an associativity theorem for octonion
multiplication.
-/
theorem left_mul_smul (a : ComplexOctonion) (z : Complex) (x : ComplexOctonion) :
    a * (z • x) = z • (a * x) := by
  ext <;> simp <;> ring

/-- Left multiplication by zero on the right gives zero. -/
@[simp] theorem mul_zero_right (a : ComplexOctonion) :
    a * (0 : ComplexOctonion) = 0 := by
  ext <;> simp

/-- Zero left-multiplies every element to zero. -/
@[simp] theorem zero_mul_left (a : ComplexOctonion) :
    (0 : ComplexOctonion) * a = 0 := by
  ext <;> simp

/-- Left multiplication distributes over negation in the right argument. -/
@[simp] theorem left_mul_neg (a x : ComplexOctonion) : a * (-x) = -(a * x) := by
  ext <;> simp <;> ring

/--
The left-multiplication operator associated to a complexified octonion.

The codomain is the associative algebra of complex-linear endomorphisms, but
the map `a |-> Lmul a` is not asserted to be an algebra homomorphism.  In
particular, this file deliberately avoids any theorem of the shape
`Lmul (a * b) = (Lmul a).comp (Lmul b)`, because that would be false for a
non-associative product in general.
-/
noncomputable def Lmul (a : ComplexOctonion) :
    ComplexOctonion →ₗ[Complex] ComplexOctonion where
  toFun x := a * x
  map_add' := left_mul_add a
  map_smul' := left_mul_smul a

@[simp] theorem Lmul_apply (a x : ComplexOctonion) : Lmul a x = a * x := rfl

/-!
## The eight-state submodule

`basisState` gives a stable order for the eight states.  This order matches the
previous Aristotle linear-independence theorem:

`omega, v1, v2, v3, v4, v5, v6, nu`.
-/

/-- The eight basis states of the Furey minimal left ideal, in a fixed order. -/
noncomputable def basisState : Fin 8 → ComplexOctonion
  | 0 => omega
  | 1 => v1
  | 2 => v2
  | 3 => v3
  | 4 => v4
  | 5 => v5
  | 6 => v6
  | 7 => nu

/-- The minimal left ideal carrier used in this formalization: the span of the
eight verified basis states. -/
noncomputable def J : Submodule Complex ComplexOctonion :=
  Submodule.span Complex (Set.range basisState)

/-- The `basisState` indexing function is linearly independent. -/
theorem basisState_linearIndependent :
    LinearIndependent Complex basisState :=
  basis_linear_independent

/--
The eight-state basis for `J`.

This is a basis of the span, not yet a theorem that the span coincides with an
externally defined ideal such as `(ComplexOctonion) * omega`.  That stronger
ideal-identification theorem is a later algebraic target.
-/
noncomputable def J_basis : Module.Basis (Fin 8) Complex J :=
  Module.Basis.span basisState_linearIndependent

/-!
## Clifford relations on the span `J`

The raw ladder operators already have a finite action table in
`MinimalLeftIdeal.lean`.  The theorems in this section lift that table to
operator identities on every vector in `J`.

The proof pattern is intentionally explicit:

1. prove the identity on each of the eight spanning states by case-splitting on
   `Fin 8`;
2. extend it across finite linear combinations with `Submodule.span_induction`;
3. use only linearity of the operator compositions, not associativity of the
   octonion product.
-/

/--
If a linear operator agrees with the identity on the eight spanning states, it
agrees with the identity on all of `J`.

The auxiliary membership argument is intentionally visible: `J` is just a name
for `Submodule.span Complex (Set.range basisState)`, so span induction is the
right tool.  The proof uses linearity of `A`, not any associativity property of
`ComplexOctonion`.
-/
private theorem linearMap_eq_on_J_of_basis
    (A : ComplexOctonion →ₗ[Complex] ComplexOctonion)
    (hA : ∀ i : Fin 8, A (basisState i) = basisState i)
    (x : ComplexOctonion) (hx : x ∈ J) : A x = x := by
  change x ∈ Submodule.span Complex (Set.range basisState) at hx
  refine Submodule.span_induction
    (p := fun x _ => A x = x) ?mem ?zero ?add ?smul hx
  · rintro y ⟨i, rfl⟩
    exact hA i
  · simp
  · intro x y hx hy hAx hAy
    rw [A.map_add, hAx, hAy]
  · intro a x hx hAx
    rw [A.map_smul, hAx]

/--
If a linear operator vanishes on the eight spanning states, it vanishes on all
of `J`.  This is the zero-operator analogue of
`linearMap_eq_on_J_of_basis`.
-/
private theorem linearMap_zero_on_J_of_basis
    (A : ComplexOctonion →ₗ[Complex] ComplexOctonion)
    (hA : ∀ i : Fin 8, A (basisState i) = 0)
    (x : ComplexOctonion) (hx : x ∈ J) : A x = 0 := by
  change x ∈ Submodule.span Complex (Set.range basisState) at hx
  refine Submodule.span_induction
    (p := fun x _ => A x = 0) ?mem ?zero ?add ?smul hx
  · rintro y ⟨i, rfl⟩
    exact hA i
  · simp
  · intro x y hx hy hAx hAy
    rw [A.map_add, hAx, hAy]
    simp
  · intro a x hx hAx
    rw [A.map_smul, hAx]
    simp

/-- The first diagonal Clifford anticommutator acts as the identity on `J`. -/
theorem clifford_diag_1 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha1).comp (Lmul alpha1_dag) +
      (Lmul alpha1_dag).comp (Lmul alpha1)) x = x := by
  refine linearMap_eq_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a1_omega, act_a1_v1, act_a1_v2, act_a1_v3,
      act_a1_v4, act_a1_v5, act_a1_v6, act_a1_nu, act_a1d_omega,
      act_a1d_v1, act_a1d_v2, act_a1d_v3, act_a1d_v4, act_a1d_v5,
      act_a1d_v6, act_a1d_nu]

/-- The second diagonal Clifford anticommutator acts as the identity on `J`. -/
theorem clifford_diag_2 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha2).comp (Lmul alpha2_dag) +
      (Lmul alpha2_dag).comp (Lmul alpha2)) x = x := by
  refine linearMap_eq_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a2_omega, act_a2_v1, act_a2_v2, act_a2_v3,
      act_a2_v4, act_a2_v5, act_a2_v6, act_a2_nu, act_a2d_omega,
      act_a2d_v1, act_a2d_v2, act_a2d_v3, act_a2d_v4, act_a2d_v5,
      act_a2d_v6, act_a2d_nu]

/-- The third diagonal Clifford anticommutator acts as the identity on `J`. -/
theorem clifford_diag_3 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha3).comp (Lmul alpha3_dag) +
      (Lmul alpha3_dag).comp (Lmul alpha3)) x = x := by
  refine linearMap_eq_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a3_omega, act_a3_v1, act_a3_v2, act_a3_v3,
      act_a3_v4, act_a3_v5, act_a3_v6, act_a3_nu, act_a3d_omega,
      act_a3d_v1, act_a3d_v2, act_a3d_v3, act_a3d_v4, act_a3d_v5,
      act_a3d_v6, act_a3d_nu]

/-- The `(1,2)` off-diagonal Clifford anticommutator vanishes on `J`. -/
theorem clifford_off_12 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha1).comp (Lmul alpha2_dag) +
      (Lmul alpha2_dag).comp (Lmul alpha1)) x = 0 := by
  refine linearMap_zero_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a1_omega, act_a1_v1, act_a1_v2, act_a1_v3,
      act_a1_v4, act_a1_v5, act_a1_v6, act_a1_nu, act_a2d_omega,
      act_a2d_v1, act_a2d_v2, act_a2d_v3, act_a2d_v4, act_a2d_v5,
      act_a2d_v6, act_a2d_nu]

/-- The `(2,1)` off-diagonal Clifford anticommutator vanishes on `J`. -/
theorem clifford_off_21 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha2).comp (Lmul alpha1_dag) +
      (Lmul alpha1_dag).comp (Lmul alpha2)) x = 0 := by
  refine linearMap_zero_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a2_omega, act_a2_v1, act_a2_v2, act_a2_v3,
      act_a2_v4, act_a2_v5, act_a2_v6, act_a2_nu, act_a1d_omega,
      act_a1d_v1, act_a1d_v2, act_a1d_v3, act_a1d_v4, act_a1d_v5,
      act_a1d_v6, act_a1d_nu]

/-- The `(1,3)` off-diagonal Clifford anticommutator vanishes on `J`. -/
theorem clifford_off_13 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha1).comp (Lmul alpha3_dag) +
      (Lmul alpha3_dag).comp (Lmul alpha1)) x = 0 := by
  refine linearMap_zero_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a1_omega, act_a1_v1, act_a1_v2, act_a1_v3,
      act_a1_v4, act_a1_v5, act_a1_v6, act_a1_nu, act_a3d_omega,
      act_a3d_v1, act_a3d_v2, act_a3d_v3, act_a3d_v4, act_a3d_v5,
      act_a3d_v6, act_a3d_nu]

/-- The `(3,1)` off-diagonal Clifford anticommutator vanishes on `J`. -/
theorem clifford_off_31 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha3).comp (Lmul alpha1_dag) +
      (Lmul alpha1_dag).comp (Lmul alpha3)) x = 0 := by
  refine linearMap_zero_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a3_omega, act_a3_v1, act_a3_v2, act_a3_v3,
      act_a3_v4, act_a3_v5, act_a3_v6, act_a3_nu, act_a1d_omega,
      act_a1d_v1, act_a1d_v2, act_a1d_v3, act_a1d_v4, act_a1d_v5,
      act_a1d_v6, act_a1d_nu]

/-- The `(2,3)` off-diagonal Clifford anticommutator vanishes on `J`. -/
theorem clifford_off_23 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha2).comp (Lmul alpha3_dag) +
      (Lmul alpha3_dag).comp (Lmul alpha2)) x = 0 := by
  refine linearMap_zero_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a2_omega, act_a2_v1, act_a2_v2, act_a2_v3,
      act_a2_v4, act_a2_v5, act_a2_v6, act_a2_nu, act_a3d_omega,
      act_a3d_v1, act_a3d_v2, act_a3d_v3, act_a3d_v4, act_a3d_v5,
      act_a3d_v6, act_a3d_nu]

/-- The `(3,2)` off-diagonal Clifford anticommutator vanishes on `J`. -/
theorem clifford_off_32 (x : ComplexOctonion) (hx : x ∈ J) :
    ((Lmul alpha3).comp (Lmul alpha2_dag) +
      (Lmul alpha2_dag).comp (Lmul alpha3)) x = 0 := by
  refine linearMap_zero_on_J_of_basis _ ?_ x hx
  intro i
  fin_cases i <;>
    simp [basisState, act_a3_omega, act_a3_v1, act_a3_v2, act_a3_v3,
      act_a3_v4, act_a3_v5, act_a3_v6, act_a3_nu, act_a2d_omega,
      act_a2d_v1, act_a2d_v2, act_a2d_v3, act_a2d_v4, act_a2d_v5,
      act_a2d_v6, act_a2d_nu]

/-!
## Color-changing operator compositions

The six `Tij_op` maps are the off-diagonal color-changing operators from the
left-multiplication algebra.  Their definitions use operator composition, so
for example `T12_op x` unfolds to `alpha1 * (alpha2_dag * x)`.
-/

/-- Operator taking color 2 to color 1 on the anti-up triplet. -/
noncomputable def T12_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha1).comp (Lmul alpha2_dag)

/-- Operator taking color 1 to color 2 on the anti-up triplet. -/
noncomputable def T21_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha2).comp (Lmul alpha1_dag)

/-- Operator taking color 3 to color 1 on the anti-up triplet. -/
noncomputable def T13_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha1).comp (Lmul alpha3_dag)

/-- Operator taking color 1 to color 3 on the anti-up triplet. -/
noncomputable def T31_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha3).comp (Lmul alpha1_dag)

/-- Operator taking color 3 to color 2 on the anti-up triplet. -/
noncomputable def T23_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha2).comp (Lmul alpha3_dag)

/-- Operator taking color 2 to color 3 on the anti-up triplet. -/
noncomputable def T32_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha3).comp (Lmul alpha2_dag)

/-- `T12_op` maps the second anti-up color state to the first. -/
theorem T12_op_v2 : T12_op v2 = v1 := by
  simp [T12_op, act_a2d_v2, act_a1_omega]

/-- `T12_op` annihilates the first anti-up color state. -/
theorem T12_op_v1 : T12_op v1 = 0 := by
  simp [T12_op, act_a2d_v1]

/-- `T12_op` annihilates the third anti-up color state. -/
theorem T12_op_v3 : T12_op v3 = 0 := by
  simp [T12_op, act_a2d_v3]

/-- `T12_op` annihilates the vacuum/idempotent state. -/
theorem T12_op_omega : T12_op omega = 0 := by
  simp [T12_op, act_a2d_omega]

/-- `T12_op` annihilates the top state `nu`. -/
theorem T12_op_nu : T12_op nu = 0 := by
  simp [T12_op, act_a2d_nu, act_a1_v5]

/-- `T21_op` maps the first anti-up color state to the second. -/
theorem T21_op_v1 : T21_op v1 = v2 := by
  simp [T21_op, act_a1d_v1, act_a2_omega]

/-- `T21_op` annihilates the second anti-up color state. -/
theorem T21_op_v2 : T21_op v2 = 0 := by
  simp [T21_op, act_a1d_v2]

/-- `T13_op` maps the third anti-up color state to the first. -/
theorem T13_op_v3 : T13_op v3 = v1 := by
  simp [T13_op, act_a3d_v3, act_a1_omega]

/-- `T13_op` annihilates the first anti-up color state. -/
theorem T13_op_v1 : T13_op v1 = 0 := by
  simp [T13_op, act_a3d_v1]

/-- `T31_op` maps the first anti-up color state to the third. -/
theorem T31_op_v1 : T31_op v1 = v3 := by
  simp [T31_op, act_a1d_v1, act_a3_omega]

/-- `T23_op` maps the third anti-up color state to the second. -/
theorem T23_op_v3 : T23_op v3 = v2 := by
  simp [T23_op, act_a3d_v3, act_a2_omega]

/-- `T23_op` annihilates the second anti-up color state. -/
theorem T23_op_v2 : T23_op v2 = 0 := by
  simp [T23_op, act_a3d_v2]

/-- `T32_op` maps the second anti-up color state to the third. -/
theorem T32_op_v2 : T32_op v2 = v3 := by
  simp [T32_op, act_a2d_v2, act_a3_omega]

/-!
## Number operators and electric charge

The number operators are again compositions:

`N1_op x = alpha1_dag * (alpha1 * x)`,

and similarly for modes 2 and 3.  The existing theorems `N1_omega`, ...,
`N3_nu` prove the coordinate-level action table.  The lemmas below repackage
that table as linear-map statements.
-/

/-- Number operator for mode 1. -/
noncomputable def N1_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha1_dag).comp (Lmul alpha1)

/-- Number operator for mode 2. -/
noncomputable def N2_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha2_dag).comp (Lmul alpha2)

/-- Number operator for mode 3. -/
noncomputable def N3_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (Lmul alpha3_dag).comp (Lmul alpha3)

theorem N1_op_omega : N1_op omega = omega := by
  simp [N1_op, N1_omega]
theorem N1_op_v1 : N1_op v1 = 0 := by
  simp [N1_op, N1_v1]
theorem N1_op_v2 : N1_op v2 = v2 := by
  simp [N1_op, N1_v2]
theorem N1_op_v3 : N1_op v3 = v3 := by
  simp [N1_op, N1_v3]
theorem N1_op_v4 : N1_op v4 = 0 := by
  simp [N1_op, N1_v4]
theorem N1_op_v5 : N1_op v5 = 0 := by
  simp [N1_op, N1_v5]
theorem N1_op_v6 : N1_op v6 = v6 := by
  simp [N1_op, N1_v6]
theorem N1_op_nu : N1_op nu = 0 := by
  simp [N1_op, N1_nu]

theorem N2_op_omega : N2_op omega = omega := by
  simp [N2_op, N2_omega]
theorem N2_op_v1 : N2_op v1 = v1 := by
  simp [N2_op, N2_v1]
theorem N2_op_v2 : N2_op v2 = 0 := by
  simp [N2_op, N2_v2]
theorem N2_op_v3 : N2_op v3 = v3 := by
  simp [N2_op, N2_v3]
theorem N2_op_v4 : N2_op v4 = 0 := by
  simp [N2_op, N2_v4]
theorem N2_op_v5 : N2_op v5 = v5 := by
  simp [N2_op, N2_v5]
theorem N2_op_v6 : N2_op v6 = 0 := by
  simp [N2_op, N2_v6]
theorem N2_op_nu : N2_op nu = 0 := by
  simp [N2_op, N2_nu]

theorem N3_op_omega : N3_op omega = omega := by
  simp [N3_op, N3_omega]
theorem N3_op_v1 : N3_op v1 = v1 := by
  simp [N3_op, N3_v1]
theorem N3_op_v2 : N3_op v2 = v2 := by
  simp [N3_op, N3_v2]
theorem N3_op_v3 : N3_op v3 = 0 := by
  simp [N3_op, N3_v3]
theorem N3_op_v4 : N3_op v4 = v4 := by
  simp [N3_op, N3_v4]
theorem N3_op_v5 : N3_op v5 = 0 := by
  simp [N3_op, N3_v5]
theorem N3_op_v6 : N3_op v6 = 0 := by
  simp [N3_op, N3_v6]
theorem N3_op_nu : N3_op nu = 0 := by
  simp [N3_op, N3_nu]

/-- Total occupation-number operator. -/
noncomputable def Ntot_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  N1_op + N2_op + N3_op

/--
Electric-charge operator in the convention already used by
`MinimalLeftIdeal.lean`.

Aristotle result `0bcaa9b0-9a92-48e0-a3a3-30969e8742aa` called this operator
`Y_op`.  The integrated name is `Q_op` because the eigenvalues below are the
electric charges recorded in the existing state comments.
-/
noncomputable def Q_op : ComplexOctonion →ₗ[Complex] ComplexOctonion :=
  (-1 / 3 : Complex) • Ntot_op

theorem Ntot_op_omega : Ntot_op omega = (3 : Complex) • omega := by
  simp [Ntot_op, N1_op_omega, N2_op_omega, N3_op_omega]
  ext <;> simp [omega] <;> ring

theorem Ntot_op_v1 : Ntot_op v1 = (2 : Complex) • v1 := by
  simp [Ntot_op, N1_op_v1, N2_op_v1, N3_op_v1]
  ext <;> simp [v1] <;> ring

theorem Ntot_op_v2 : Ntot_op v2 = (2 : Complex) • v2 := by
  simp [Ntot_op, N1_op_v2, N2_op_v2, N3_op_v2]
  ext <;> simp [v2] <;> ring

theorem Ntot_op_v3 : Ntot_op v3 = (2 : Complex) • v3 := by
  simp [Ntot_op, N1_op_v3, N2_op_v3, N3_op_v3]
  ext <;> simp [v3] <;> ring

theorem Ntot_op_v4 : Ntot_op v4 = (1 : Complex) • v4 := by
  simp [Ntot_op, N1_op_v4, N2_op_v4, N3_op_v4]

theorem Ntot_op_v5 : Ntot_op v5 = (1 : Complex) • v5 := by
  simp [Ntot_op, N1_op_v5, N2_op_v5, N3_op_v5]

theorem Ntot_op_v6 : Ntot_op v6 = (1 : Complex) • v6 := by
  simp [Ntot_op, N1_op_v6, N2_op_v6, N3_op_v6]

theorem Ntot_op_nu : Ntot_op nu = (0 : Complex) • nu := by
  simp [Ntot_op, N1_op_nu, N2_op_nu, N3_op_nu]

theorem Q_omega : Q_op omega = (-1 : Complex) • omega := by
  simp [Q_op, Ntot_op_omega, smul_smul]

theorem Q_v1 : Q_op v1 = (-2 / 3 : Complex) • v1 := by
  simp [Q_op, Ntot_op_v1, smul_smul]
  norm_num

theorem Q_v2 : Q_op v2 = (-2 / 3 : Complex) • v2 := by
  simp [Q_op, Ntot_op_v2, smul_smul]
  norm_num

theorem Q_v3 : Q_op v3 = (-2 / 3 : Complex) • v3 := by
  simp [Q_op, Ntot_op_v3, smul_smul]
  norm_num

theorem Q_v4 : Q_op v4 = (-1 / 3 : Complex) • v4 := by
  simp [Q_op, Ntot_op_v4]

theorem Q_v5 : Q_op v5 = (-1 / 3 : Complex) • v5 := by
  simp [Q_op, Ntot_op_v5]

theorem Q_v6 : Q_op v6 = (-1 / 3 : Complex) • v6 := by
  simp [Q_op, Ntot_op_v6]

theorem Q_nu : Q_op nu = (0 : Complex) • nu := by
  simp [Q_op, Ntot_op_nu]

end PhysicsSM.Algebra.Furey.MinimalLeftIdeal
