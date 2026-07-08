import Mathlib

/-!
# Spectral mass-shell matching and Schur-complement local dilation

This file is fully self-contained and depends on `Mathlib` only.  It formalizes
two exact finite linear-algebra mechanisms that sit downstream of the
super-Dirac square in the dual-soldered null-strand programme.

## Part 1 — spectral mass-shell matching

We work in the **diagonal model** of two commuting diagonalizable self-adjoint
operators.  A diagonalizable operator is, in a suitable eigenbasis, a diagonal
matrix; we therefore present the geometric operator `K` and the internal squared
mass `M²` directly by their eigenvalue functions

* `K  : ι → 𝕜`    (eigenvalues of the geometric/kinetic operator),
* `M2 : κ → 𝕜`    (eigenvalues of the internal mass-squared operator).

The combined operator `K ⊗ I - I ⊗ M²` acts on the (model of the) tensor product
`ι × κ → 𝕜` as the diagonal operator `tensorDifference` with entry
`K i - M2 j` on the basis vector indexed by `(i, j)`.  Its kernel is exactly the
span of the basis vectors at *matching* eigenvalue pairs `K i = M2 j`, i.e. the
direct sum of the tensor products of the matching eigenspaces
(`matchingSupport`).  This is the precise "spectral locking" statement: physical
massive modes sit at the intersection of the geometric spectrum and the internal
spectrum.

The multiplicity of the zero mode (dimension of the kernel) equals the number of
matching pairs, which decomposes as the sum over coincident eigenvalues
`k = m²` of the products of the respective multiplicities.

## Part 2 — Schur-complement local dilation

For a `2 × 2` block operator `[[D_vis, B], [C, D_hid]]` with an invertible
hidden block `D_hid`, integrating out the hidden sheet produces the effective
visible operator `D_eff = D_vis - B D_hid⁻¹ C`, the **Schur complement**.  We
prove that solving the block linear system reduces to the Schur complement and
that the effective operator obtained by eliminating the hidden variable equals
the Schur complement.

(The pseudoinverse / non-invertible hidden block case is out of scope.)
-/

namespace PhysicsSM.NullStrand.DualSolder

/-! ## Part 1 — Spectral mass-shell matching (diagonal model) -/

section MassShell

variable {𝕜 : Type*} [Field 𝕜]
variable {ι κ : Type*} [Fintype ι] [Fintype κ] [DecidableEq ι] [DecidableEq κ]

/-- The diagonal operator modelling `K ⊗ I - I ⊗ M²` on the tensor product
`ι × κ → 𝕜`.  On the basis vector indexed by `(i, j)` it scales by the
eigenvalue difference `K i - M2 j`. -/
def tensorDifference (K : ι → 𝕜) (M2 : κ → 𝕜) :
    (ι × κ → 𝕜) →ₗ[𝕜] (ι × κ → 𝕜) where
  toFun x := fun p => (K p.1 - M2 p.2) * x p
  map_add' x y := by
    funext p; simp [mul_add]
  map_smul' c x := by
    funext p; simp [mul_left_comm]

omit [Fintype ι] [Fintype κ] [DecidableEq ι] [DecidableEq κ] in
@[simp]
lemma tensorDifference_apply (K : ι → 𝕜) (M2 : κ → 𝕜) (x : ι × κ → 𝕜)
    (p : ι × κ) : tensorDifference K M2 x p = (K p.1 - M2 p.2) * x p := rfl

/-- The "matching eigenspaces" subspace: vectors supported only on the basis
indices `(i, j)` with coincident eigenvalues `K i = M2 j`.  In the diagonal
model this is the direct sum over matching eigenvalue pairs of the tensor
products of the corresponding eigenspaces of `K` and `M²`. -/
def matchingSupport (K : ι → 𝕜) (M2 : κ → 𝕜) : Submodule 𝕜 (ι × κ → 𝕜) where
  carrier := {x | ∀ p, K p.1 ≠ M2 p.2 → x p = 0}
  add_mem' := by
    intro x y hx hy p hp; simp [hx p hp, hy p hp]
  zero_mem' := by
    intro p _; rfl
  smul_mem' := by
    intro c x hx p hp; simp [hx p hp]

