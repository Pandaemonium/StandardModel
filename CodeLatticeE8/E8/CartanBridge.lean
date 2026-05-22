import Mathlib.Tactic
import CodeLatticeE8.E8.Gram
import CodeLatticeE8.E8.Span
import CodeLatticeE8.E8.Determinant

/-!
# Gram–Cartan bridge for the Hamming Construction A lattice

This module proves the connection between the Gram matrix of the Hamming
Construction A basis and the standard E8 Cartan matrix, confirming that
the Construction A lattice realizes the E8 root system.

## Mathematical content

The E8 Cartan matrix `e8CartanMatrix` is the integer matrix recording the
inner products `2⟨αᵢ, αⱼ⟩ / |αⱼ|²` of the E8 simple roots.  In the simply-
laced normalization (all roots of squared length `2`), this equals the inner
product matrix of the simple roots directly.

The **Gram–Cartan bridge** is an explicit integer change-of-basis matrix `P`
(8 × 8, unimodular, `|det| = 1`) satisfying:

```text
Pᵀ · hammingConstructionGram · P  =  2 · e8CartanMatrix
```

This means the 8 short vectors `Pⱼ := ∑ᵢ P[i,j] · bᵢ` (where `bᵢ` are the
Construction A basis vectors) have integer inner products `2 · Cartan[j,k]`.
After the conventional `1/√2` scaling of the Construction A model to E8 roots,
these become the simple roots of E8.

## The simple roots

The simple-root vectors `e8SimpleRoots` are defined as the columns of `B · P`
where `B` is the basis matrix.  Each simple root:
- belongs to `hammingConstructionA` (lattice membership);
- has unscaled squared norm `4` (actual E8 squared norm `2`);
- reproduces the Dynkin diagram via
  `intDot (e8SimpleRoots i) (e8SimpleRoots j) = 2 · e8CartanMatrix i j`.

## Normalization note

The factor of `2` in `Pᵀ G P = 2 · Cartan` arises because `G` records unscaled
inner products (integer model), while the Cartan matrix records inner products
after the `1/√2` normalization.  Dividing by 2: `(1/2) · G[i,j] = ⟨bᵢ, bⱼ⟩_E8`.

## Finite-computation trust

The Gram–Cartan congruence `gramCartan_congruence` is proved by ordinary
`decide` over the 64 integer matrix entries.  This is kernel reduction, not
native-code evaluation.

The Cartan determinant is proved by a sparse cofactor expansion.  The two
7-by-7 cofactors are reduced once more to 6-by-6 determinants, which are small
enough for ordinary kernel `decide`; no native-code evaluation is used in this
module.

## Sources

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 4, §4.8.
- Bourbaki, *Lie Groups and Lie Algebras*, Ch. 4–6 (Dynkin labelling,
  Cartan matrix conventions).
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8

open CodeLatticeE8.ConstructionA

/-! ## The E8 Cartan matrix

The Dynkin diagram of E8 in Bourbaki labelling (0-indexed nodes):

```
0 — 2 — 3 — 4 — 5 — 6 — 7
        |
        1
```

Adjacent nodes give Cartan entry `−1`; diagonal entries are `2`; all others `0`.
-/

/-- The E8 Cartan matrix in Bourbaki labelling.

Entry `e8CartanMatrix i j = 2⟨αᵢ, αⱼ⟩ / |αⱼ|²`.  For a simply-laced root
system with all roots of squared length 2, this equals `⟨αᵢ, αⱼ⟩`. -/
def e8CartanMatrix : Matrix (Fin 8) (Fin 8) ℤ :=
  !![  2,  0, -1,  0,  0,  0,  0,  0;
       0,  2,  0, -1,  0,  0,  0,  0;
      -1,  0,  2, -1,  0,  0,  0,  0;
       0, -1, -1,  2, -1,  0,  0,  0;
       0,  0,  0, -1,  2, -1,  0,  0;
       0,  0,  0,  0, -1,  2, -1,  0;
       0,  0,  0,  0,  0, -1,  2, -1;
       0,  0,  0,  0,  0,  0, -1,  2]

