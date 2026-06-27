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

end PhysicsSM.NullStrand.DualSolder