omit [Fintype ι] [Fintype κ] [DecidableEq ι] [DecidableEq κ] in
@[simp]
lemma mem_matchingSupport {K : ι → 𝕜} {M2 : κ → 𝕜} {x : ι × κ → 𝕜} :
    x ∈ matchingSupport K M2 ↔ ∀ p, K p.1 ≠ M2 p.2 → x p = 0 := Iff.rfl

omit [Fintype ι] [Fintype κ] [DecidableEq ι] [DecidableEq κ] in
/-- **Mass-shell matching (kernel form).** The kernel of `K ⊗ I - I ⊗ M²` is
exactly the direct sum over matching eigenvalue pairs of the tensor products of
the eigenspaces — i.e. the subspace of vectors supported on the coincidence set
`{(i, j) | K i = M2 j}`. -/
theorem kernel_tensorDifference_eq_matchingEigenspaces (K : ι → 𝕜) (M2 : κ → 𝕜) :
    LinearMap.ker (tensorDifference K M2) = matchingSupport K M2 := by
  ext x
  simp only [LinearMap.mem_ker, mem_matchingSupport]
  constructor
  · intro hx p hp
    have hpp : (tensorDifference K M2 x) p = 0 := by rw [hx]; rfl
    rw [tensorDifference_apply] at hpp
    rcases mul_eq_zero.1 hpp with h | h
    · exact absurd (sub_eq_zero.1 h) hp
    · exact h
  · intro hx
    funext p
    rw [tensorDifference_apply]
    by_cases hp : K p.1 = M2 p.2
    · simp [hp]
    · simp [hx p hp]

omit [Field 𝕜] [DecidableEq ι] [DecidableEq κ] in
/-- **Mass-shell matching (multiplicity form).** The multiplicity of the zero
mode — the number of matching basis pairs — equals the sum, over the coincidences
`k = m²` of eigenvalues, of the products of the multiplicities of `k` in the
geometric spectrum `K` and of `m²` in the internal spectrum `M²`. -/
theorem massShellMultiplicity_eq_sum_matchingMultiplicities [DecidableEq 𝕜]
    (K : ι → 𝕜) (M2 : κ → 𝕜) :
    (Finset.univ.filter (fun p : ι × κ => K p.1 = M2 p.2)).card
      = ∑ v ∈ Finset.image K Finset.univ,
          (Finset.univ.filter (fun i => K i = v)).card
            * (Finset.univ.filter (fun j => M2 j = v)).card := by
  classical
  -- Count matching pairs by summing over the geometric index `i`.
  have hcount :
      (Finset.univ.filter (fun p : ι × κ => K p.1 = M2 p.2)).card
        = ∑ i : ι, (Finset.univ.filter (fun j => M2 j = K i)).card := by
    rw [Finset.card_filter, Fintype.sum_prod_type]
    refine Finset.sum_congr rfl ?_
    intro i _
    rw [Finset.card_filter]
    refine Finset.sum_congr rfl ?_
    intro j _
    by_cases h : K i = M2 j <;> simp [h, eq_comm]
  rw [hcount]
  -- Regroup the sum over `i` by the value `K i`.
  rw [Finset.sum_comp (fun v => (Finset.univ.filter (fun j => M2 j = v)).card) K]
  refine Finset.sum_congr rfl ?_
  intro v _
  rw [smul_eq_mul]

end MassShell

/-! ## Part 2 — Schur-complement local dilation -/

section Schur

variable {𝕜 : Type*} [Field 𝕜]
variable {n m : Type*} [Fintype n] [Fintype m] [DecidableEq n] [DecidableEq m]

/-- The **Schur complement** `D_eff = D_vis - B D_hid⁻¹ C` of the visible block
relative to the (invertible) hidden block. -/
def schurComplement (Dvis : Matrix n n 𝕜) (B : Matrix n m 𝕜) (C : Matrix m n 𝕜)
    (Dhid : Matrix m m 𝕜) [Invertible Dhid] : Matrix n n 𝕜 :=
  Dvis - B * ⅟Dhid * C

/-- Auxiliary: for an invertible matrix `A`, the linear equation `A x = z` is
equivalent to `x = A⁻¹ z`. -/
lemma mulVec_eq_iff_eq_invOf_mulVec (A : Matrix m m 𝕜) [Invertible A]
    (y z : m → 𝕜) : A.mulVec y = z ↔ y = (⅟A).mulVec z := by
  constructor
  · intro h
    rw [← h, Matrix.mulVec_mulVec, invOf_mul_self, Matrix.one_mulVec]
  · intro h
    rw [h, Matrix.mulVec_mulVec, mul_invOf_self, Matrix.one_mulVec]