/-! ## Basic properties of the Cartan matrix -/

/-- Every diagonal entry of the E8 Cartan matrix equals `2`. -/
theorem e8CartanMatrix_diag (i : Fin 8) : e8CartanMatrix i i = 2 := by
  fin_cases i <;> decide

/-- Every off-diagonal entry of the E8 Cartan matrix is `0` or `−1`. -/
theorem e8CartanMatrix_offDiag (i j : Fin 8) (h : i ≠ j) :
    e8CartanMatrix i j = 0 ∨ e8CartanMatrix i j = -1 := by
  fin_cases i <;> fin_cases j <;> simp_all [e8CartanMatrix]

/-- The E8 Cartan matrix is symmetric. -/
theorem e8CartanMatrix_symm (i j : Fin 8) :
    e8CartanMatrix i j = e8CartanMatrix j i := by
  fin_cases i <;> fin_cases j <;> decide

/-! ## Determinant of the Cartan matrix

The determinant is proved by cofactor expansion along row 0.  The two 7-by-7
cofactors are sparse, so we expand them once more and reduce to four 6-by-6
determinants.  Those small determinants are checked by ordinary `decide`.

```text
det(e8CartanMatrix) = 2 · 4 − 7 = 1
```
-/

private def e8CartanMinor00 : Matrix (Fin 7) (Fin 7) ℤ :=
  !![  2,  0, -1,  0,  0,  0,  0;
       0,  2, -1,  0,  0,  0,  0;
      -1, -1,  2, -1,  0,  0,  0;
       0,  0, -1,  2, -1,  0,  0;
       0,  0,  0, -1,  2, -1,  0;
       0,  0,  0,  0, -1,  2, -1;
       0,  0,  0,  0,  0, -1,  2]

private def e8CartanMinor02 : Matrix (Fin 7) (Fin 7) ℤ :=
  !![  0,  2, -1,  0,  0,  0,  0;
      -1,  0, -1,  0,  0,  0,  0;
       0, -1,  2, -1,  0,  0,  0;
       0,  0, -1,  2, -1,  0,  0;
       0,  0,  0, -1,  2, -1,  0;
       0,  0,  0,  0, -1,  2, -1;
       0,  0,  0,  0,  0, -1,  2]

/-! ### Six-by-six minors for the Cartan determinant

Each 7-by-7 cofactor has only two nonzero entries in its first row.  Expanding
along that row keeps the proof auditable: the displayed 6-by-6 matrices below
are exactly the remaining cofactors, and the final arithmetic is visible in
`e8CartanMinor00_det` and `e8CartanMinor02_det`.
-/

/-- The `(0,0)` subminor of `e8CartanMinor00`: the `A_6` Cartan matrix. -/
private def minor00_sub0 : Matrix (Fin 6) (Fin 6) Int :=
  !![  2, -1,  0,  0,  0,  0;
      -1,  2, -1,  0,  0,  0;
       0, -1,  2, -1,  0,  0;
       0,  0, -1,  2, -1,  0;
       0,  0,  0, -1,  2, -1;
       0,  0,  0,  0, -1,  2]

/-- The `(0,2)` subminor of `e8CartanMinor00`. -/
private def minor00_sub2 : Matrix (Fin 6) (Fin 6) Int :=
  !![ 0,  2,  0,  0,  0,  0;
     -1, -1, -1,  0,  0,  0;
      0,  0,  2, -1,  0,  0;
      0,  0, -1,  2, -1,  0;
      0,  0,  0, -1,  2, -1;
      0,  0,  0,  0, -1,  2]

