import Mathlib

/-!
# Weak isospin su(2)_L from two fermionic ladder modes (Furey eq. 42)

Standalone Aristotle package (Mathlib-only). SM-branch foundation S2b (first
brick), 2026-07-17. Formalizes the ABSTRACT core of Furey's electroweak
construction (arXiv:1806.00612, EPJC 78 (2018) 375, eq. 42): the weak-isospin
su(2)_L generators are built from two anticommuting fermionic ladder operators
`B_1, B_2` on the 2-mode Fock space (`Cl(4)`), and the singly-occupied states
form the weak-isospin doublet at `T_3 = +-1`.

Concretely, on the 4-dimensional Fock space with basis `|00>, |10>, |01>, |11>`
(occupation of modes 1, 2; Jordan-Wigner ordered), `B_1, B_2` are the
annihilation operators. Furey's generators (eq. 42, her normalization)

```text
T_3 = B_1^dagger B_1 - B_2^dagger B_2      (Cartan)
T_1 = B_1^dagger B_2 + B_2^dagger B_1
T_2 = i (B_2^dagger B_1 - B_1^dagger B_2)
```

with raising/lowering `T_+ = B_1^dagger B_2`, `T_- = B_2^dagger B_1`.

We prove: the canonical anticommutation relations; the su(2) algebra
`[T_1, T_2] = 2i T_3` (and cyclic); the ladder form
`[T_3, T_+] = 2 T_+`, `[T_3, T_-] = -2 T_-`, `[T_+, T_-] = T_3`; and that
`T_3` is diagonal with eigenvalues `(0, 1, -1, 0)` - the doublet `|10>, |01>`
sits at weak isospin `+-1/2` (half of `T_3`). All numerically verified.

This is the abstract `Cl(4)` operator algebra underlying su(2)_L; the
SM-specific realization uses `B_j = i e_7 | beta_j` from the quaternionic
`C(x)H` ladders (Furey eq. 37) and closes via the repo's `WeakIsospinLadderDerived`
uniqueness handle - a separate, downstream step. Clean-room formalization;
[comp] for the construction (standard second-quantized su(2) from two fermionic
modes / Furey eq. 42), [orig] for the formalization.

Integrated 2026-07-17 from Aristotle project
64e5ad32-6161-47be-a394-6e55d9edc3e3; all 11 theorems verbatim from the
submitted package, fully proven (0 placeholders), kernel EXIT 0, namespace
renamed for the draft tree, standard-three axiom guards added at integration.
S2b brick 1 (the abstract su(2)_L operator algebra); bricks 2-4 (C(x)H
chirality sector, chirality mechanism, octonionic realization + uniqueness
closure) are the downstream electroweak-derivation roadmap.

## Proof guidance

All matrices are explicit `4x4` complex `!![...]`; every identity is entrywise
finite. Use `ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply,
Fin.sum_univ_succ, comm, T1, T2, T3, TPlus, TMinus, B1, B2]` then `norm_num` /
`ring` on the complex entries (`Complex.ext_iff` where an entry is `i`-valued).
Adjoints are `Matrix.conjTranspose` of real `!![...]` matrices, i.e. the
transpose. Do not weaken any statement; do not use `native_decide`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2

open Matrix

/-- Mode-1 annihilation operator on the 2-mode Fock space
(basis `|00>, |10>, |01>, |11>`). -/
def B1 : Matrix (Fin 4) (Fin 4) ℂ := !![0, 1, 0, 0; 0, 0, 0, 0; 0, 0, 0, 1; 0, 0, 0, 0]

/-- Mode-2 annihilation operator (Jordan-Wigner sign from mode 1). -/
def B2 : Matrix (Fin 4) (Fin 4) ℂ := !![0, 0, 1, 0; 0, 0, 0, -1; 0, 0, 0, 0; 0, 0, 0, 0]

/-- Matrix commutator. -/
def comm (X Y : Matrix (Fin 4) (Fin 4) ℂ) : Matrix (Fin 4) (Fin 4) ℂ := X * Y - Y * X

/-- Weak-isospin Cartan `T_3 = B_1^dagger B_1 - B_2^dagger B_2`. -/
def T3 : Matrix (Fin 4) (Fin 4) ℂ := B1ᴴ * B1 - B2ᴴ * B2

/-- Weak-isospin raising `T_+ = B_1^dagger B_2`. -/
def TPlus : Matrix (Fin 4) (Fin 4) ℂ := B1ᴴ * B2

/-- Weak-isospin lowering `T_- = B_2^dagger B_1`. -/
def TMinus : Matrix (Fin 4) (Fin 4) ℂ := B2ᴴ * B1

/-- Furey `T_1 = B_1^dagger B_2 + B_2^dagger B_1`. -/
def T1 : Matrix (Fin 4) (Fin 4) ℂ := B1ᴴ * B2 + B2ᴴ * B1