omit [DecidableEq n] in
/-- **Block-system reduction.** With the hidden block invertible, the block
linear system `[[D_vis, B], [C, D_hid]] [x; y] = [a; b]` holds iff the hidden
variable is given by `y = D_hid⁻¹ (b - C x)` and the visible variable satisfies
the Schur-complement equation `D_eff x = a - B D_hid⁻¹ b`. -/
theorem blockSystem_iff_schurComplement_of_invertible_hidden
    (Dvis : Matrix n n 𝕜) (B : Matrix n m 𝕜) (C : Matrix m n 𝕜)
    (Dhid : Matrix m m 𝕜) [Invertible Dhid]
    (x : n → 𝕜) (y : m → 𝕜) (a : n → 𝕜) (b : m → 𝕜) :
    (Dvis.mulVec x + B.mulVec y = a ∧ C.mulVec x + Dhid.mulVec y = b) ↔
      (y = (⅟Dhid).mulVec (b - C.mulVec x) ∧
        (schurComplement Dvis B C Dhid).mulVec x = a - B.mulVec ((⅟Dhid).mulVec b)) := by
  have hy : (C.mulVec x + Dhid.mulVec y = b) ↔ y = (⅟Dhid).mulVec (b - C.mulVec x) := by
    rw [← mulVec_eq_iff_eq_invOf_mulVec Dhid y (b - C.mulVec x)]
    constructor
    · intro h; rw [← h]; abel
    · intro h; rw [h]; abel
  constructor
  · rintro ⟨h1, h2⟩
    have hyval : y = (⅟Dhid).mulVec (b - C.mulVec x) := hy.1 h2
    refine ⟨hyval, ?_⟩
    rw [schurComplement, Matrix.sub_mulVec, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec]
    rw [hyval, Matrix.mulVec_sub, Matrix.mulVec_sub] at h1
    rw [← h1]; abel
  · rintro ⟨hyv, hsc⟩
    refine ⟨?_, hy.2 hyv⟩
    rw [schurComplement, Matrix.sub_mulVec, ← Matrix.mulVec_mulVec,
      ← Matrix.mulVec_mulVec] at hsc
    rw [hyv, Matrix.mulVec_sub, Matrix.mulVec_sub]
    rw [eq_sub_iff_add_eq] at hsc
    rw [← hsc]; abel

omit [DecidableEq n] in
/-- **Local dilation / integrating out the hidden sheet.** Eliminating the
hidden variable from the source-free hidden equation `C x + D_hid y = 0`
(so `y = -D_hid⁻¹ C x`) and reading off the visible response
`D_vis x + B y` reproduces exactly the Schur-complement (effective) operator
acting on the visible input.  Thus a local block operator projects to a
(generally nonlocal) effective operator via the Schur complement. -/
theorem localDilation_effectiveOperator_eq_schurComplement
    (Dvis : Matrix n n 𝕜) (B : Matrix n m 𝕜) (C : Matrix m n 𝕜)
    (Dhid : Matrix m m 𝕜) [Invertible Dhid] (x : n → 𝕜) :
    Dvis.mulVec x + B.mulVec (-(⅟Dhid).mulVec (C.mulVec x))
      = (schurComplement Dvis B C Dhid).mulVec x := by
  rw [schurComplement, Matrix.sub_mulVec, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
    Matrix.mulVec_neg]
  abel

end Schur

/-! ## Part 3 — RG-Schur stability of Krein-self-adjoint, Gamma-odd operators

This part formalizes the finite algebra behind the RG-SCHUR thread goal / Q08
`T-R1`: one renormalization (decimation) step on a quasi-free carrier is the
Schur complement of the fine block, and the operator class
`{Krein-self-adjoint, Gamma-odd}` is stable under that step.

Conventions: the Krein sharp used here is the algebraic transpose sharp over a
general field.  A complex-conjugate/star Krein sharp is a separate MEMO
extension and is not claimed here.

What is PROVED here is finite linear algebra: the determinant factorization and
the closure of `{Krein-self-adjoint, Gamma-odd}` under the Schur complement.
The physical reading — "mass terms are what null microstructure
Schur-complements to", instability of per-edge null nilpotency, and
positivity/spectrum — remains MEMO/OPEN and is deliberately not encoded.
-/

section SchurStability

open scoped Matrix