/-- The `(0,1)` subminor of `e8CartanMinor02`. -/
private def minor02_sub1 : Matrix (Fin 6) (Fin 6) Int :=
  !![-1, -1,  0,  0,  0,  0;
      0,  2, -1,  0,  0,  0;
      0, -1,  2, -1,  0,  0;
      0,  0, -1,  2, -1,  0;
      0,  0,  0, -1,  2, -1;
      0,  0,  0,  0, -1,  2]

/-- The `(0,2)` subminor of `e8CartanMinor02`. -/
private def minor02_sub2 : Matrix (Fin 6) (Fin 6) Int :=
  !![-1,  0,  0,  0,  0,  0;
      0, -1, -1,  0,  0,  0;
      0,  0,  2, -1,  0,  0;
      0,  0, -1,  2, -1,  0;
      0,  0,  0, -1,  2, -1;
      0,  0,  0,  0, -1,  2]

set_option maxRecDepth 10000 in
set_option maxHeartbeats 400000 in
-- A 6-by-6 determinant expands over 720 permutations, so kernel reduction
-- needs a larger heartbeat budget than the default.
private theorem minor00_sub0_det : Matrix.det minor00_sub0 = 7 := by
  decide

set_option maxRecDepth 10000 in
set_option maxHeartbeats 400000 in
-- A 6-by-6 determinant expands over 720 permutations, so kernel reduction
-- needs a larger heartbeat budget than the default.
private theorem minor00_sub2_det : Matrix.det minor00_sub2 = 10 := by
  decide

set_option maxRecDepth 10000 in
set_option maxHeartbeats 400000 in
-- A 6-by-6 determinant expands over 720 permutations, so kernel reduction
-- needs a larger heartbeat budget than the default.
private theorem minor02_sub1_det : Matrix.det minor02_sub1 = -6 := by
  decide

set_option maxRecDepth 10000 in
set_option maxHeartbeats 400000 in
-- A 6-by-6 determinant expands over 720 permutations, so kernel reduction
-- needs a larger heartbeat budget than the default.
private theorem minor02_sub2_det : Matrix.det minor02_sub2 = 5 := by
  decide

private theorem minor00_sub0_eq :
    e8CartanMinor00.submatrix Fin.succ ((0 : Fin 7).succAbove) = minor00_sub0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

private theorem minor00_sub2_eq :
    e8CartanMinor00.submatrix Fin.succ ((2 : Fin 7).succAbove) = minor00_sub2 := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

private theorem minor02_sub1_eq :
    e8CartanMinor02.submatrix Fin.succ ((1 : Fin 7).succAbove) = minor02_sub1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

private theorem minor02_sub2_eq :
    e8CartanMinor02.submatrix Fin.succ ((2 : Fin 7).succAbove) = minor02_sub2 := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

/-- The `(0,0)` cofactor minor has determinant `4`.

Cofactor expansion along row 0 gives `2 * 7 - 10 = 4`. -/
private theorem e8CartanMinor00_det : Matrix.det e8CartanMinor00 = 4 := by
  rw [Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_seven, Fin.isValue]
  rw [show e8CartanMinor00 0 0 = 2 from by decide,
      show e8CartanMinor00 0 1 = 0 from by decide,
      show e8CartanMinor00 0 2 = -1 from by decide,
      show e8CartanMinor00 0 3 = 0 from by decide,
      show e8CartanMinor00 0 4 = 0 from by decide,
      show e8CartanMinor00 0 5 = 0 from by decide,
      show e8CartanMinor00 0 6 = 0 from by decide]
  rw [minor00_sub0_eq, minor00_sub2_eq, minor00_sub0_det, minor00_sub2_det]
  norm_num

/-- The `(0,2)` cofactor minor has determinant `7`.