/-- Furey `T_2 = i (B_2^dagger B_1 - B_1^dagger B_2)`. -/
def T2 : Matrix (Fin 4) (Fin 4) ℂ := Complex.I • (B2ᴴ * B1 - B1ᴴ * B2)

/-- **CAR (mode 1).** `{B_1, B_1^dagger} = 1`. -/
theorem car_B1 : B1 * B1ᴴ + B1ᴴ * B1 = 1 := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ B1, Matrix.mul_apply, Matrix.conjTranspose_apply ];
  all_goals simp +decide [Fin.sum_univ_succ, Matrix.vecMul, dotProduct]

/-- **CAR (mode 2).** `{B_2, B_2^dagger} = 1`. -/
theorem car_B2 : B2 * B2ᴴ + B2ᴴ * B2 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ, B2 ] ;
  all_goals simp +decide [ Matrix.vecHead, Matrix.vecTail, Matrix.vecMul ]

/-- **Ladders anticommute across modes.** `{B_1, B_2} = 0`. -/
theorem anticomm_B1_B2 : B1 * B2 + B2 * B1 = 0 := by
  simp [B1, B2];
  ext i j ; fin_cases i <;> fin_cases j <;> rfl

/-- **Nilpotency.** `B_1^2 = 0`. -/
theorem B1_sq : B1 * B1 = 0 := by
  simp [B1];
  ext i j ; fin_cases i <;> fin_cases j <;> rfl

/-- **su(2) algebra (Furey eq. 42).** `[T_1, T_2] = 2i T_3`. -/
theorem su2_T1_T2 : comm T1 T2 = (2 * Complex.I) • T3 := by
  ext i j;
  simp +decide [ T1, T2, T3, B1, B2, comm ];
  simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ];
  fin_cases i <;> fin_cases j <;> norm_num <;> ring

/-- **su(2) algebra (Furey eq. 42).** `[T_2, T_3] = 2i T_1`. -/
theorem su2_T2_T3 : comm T2 T3 = (2 * Complex.I) • T1 := by
  ext i j;
  simp +decide [ T2, T3, T1, B1, B2, Matrix.mul_apply, Fin.sum_univ_succ ];
  simp +decide [ Fin.sum_univ_succ, Matrix.mul_apply, comm ] at *;
  fin_cases i <;> fin_cases j <;> simp +decide [ Complex.ext_iff ]; all_goals norm_num

/-- **su(2) algebra (Furey eq. 42).** `[T_3, T_1] = 2i T_2`. -/
theorem su2_T3_T1 : comm T3 T1 = (2 * Complex.I) • T2 := by
  unfold comm T3 T1 T2 B1 B2 ;
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Fin.sum_univ_succ ] at *;
  norm_num [ Complex.ext_iff ]

/-- **Raising relation.** `[T_3, T_+] = 2 T_+`. -/
theorem ladder_T3_TPlus : comm T3 TPlus = (2 : ℂ) • TPlus := by
  ext i j; simp +decide [*];
  simp +decide [T3, TPlus, B1, B2, Matrix.mul_apply, comm];
  simp +decide [Fin.sum_univ_succ] at *;
  fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff ] at * ;

/-- **Lowering relation.** `[T_3, T_-] = -2 T_-`. -/
theorem ladder_T3_TMinus : comm T3 TMinus = (-2 : ℂ) • TMinus := by
  norm_num [ comm, Matrix.mul_apply, T3, TMinus, B1, B2 ];
  ext i j;
  fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ] ; ring!

/-- **Cartan from ladders.** `[T_+, T_-] = T_3`. -/
theorem ladder_TPlus_TMinus : comm TPlus TMinus = T3 := by
  ext i j;
  simp +decide [ TPlus, TMinus, T3, B1, B2, comm ];
  fin_cases i <;> fin_cases j <;> norm_num [ Fin.sum_univ_succ, Matrix.mul_apply ]

/-- **The weak-isospin doublet.** `T_3` is diagonal with eigenvalues
`(0, 1, -1, 0)`: the singly-occupied states `|10>, |01>` are the doublet at
`T_3 = +-1` (weak isospin `+-1/2`), the empty and full states are singlets. -/
theorem T3_eq_diagonal :
    T3 = !![0, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, 0] := by
  unfold T3;
  unfold B1 B2;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ]

end PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2


/-! ## Build-enforced assumption-footprint guards (added at integration) -/

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.car_B1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.car_B1

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.car_B2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.car_B2

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.anticomm_B1_B2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.anticomm_B1_B2

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.B1_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.B1_sq

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.su2_T1_T2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.su2_T1_T2

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.su2_T2_T3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.su2_T2_T3

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.su2_T3_T1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.su2_T3_T1

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.ladder_T3_TPlus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.ladder_T3_TPlus

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.ladder_T3_TMinus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.ladder_T3_TMinus

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.ladder_TPlus_TMinus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.ladder_TPlus_TMinus

/-- info: 'PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.T3_eq_diagonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2.T3_eq_diagonal

end