variable {𝕜 : Type*} [Field 𝕜]
variable {n m : Type*} [Fintype n] [Fintype m] [DecidableEq n] [DecidableEq m]

/-- **Krein-self-adjoint** (algebraic, transpose sharp): `Aᵀ G = G A`, i.e. the
Krein sharp `A^# = G⁻¹ Aᵀ G` fixes `A`. -/
def IsKreinSelfAdjoint {ν : Type*} [Fintype ν] (G A : Matrix ν ν 𝕜) : Prop :=
  Aᵀ * G = G * A

/-- **Gamma-odd** with respect to an involution `Γ`: `Γ A Γ = -A`. -/
def IsGammaOdd {ν : Type*} [Fintype ν] (Γ A : Matrix ν ν 𝕜) : Prop :=
  Γ * A * Γ = -A

/-! ### Determinant factorization (Berezin/Schur decimation) -/

/-- **T-R1 determinant factorization.** With the fine block invertible, the
determinant of the full block operator factors as the fine determinant times
the determinant of the Schur complement, `det D = det(D_ff) * det(D_eff)`. -/
theorem det_fromBlocks_eq_det_hidden_mul_det_schurComplement
    (Dvis : Matrix n n 𝕜) (B : Matrix n m 𝕜) (C : Matrix m n 𝕜)
    (Dhid : Matrix m m 𝕜) [Invertible Dhid] :
    (Matrix.fromBlocks Dvis B C Dhid).det
      = Dhid.det * (schurComplement Dvis B C Dhid).det := by
  convert Matrix.det_fromBlocks₂₂ Dvis B C Dhid using 1

/-! ### Krein-self-adjointness is Schur-stable -/

omit [DecidableEq n] in
/-- **Krein stability (block form).** If the four blocks satisfy the blockwise
Krein-self-adjointness relations coming from a block-diagonal metric
`G = diag(Gvis, Ghid)`, with `Ghid` invertible, then the Schur complement is
Krein-self-adjoint with respect to the coarse metric `Gvis`. -/
theorem schurComplement_isKreinSelfAdjoint_of_blocks
    (Dvis : Matrix n n 𝕜) (B : Matrix n m 𝕜) (C : Matrix m n 𝕜)
    (Dhid : Matrix m m 𝕜) [Invertible Dhid]
    (Gvis : Matrix n n 𝕜) (Ghid : Matrix m m 𝕜) [Invertible Ghid]
    (hcc : Dvisᵀ * Gvis = Gvis * Dvis)
    (hhh : Dhidᵀ * Ghid = Ghid * Dhid)
    (hcross1 : Cᵀ * Ghid = Gvis * B)
    (hcross2 : Bᵀ * Gvis = Ghid * C) :
    IsKreinSelfAdjoint Gvis (schurComplement Dvis B C Dhid) := by
  have hinv : (⅟Dhid)ᵀ * Ghid = Ghid * ⅟Dhid := by
    rw [Matrix.transpose_invOf Dhid]
    calc ⅟(Dhidᵀ) * Ghid
        = ⅟(Dhidᵀ) * (Ghid * Dhid) * ⅟Dhid := by
          rw [Matrix.mul_assoc, Matrix.mul_assoc, mul_invOf_self, Matrix.mul_one]
      _ = ⅟(Dhidᵀ) * (Dhidᵀ * Ghid) * ⅟Dhid := by rw [hhh]
      _ = Ghid * ⅟Dhid := by rw [← Matrix.mul_assoc, invOf_mul_self, Matrix.one_mul]
  unfold IsKreinSelfAdjoint schurComplement
  rw [Matrix.transpose_sub, Matrix.transpose_mul, Matrix.transpose_mul,
      Matrix.sub_mul, Matrix.mul_sub, hcc]
  have key : Cᵀ * ((⅟Dhid)ᵀ * Bᵀ) * Gvis = Gvis * (B * ⅟Dhid * C) := by
    have h1 : (⅟Dhid)ᵀ * Bᵀ * Gvis = Ghid * ⅟Dhid * C := by
      rw [Matrix.mul_assoc, hcross2, ← Matrix.mul_assoc, hinv]
    calc Cᵀ * ((⅟Dhid)ᵀ * Bᵀ) * Gvis
        = Cᵀ * ((⅟Dhid)ᵀ * Bᵀ * Gvis) := by rw [Matrix.mul_assoc]
      _ = Cᵀ * (Ghid * ⅟Dhid * C) := by rw [h1]
      _ = Cᵀ * Ghid * (⅟Dhid * C) := by
          rw [Matrix.mul_assoc Ghid (⅟Dhid) C, ← Matrix.mul_assoc Cᵀ Ghid (⅟Dhid * C)]
      _ = Gvis * B * (⅟Dhid * C) := by rw [hcross1]
      _ = Gvis * (B * ⅟Dhid * C) := by rw [Matrix.mul_assoc, Matrix.mul_assoc]
  rw [key]