Cofactor expansion along row 0 gives `-2 * (-6) - 5 = 7`. -/
private theorem e8CartanMinor02_det : Matrix.det e8CartanMinor02 = 7 := by
  rw [Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_seven, Fin.isValue]
  rw [show e8CartanMinor02 0 0 = 0 from by decide,
      show e8CartanMinor02 0 1 = 2 from by decide,
      show e8CartanMinor02 0 2 = -1 from by decide,
      show e8CartanMinor02 0 3 = 0 from by decide,
      show e8CartanMinor02 0 4 = 0 from by decide,
      show e8CartanMinor02 0 5 = 0 from by decide,
      show e8CartanMinor02 0 6 = 0 from by decide]
  rw [minor02_sub1_eq, minor02_sub2_eq, minor02_sub1_det, minor02_sub2_det]
  norm_num

private theorem e8CartanMinor00_eq :
    e8CartanMatrix.submatrix Fin.succ ((0 : Fin 8).succAbove) = e8CartanMinor00 := by
  ext i j; fin_cases i <;> fin_cases j <;> decide

private theorem e8CartanMinor02_eq :
    e8CartanMatrix.submatrix Fin.succ ((2 : Fin 8).succAbove) = e8CartanMinor02 := by
  ext i j; fin_cases i <;> fin_cases j <;> decide

/-- The E8 Cartan matrix has determinant `1`, confirming that E8 is a unimodular root system.

Cofactor expansion along row 0 (`[2, 0, −1, 0, …, 0]`) reduces to two 7×7 minors:
```text
det = 2 · 4 − 7 = 1
```
-/
theorem e8CartanMatrix_det : Matrix.det e8CartanMatrix = 1 := by
  rw [Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_eight, Fin.isValue]
  rw [show e8CartanMatrix 0 0 = 2 from by decide,
      show e8CartanMatrix 0 1 = 0 from by decide,
      show e8CartanMatrix 0 2 = -1 from by decide,
      show e8CartanMatrix 0 3 = 0 from by decide,
      show e8CartanMatrix 0 4 = 0 from by decide,
      show e8CartanMatrix 0 5 = 0 from by decide,
      show e8CartanMatrix 0 6 = 0 from by decide,
      show e8CartanMatrix 0 7 = 0 from by decide]
  rw [e8CartanMinor00_eq, e8CartanMinor02_eq,
      e8CartanMinor00_det, e8CartanMinor02_det]
  norm_num

/-! ## Determinant of the doubled Cartan matrix

We need `det(2 · e8CartanMatrix) = 256` for the unimodularity proof.  Rather
than recomputing new minors, we derive it from `Matrix.det_smul` and
`e8CartanMatrix_det`.
-/

/-- `det(2 · e8CartanMatrix) = 256`.

This equals `2⁸ · det(e8CartanMatrix) = 2⁸ · 1`, by determinant scaling. -/
private theorem e8CartanDoubled_det : (2 • e8CartanMatrix : Matrix (Fin 8) (Fin 8) ℤ).det = 256 := by
  change Matrix.det ((2 : ℤ) • e8CartanMatrix) = 256
  rw [Matrix.det_smul e8CartanMatrix (2 : ℤ), e8CartanMatrix_det]
  norm_num

/-! ## Change-of-basis matrix

The matrix `e8BasisChangeMatrix` expresses the E8 simple roots (in Bourbaki
order) as integer linear combinations of the Hamming Construction A basis
vectors.  Column `j` gives the coefficients for simple root `j`.
-/

/-- The change-of-basis matrix from the Construction A basis to the E8
simple-root basis (Bourbaki labelling).

Each column expresses one E8 simple root as a ℤ-linear combination of the
eight Construction A basis vectors `hammingConstructionBasis`.  The matrix is
unimodular (proved below via the Gram–Cartan bridge), so the simple roots
generate the same lattice as the Construction A basis.

Source: explicit linear-algebra search over the E8 short shell in Construction
A integer coordinates. -/
def e8BasisChangeMatrix : Matrix (Fin 8) (Fin 8) ℤ :=
  !![ 2,  0, -1,  0,  0,  0,  0,  0;
      2, -1, -1,  1, -1, -1,  2,  0;
      2, -1, -1,  1, -1,  0,  0,  0;
     -4,  1,  2, -1,  1,  1, -1, -1;
     -1,  1,  1, -1,  0,  1, -1,  0;
     -1,  0,  1, -1,  1,  0,  0,  0;
      2, -1, -1,  1, -1,  0,  0,  1;
     -3,  1,  2, -1,  1,  0, -1,  0]

/-! ## Gram–Cartan congruence (main bridge theorem) -/

/-- **Gram–Cartan bridge.**

The change-of-basis matrix transforms the Construction A Gram matrix into
`2 · e8CartanMatrix`:

```text
Pᵀ · hammingConstructionGram · P  =  2 · e8CartanMatrix
```

where `P = e8BasisChangeMatrix`.

This is the central connection between the concrete Construction A model and
the abstract E8 root system.

**Proof**: direct integer matrix computation, certified by `decide` (64 small
integer entries, each verified by kernel reduction). -/
theorem gramCartan_congruence :
    e8BasisChangeMatrix.transpose * hammingConstructionGram * e8BasisChangeMatrix =
      2 • e8CartanMatrix := by
  ext i j; fin_cases i <;> fin_cases j <;> decide

/-! ## Unimodularity of the change-of-basis matrix -/

/-- **Unimodularity**: `det(P)² = 1`.

Taking determinants on both sides of `Pᵀ G P = 2 · Cartan`:
```text
det(P)² · det(G) = det(2 · Cartan) = 256 = det(G)
```
Hence `det(P)² = 1`.  In particular `det(P) = 1` or `det(P) = −1`. -/
theorem e8BasisChangeMatrix_det_sq : e8BasisChangeMatrix.det ^ 2 = 1 := by
  have hbridge := gramCartan_congruence
  have hlhs :
      (e8BasisChangeMatrix.transpose * hammingConstructionGram * e8BasisChangeMatrix).det =
        e8BasisChangeMatrix.det ^ 2 * hammingConstructionGram.det := by
    rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose]; ring
  rw [hbridge, e8CartanDoubled_det, hammingConstructionGram_det] at hlhs
  linarith

/-- The change-of-basis matrix `P` is invertible over ℤ (unimodular). -/
theorem e8BasisChangeMatrix_isUnit : IsUnit e8BasisChangeMatrix := by
  rw [Matrix.isUnit_iff_isUnit_det]
  have hsq := e8BasisChangeMatrix_det_sq
  have hpm : e8BasisChangeMatrix.det = 1 ∨ e8BasisChangeMatrix.det = -1 := by
    have : (e8BasisChangeMatrix.det - 1) * (e8BasisChangeMatrix.det + 1) = 0 := by nlinarith
    rcases mul_eq_zero.mp this with h | h
    · exact Or.inl (by linarith)
    · exact Or.inr (by linarith)
  rcases hpm with h | h
  · rw [h]; exact isUnit_one
  · rw [h]; exact Int.isUnit_iff.mpr (Or.inr rfl)

/-! ## The E8 simple roots as lattice vectors -/

/-- The 8 E8 simple roots in the integer coordinates of the Hamming
Construction A lattice.

Simple root `j` is `∑ᵢ P[i,j] · hammingConstructionBasis i`, i.e., the
`j`-th column of `B · P` read coordinatewise. -/
def e8SimpleRoots (j : Fin 8) : Fin 8 → ℤ :=
  fun k => ∑ i : Fin 8, e8BasisChangeMatrix i j * hammingConstructionBasis i k

/-- Every simple root belongs to the Hamming Construction A lattice.