/-! ### Gamma-oddness is Schur-stable -/

omit [DecidableEq n] in
/-- **Gamma-odd stability (block form).** If the four blocks satisfy the
blockwise Gamma-odd relations for a block-diagonal grading
`Γ = diag(Γvis, Γhid)`, with `Γhid` an involution, then the Schur complement is
Gamma-odd with respect to `Γvis`. -/
theorem schurComplement_isGammaOdd_of_blocks
    (Dvis : Matrix n n 𝕜) (B : Matrix n m 𝕜) (C : Matrix m n 𝕜)
    (Dhid : Matrix m m 𝕜) [Invertible Dhid]
    (Γvis : Matrix n n 𝕜) (Γhid : Matrix m m 𝕜)
    (hΓhid : Γhid * Γhid = 1)
    (hcc : Γvis * Dvis * Γvis = -Dvis)
    (hhh : Γhid * Dhid * Γhid = -Dhid)
    (hcross1 : Γvis * B * Γhid = -B)
    (hcross2 : Γhid * C * Γvis = -C) :
    IsGammaOdd Γvis (schurComplement Dvis B C Dhid) := by
  have hI : Γhid * ⅟Dhid * Γhid = -⅟Dhid := by
    have hcomm : Γhid * Dhid = -(Dhid * Γhid) := by
      have h := congrArg (· * Γhid) hhh
      simpa [Matrix.mul_assoc, hΓhid, neg_mul] using h
    have h2 : ⅟Dhid * Γhid * Dhid = -Γhid := by
      rw [Matrix.mul_assoc, hcomm, mul_neg, ← Matrix.mul_assoc, invOf_mul_self, Matrix.one_mul]
    have h3 : ⅟Dhid * Γhid = -(Γhid * ⅟Dhid) := by
      have h := congrArg (· * ⅟Dhid) h2
      simpa [Matrix.mul_assoc, mul_invOf_self, neg_mul] using h
    calc Γhid * ⅟Dhid * Γhid = -(⅟Dhid * Γhid) * Γhid := by
            rw [show Γhid * ⅟Dhid = -(⅟Dhid * Γhid) by rw [h3, neg_neg]]
      _ = -⅟Dhid := by rw [neg_mul, Matrix.mul_assoc, hΓhid, Matrix.mul_one]
  have hB : Γvis * B = -(B * Γhid) := by
    have h := congrArg (· * Γhid) hcross1
    simpa [Matrix.mul_assoc, hΓhid, Matrix.neg_mul] using h
  have hC : C * Γvis = -(Γhid * C) := by
    have h := congrArg (Γhid * ·) hcross2
    simpa [← Matrix.mul_assoc, hΓhid, Matrix.mul_neg] using h
  have key : Γvis * (B * ⅟Dhid * C) * Γvis = -(B * ⅟Dhid * C) := by
    have e : Γvis * (B * ⅟Dhid * C) * Γvis = (Γvis * B) * ⅟Dhid * (C * Γvis) := by
      simp only [Matrix.mul_assoc]
    rw [e, hB, hC]
    calc (-(B * Γhid)) * ⅟Dhid * (-(Γhid * C))
        = (B * Γhid) * ⅟Dhid * (Γhid * C) := by
          simp only [Matrix.neg_mul, Matrix.mul_neg, neg_neg]
      _ = B * (Γhid * ⅟Dhid * Γhid) * C := by simp only [Matrix.mul_assoc]
      _ = B * (-⅟Dhid) * C := by rw [hI]
      _ = -(B * ⅟Dhid * C) := by simp [Matrix.mul_assoc, Matrix.mul_neg, Matrix.neg_mul]
  unfold IsGammaOdd schurComplement
  rw [Matrix.mul_sub, Matrix.sub_mul, hcc, key]
  abel

/-! ### Full-matrix bridges: block-diagonal metric / grading -/