Each simple root is a ℤ-linear combination of `hammingConstructionBasis`
vectors, which span the lattice by `hammingConstructionASubmodule_eq_span`. -/
theorem e8SimpleRoots_mem (j : Fin 8) : e8SimpleRoots j ∈ hammingConstructionA := by
  rw [← mem_hammingConstructionASubmodule]
  have hmem : e8SimpleRoots j ∈
      Submodule.span ℤ (Set.range hammingConstructionBasis) := by
    have heq : e8SimpleRoots j =
        ∑ i : Fin 8, e8BasisChangeMatrix i j • hammingConstructionBasis i := by
      ext k; simp [e8SimpleRoots, Finset.sum_apply]
    rw [heq]
    apply Submodule.sum_mem
    intro i _
    exact Submodule.smul_mem _ _ (Submodule.subset_span (Set.mem_range_self i))
  exact hammingConstructionASubmodule_eq_span.symm ▸ hmem

private theorem e8SimpleRoots_matrix_apply (i k : Fin 8) :
    e8SimpleRoots i k =
      (e8BasisChangeMatrix.transpose * hammingConstructionBasisMatrix) i k := by
  simp [e8SimpleRoots, Matrix.mul_apply, Matrix.transpose_apply, hammingConstructionBasisMatrix]

private theorem simpleRootGram_matrix :
    (e8BasisChangeMatrix.transpose * hammingConstructionBasisMatrix) *
        (e8BasisChangeMatrix.transpose * hammingConstructionBasisMatrix).transpose =
      e8BasisChangeMatrix.transpose * hammingConstructionGram * e8BasisChangeMatrix := by
  rw [Matrix.transpose_mul, Matrix.transpose_transpose]
  rw [← Matrix.mul_assoc]
  rw [Matrix.mul_assoc e8BasisChangeMatrix.transpose hammingConstructionBasisMatrix
    hammingConstructionBasisMatrix.transpose]
  rw [← hammingConstructionGram_eq_basisMatrix_mul_transpose]

/-- **Gram matrix of the simple roots**: the inner product `⟨αᵢ, αⱼ⟩` in the
integer model equals `2 · e8CartanMatrix i j`.

This verifies the E8 Dynkin diagram:
- Diagonal: `2 · 2 = 4` (each simple root has squared norm `4`).
- Adjacent nodes in E8: `2 · (−1) = −2`.
- Non-adjacent nodes: `2 · 0 = 0`.

The proof derives the identity from `gramCartan_congruence`, rather than
rechecking the 64 entries independently. -/
theorem e8SimpleRoots_gram (i j : Fin 8) :
    intDot (e8SimpleRoots i) (e8SimpleRoots j) = 2 * e8CartanMatrix i j := by
  have hdot : intDot (e8SimpleRoots i) (e8SimpleRoots j) =
      ((e8BasisChangeMatrix.transpose * hammingConstructionBasisMatrix) *
        (e8BasisChangeMatrix.transpose * hammingConstructionBasisMatrix).transpose) i j := by
    simp only [intDot, Matrix.mul_apply, Matrix.transpose_apply, e8SimpleRoots_matrix_apply]
  rw [hdot, simpleRootGram_matrix]
  exact congrFun (congrFun gramCartan_congruence i) j

/-- Every simple root has unscaled squared norm `4`.

In the `1/√2` normalization this becomes squared norm `2`, the standard E8
root length.  Derived from the diagonal of the simple-root Gram matrix:
`intDot (e8SimpleRoots j) (e8SimpleRoots j) = 2 · 2 = 4`. -/
theorem e8SimpleRoots_sqNorm (j : Fin 8) : sqNorm (e8SimpleRoots j) = 4 := by
  have hgram : intDot (e8SimpleRoots j) (e8SimpleRoots j) = 4 := by
    have h := e8SimpleRoots_gram j j
    rw [e8CartanMatrix_diag] at h
    linarith
  have heq : intDot (e8SimpleRoots j) (e8SimpleRoots j) = sqNorm (e8SimpleRoots j) := by
    simp [intDot, sqNorm, pow_two]
  linarith

end CodeLatticeE8.E8