omit [DecidableEq n] [DecidableEq m] in
/-- The full block operator is Krein-self-adjoint for the block-diagonal metric
`diag(Gvis, Ghid)` iff the four blockwise Krein relations hold. -/
theorem isKreinSelfAdjoint_fromBlocks_iff
    (Dvis : Matrix n n 𝕜) (B : Matrix n m 𝕜) (C : Matrix m n 𝕜)
    (Dhid : Matrix m m 𝕜) (Gvis : Matrix n n 𝕜) (Ghid : Matrix m m 𝕜) :
    IsKreinSelfAdjoint (Matrix.fromBlocks Gvis 0 0 Ghid)
        (Matrix.fromBlocks Dvis B C Dhid)
      ↔ (Dvisᵀ * Gvis = Gvis * Dvis) ∧ (Dhidᵀ * Ghid = Ghid * Dhid)
          ∧ (Cᵀ * Ghid = Gvis * B) ∧ (Bᵀ * Gvis = Ghid * C) := by
  unfold IsKreinSelfAdjoint
  simp +decide [← Matrix.ext_iff, Matrix.mul_apply, Matrix.fromBlocks_multiply]
  grind

omit [DecidableEq n] [DecidableEq m] in
/-- The full block operator is Gamma-odd for the block-diagonal grading
`diag(Γvis, Γhid)` iff the four blockwise Gamma-odd relations hold. -/
theorem isGammaOdd_fromBlocks_iff
    (Dvis : Matrix n n 𝕜) (B : Matrix n m 𝕜) (C : Matrix m n 𝕜)
    (Dhid : Matrix m m 𝕜) (Γvis : Matrix n n 𝕜) (Γhid : Matrix m m 𝕜) :
    IsGammaOdd (Matrix.fromBlocks Γvis 0 0 Γhid)
        (Matrix.fromBlocks Dvis B C Dhid)
      ↔ (Γvis * Dvis * Γvis = -Dvis) ∧ (Γhid * Dhid * Γhid = -Dhid)
          ∧ (Γvis * B * Γhid = -B) ∧ (Γhid * C * Γvis = -C) := by
  unfold IsGammaOdd
  simp +decide [← Matrix.ext_iff, Matrix.mul_apply, Matrix.fromBlocks_multiply]
  grind

/-! ### Axiom audit -/

/-- info: 'PhysicsSM.NullStrand.DualSolder.det_fromBlocks_eq_det_hidden_mul_det_schurComplement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_fromBlocks_eq_det_hidden_mul_det_schurComplement

/-- info: 'PhysicsSM.NullStrand.DualSolder.schurComplement_isKreinSelfAdjoint_of_blocks' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms schurComplement_isKreinSelfAdjoint_of_blocks

/-- info: 'PhysicsSM.NullStrand.DualSolder.schurComplement_isGammaOdd_of_blocks' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms schurComplement_isGammaOdd_of_blocks

/-- info: 'PhysicsSM.NullStrand.DualSolder.isKreinSelfAdjoint_fromBlocks_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms isKreinSelfAdjoint_fromBlocks_iff

/-- info: 'PhysicsSM.NullStrand.DualSolder.isGammaOdd_fromBlocks_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms isGammaOdd_fromBlocks_iff

end SchurStability

/-!
## Part 4 - RG-Schur destabilization witness

Parts 2 and 3 established the stability side of the RG-Schur lane: one Schur
complement step preserves Krein-self-adjointness and Gamma-oddness under the
displayed block hypotheses.  This section supplies the complementary finite
destabilization witness: a null visible block and nilpotent off-diagonal solder
can Schur-complement to a nonzero scalar visible block.

Claim boundary: this is exact finite matrix algebra over `Rat`.  It is not a
continuum RG flow, a physical mass-gap theorem, a Standard Model prediction, or
a positivity theorem.
-/

section SchurWitness

open scoped Matrix

attribute [local instance] invertibleOne

/-- The strictly upper off-diagonal solder block is nilpotent. -/
theorem solder_offDiagonal_sq_eq_zero :
    (Matrix.fromBlocks (0 : Matrix (Fin 2) (Fin 2) ℚ) (1 : Matrix (Fin 2) (Fin 2) ℚ)
        (0 : Matrix (Fin 2) (Fin 2) ℚ) (0 : Matrix (Fin 2) (Fin 2) ℚ)) ^ 2 = 0 := by
  rw [pow_two, Matrix.fromBlocks_multiply]
  simp

/-- The nilpotent solder block is nonzero, so the nilpotency witness is not
vacuous. -/
theorem solder_offDiagonal_ne_zero :
    (Matrix.fromBlocks (0 : Matrix (Fin 2) (Fin 2) ℚ) (1 : Matrix (Fin 2) (Fin 2) ℚ)
        (0 : Matrix (Fin 2) (Fin 2) ℚ) (0 : Matrix (Fin 2) (Fin 2) ℚ)) ≠ 0 := by
  intro h
  have := congrFun (congrFun h (Sum.inl 0)) (Sum.inr 0)
  simp [Matrix.fromBlocks] at this

/-- With null visible block and identity hidden/solder blocks, the Schur
complement is the nonzero scalar block `-1`. -/
theorem schurComplement_null_visible_eq_neg_scalar :
    schurComplement (0 : Matrix (Fin 2) (Fin 2) ℚ) 1 1 (1 : Matrix (Fin 2) (Fin 2) ℚ)
      = Matrix.scalar (Fin 2) (-1 : ℚ) := by
  rw [show schurComplement (0 : Matrix (Fin 2) (Fin 2) ℚ) 1 1
      (1 : Matrix (Fin 2) (Fin 2) ℚ)
      = -(1 : Matrix (Fin 2) (Fin 2) ℚ) by
        simp [schurComplement]]
  ext i j
  simp only [Matrix.scalar_apply, Matrix.neg_apply, Matrix.one_apply, Matrix.diagonal_apply]
  by_cases h : i = j <;> simp [h]

/-- The generated effective scalar block is nonzero. -/
theorem schurComplement_null_visible_ne_zero :
    schurComplement (0 : Matrix (Fin 2) (Fin 2) ℚ) 1 1 (1 : Matrix (Fin 2) (Fin 2) ℚ)
      ≠ 0 := by
  rw [schurComplement_null_visible_eq_neg_scalar]
  intro h
  have := congrFun (congrFun h 0) 0
  simp [Matrix.scalar_apply] at this

/-- A packaged RG-Schur destabilization witness: Schur complementation can
generate a nonzero scalar amplitude from null visible data. -/
theorem schurComplement_generates_nonzero_scalar_amplitude :
    ∃ m : ℚ, m ≠ 0 ∧
      schurComplement (0 : Matrix (Fin 2) (Fin 2) ℚ) 1 1 (1 : Matrix (Fin 2) (Fin 2) ℚ)
        = Matrix.scalar (Fin 2) m :=
  ⟨-1, by norm_num, schurComplement_null_visible_eq_neg_scalar⟩

/-- The full `1 x 1` block operator has determinant `-1`. -/
theorem fullOperator_det_eq_neg_one :
    (Matrix.fromBlocks (0 : Matrix (Fin 1) (Fin 1) ℚ) 1 1
        (1 : Matrix (Fin 1) (Fin 1) ℚ)).det = -1 := by
  rw [Matrix.det_fromBlocks₂₂]
  simp

/-- Entrywise `1 x 1` witness: the visible block is zero while the effective
Schur block entry is strictly negative. -/
theorem schurComplement_null_visible_entry_neg :
    schurComplement (0 : Matrix (Fin 1) (Fin 1) ℚ) 1 1
        (1 : Matrix (Fin 1) (Fin 1) ℚ) 0 0 = -1
      ∧ (0 : Matrix (Fin 1) (Fin 1) ℚ) 0 0 = 0 := by
  refine ⟨?_, rfl⟩
  simp [schurComplement]

/-! ### Guarded axiom footprint -/

/-- info: 'PhysicsSM.NullStrand.DualSolder.solder_offDiagonal_sq_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms solder_offDiagonal_sq_eq_zero

/-- info: 'PhysicsSM.NullStrand.DualSolder.schurComplement_null_visible_eq_neg_scalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms schurComplement_null_visible_eq_neg_scalar

/-- info: 'PhysicsSM.NullStrand.DualSolder.schurComplement_generates_nonzero_scalar_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms schurComplement_generates_nonzero_scalar_amplitude

/-- info: 'PhysicsSM.NullStrand.DualSolder.fullOperator_det_eq_neg_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullOperator_det_eq_neg_one

end SchurWitness

end PhysicsSM.NullStrand.DualSolder
