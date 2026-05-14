import Mathlib
import PhysicsSM.Lie.Exceptional.E8
import PhysicsSM.Lie.Exceptional.E8PositiveDefinite
import PhysicsSM.Coding.ConstructionALatticeProperties

/-!
# Even unimodular lattice uniqueness in rank 8 (draft)

## Classical theorem

Every rank-8 positive-definite even unimodular lattice is isometric to the
E8 root lattice.  Equivalently, any symmetric `8 × 8` integer matrix that is
positive-definite (over `ℝ`), even (all diagonal entries divisible by `2`),
and unimodular (`det = ±1`) is `GL(8, ℤ)`-congruent to the E8 Gram matrix.

### Standard references

- J. H. Conway & N. J. A. Sloane, *Sphere Packings, Lattices and Groups*,
  Chapter 16, Theorem 1: "There is exactly one even unimodular lattice in
  dimension 8, namely E₈."
- J.-P. Serre, *A Course in Arithmetic*, Chapter V, §2.2, Theorem 6.
- J. W. S. Cassels, *Rational Quadratic Forms*, Chapter 9.
- J. Milnor & D. Husemoller, *Symmetric Bilinear Forms*, Chapter II.

The proof (Serre's approach) uses:
1. The mass formula / Smith–Minkowski–Siegel formula shows the mass of
   genus of even unimodular lattices in dimension 8 is `1 / |Aut(E₈)|`.
2. Since the E8 lattice contributes at least `1 / |Aut(E₈)|` to the mass,
   it must be the only lattice in the genus.

An alternative, more elementary approach (Conway–Sloane Chapter 16) uses:
1. Even unimodular lattices exist only in dimensions divisible by 8.
2. In dimension 8, theta-function arguments (modular forms of weight 4
   for SL₂(ℤ)) show the theta series must be the Eisenstein series E₄.
3. The number of vectors of each norm is thus determined.
4. The 240 norm-2 vectors form the E8 root system, which generates the
   lattice and determines it up to isometry.

## Mathlib API map

The following Mathlib definitions are relevant for a full formalization:

- **Lattice (as ℤ-module)**: `Fin 8 → ℤ` as the ambient module.
  A sub-lattice can be modeled as `Submodule ℤ (Fin 8 → ℤ)` or, for full-rank
  lattices, just `Fin 8 → ℤ` equipped with a bilinear/quadratic form.
  Alternatively, one works directly with symmetric Gram matrices.

- **Bilinear form / Gram matrix**:
  `Matrix.toBilin' : Matrix n n R ≃ₗ[R] LinearMap.BilinForm R (n → R)`
  gives the bilinear form `B(x,y) = xᵀ G y` associated to a matrix `G`.

- **Quadratic form**:
  `Matrix.toQuadraticMap' : Matrix n n R → QuadraticMap R (n → R) R`
  gives `Q(x) = xᵀ G x`.  Note: `QuadraticMap.toMatrix'` requires
  `Invertible 2`, which fails over `ℤ`.  So we prefer to work with bilinear
  forms or directly with Gram matrices.

- **Symmetry**: `Matrix.IsSymm G` means `Gᵀ = G`.

- **Even**: `∀ i, 2 ∣ G i i` (all diagonal entries are even).
  Equivalently, the associated bilinear form satisfies `2 ∣ B(v, v)` for
  all lattice vectors `v`.

- **Unimodular**: `G.det = 1 ∨ G.det = -1` (for positive-definite, `det = 1`).

- **Positive definite**: `(G.map (Int.castRingHom ℝ)).PosDef`.
  This uses Mathlib's `Matrix.PosDef`, which requires `IsHermitian` (= `IsSymm`
  over `ℝ`) and strict positivity of `xᵀ G x` for nonzero `x`.

- **Isometry / GL(n,ℤ)-congruence**: Two Gram matrices `G₁, G₂` are
  *congruent over ℤ* if there exists `U : Matrix (Fin 8) (Fin 8) ℤ` with
  `IsUnit U.det` and `Uᵀ * G₁ * U = G₂`.  Equivalently, the associated
  quadratic forms are equivalent: `QuadraticMap.Equivalent Q₁ Q₂`.

## Formalization status

### What exists in this project

- `PhysicsSM.Lie.Exceptional.E8.e8Cartan`: the 8×8 E8 Cartan matrix.
- `e8Cartan_det_eq_one`: `det(e8Cartan) = 1`.
- `e8Cartan_diag`: diagonal entries are `2`.
- `PhysicsSM.Coding.constructionA_sqNorm_dvd_four_of_doublyEven`:
  doubly-even codes yield 4-divisible squared norms.
- `PhysicsSM.Coding.constructionA_sqNorm_ge_four`: minimum-norm bound.

### Blockers for a full proof

1. **Theta series / modular forms**: Mathlib has no theory of modular forms
   for SL₂(ℤ), theta series of lattices, or Eisenstein series.  This blocks
   the Conway–Sloane approach entirely.

2. **Mass formula**: The Smith–Minkowski–Siegel mass formula is not in Mathlib.
   This blocks Serre's approach.

3. **Root system classification**: Mathlib does not have a classification of
   root systems or a theorem that 240 vectors of norm 2 forming a root
   system of type E8 determine the lattice.

4. **Integral quadratic form theory**: While Mathlib has `QuadraticMap` and
   `BilinForm`, the theory of integral quadratic forms (genera, spinor genus,
   p-adic completions) is absent.

5. **`QuadraticMap.toMatrix'` over ℤ**: Requires `Invertible 2`, which
   doesn't exist for `ℤ`.  Workaround: use bilinear forms directly.

### What can be done now

- State the theorem precisely using Gram matrices.
- Prove small precursor lemmas (e8Cartan is symmetric, even, unimodular,
  positive-definite over ℝ).
- Document the proof plan for future work.

## This module

Below we:
1. Define the predicates `IsEvenGram`, `IsUnimodularGram`, `IsPosDef_over_reals`.
2. State the classification theorem as a `sorry`-marked draft.
3. Prove precursor lemmas showing `e8Cartan` satisfies all the hypotheses.
-/

set_option linter.style.longLine false

open PhysicsSM.Lie.Exceptional.E8

namespace PhysicsSM.Draft.E8EvenUnimodularUniqueness

/-! ## Predicates for even unimodular positive-definite Gram matrices -/

/-- A symmetric integer matrix is *even* if every diagonal entry is divisible
by 2.  For the Gram matrix of a lattice, this means `⟨v, v⟩ ∈ 2ℤ` for every
basis vector, hence for every lattice vector (by bilinearity and integrality). -/
def IsEvenGram {n : Type*} (G : Matrix n n ℤ) : Prop :=
  ∀ i, 2 ∣ G i i

/-- A Gram matrix is *unimodular* if its determinant is `±1`. -/
def IsUnimodularGram {n : Type*} [Fintype n] [DecidableEq n]
    (G : Matrix n n ℤ) : Prop :=
  G.det = 1 ∨ G.det = -1

/-- Casting an integer matrix to a real matrix. -/
noncomputable def intMatToReal {n : Type*} [Fintype n] [DecidableEq n]
    (G : Matrix n n ℤ) : Matrix n n ℝ :=
  G.map (Int.castRingHom ℝ)

/-- A symmetric integer matrix is *positive definite over ℝ* if the cast
to `ℝ` is positive definite in the sense of `Matrix.PosDef`. -/
def IsPosDef_over_reals {n : Type*} [Fintype n] [DecidableEq n]
    (G : Matrix n n ℤ) : Prop :=
  (intMatToReal G).PosDef

/-- Two integer matrices are *ℤ-congruent* if there exists an invertible
integer matrix `U` (i.e., `det U = ±1`) such that `Uᵀ G₁ U = G₂`.
This is the integer analogue of GL-congruence and encodes lattice isometry. -/
def IntCongruent {n : Type*} [Fintype n] [DecidableEq n]
    (G₁ G₂ : Matrix n n ℤ) : Prop :=
  ∃ U : Matrix n n ℤ, IsUnit U.det ∧ U.transpose * G₁ * U = G₂

/-! ## The E8 Gram matrix

For a simply-laced root system, the Cartan matrix coincides with the Gram
matrix of the simple roots.  That is, if `α₁, …, α₈` are simple roots of E8,
then `⟨αᵢ, αⱼ⟩ = A_{ij}` where `A` is the Cartan matrix.  We therefore
take `e8Cartan` as our reference Gram matrix. -/

/-- The E8 Gram matrix (= E8 Cartan matrix in the simply-laced case). -/
def e8Gram : Matrix (Fin 8) (Fin 8) ℤ := e8Cartan

/-! ## Precursor lemmas: e8Gram satisfies all hypotheses -/

/-- The E8 Gram matrix is symmetric. -/
theorem e8Gram_isSymm : e8Gram.IsSymm := by
  ext i j; fin_cases i <;> fin_cases j <;> decide

/-- The E8 Gram matrix is even: every diagonal entry is `2`. -/
theorem e8Gram_isEven : IsEvenGram e8Gram := by
  intro i; fin_cases i <;> decide

/-- The E8 Gram matrix is unimodular: `det = 1`. -/
theorem e8Gram_isUnimodular : IsUnimodularGram e8Gram :=
  Or.inl e8Cartan_det_eq_one

/-- The E8 Gram matrix has determinant exactly `1`. -/
theorem e8Gram_det_eq_one : e8Gram.det = 1 :=
  e8Cartan_det_eq_one

/-- The E8 Gram matrix is positive definite over ℝ.

Proved via an explicit LDLᵀ (Cholesky) certificate: the quadratic form
`xᵀ G x` is rewritten as a weighted sum of squares with all-positive
rational weights. See `PhysicsSM.Lie.Exceptional.E8PositiveDefinite`
for the full proof. -/
theorem e8Gram_posDef : IsPosDef_over_reals e8Gram :=
  PhysicsSM.Lie.Exceptional.E8PositiveDefinite.e8Cartan_map_posDef

/-- `IntCongruent` is reflexive: every matrix is congruent to itself. -/
theorem intCongruent_refl {n : Type*} [Fintype n] [DecidableEq n]
    (G : Matrix n n ℤ) : IntCongruent G G :=
  ⟨1, by simp [Matrix.det_one], by simp⟩

/-! ## The classification theorem (draft statement) -/

/--
**E8 even unimodular uniqueness** (rank 8 classification).

Every rank-8 positive-definite even unimodular lattice is isometric to E8.
Equivalently, any 8×8 symmetric integer Gram matrix that is even, unimodular,
and positive definite over ℝ is ℤ-congruent to the E8 Gram matrix.

### Proof plan (not yet formalized)

The standard proof (following Serre, *A Course in Arithmetic*, Ch. V, §2.2)
proceeds as follows:

1. **Existence of short vectors**: A positive-definite even unimodular lattice
   of rank 8 has minimum norm 2 (by the bound `min ≤ 2⌊n/24⌋ + 2` for even
   unimodular lattices, giving `min ≤ 2` for `n = 8`).

2. **Root system structure**: The norm-2 vectors form a root system.  For a
   rank-8 even unimodular lattice, there are exactly 240 such vectors, and
   they form a root system of type E8.  (This follows from the theta series
   being the unique normalized modular form of weight 4 for SL₂(ℤ), namely
   the Eisenstein series E₄, whose q¹ coefficient is 240.)

3. **Root lattice = full lattice**: Since the root lattice has determinant 1
   (= det of E8 Cartan matrix) and is contained in the full lattice (also
   determinant ±1), they must be equal.

4. **Conclusion**: The lattice is isometric to the E8 root lattice.

### Blockers

- Theta series and modular forms for SL₂(ℤ) are not in Mathlib.
- The classification of root systems is not in Mathlib.
- Integral quadratic form genus theory is not in Mathlib.
- The minimum-norm bound for even unimodular lattices is not in Mathlib.

### Alternative formalization routes

1. **Direct computation**: For dimension 8 specifically, one could attempt a
   case analysis / algorithm that enumerates possible Gram matrices up to
   congruence.  This is computationally feasible but would require substantial
   infrastructure for lattice reduction (LLL / Minkowski reduction).

2. **Theta series via explicit computation**: One could define theta series
   as formal power series over ℤ and prove the dimension-4 modular forms
   space is 1-dimensional by explicit computation.  This is a large project.

3. **Mass formula**: Compute the mass of the genus and show it equals
   `1 / |W(E₈)|`.  Also a large project.

### Status

This theorem is stated as a draft with `sorry`.  It is NOT on the critical
path for the manuscript, which uses explicit Cartan-matrix / root-system /
Construction-A bridges instead.
-/
theorem e8_even_unimodular_uniqueness
    (G : Matrix (Fin 8) (Fin 8) ℤ)
    (hSymm : G.IsSymm)
    (hEven : IsEvenGram G)
    (hUnimod : IsUnimodularGram G)
    (hPosDef : IsPosDef_over_reals G) :
    IntCongruent G e8Gram := by
  sorry
  -- DRAFT: Full proof blocked on theta-series / modular-forms / root-system
  -- classification infrastructure.  See proof plan above.

/-! ## Trusted precursors -/

/-- The identity matrix is NOT even (diagonal entries are 1, not divisible
by 2).  This witnesses that the standard lattice ℤⁿ is NOT an even lattice,
and serves as a sanity check for the `IsEvenGram` predicate. -/
theorem identity_not_even (n : ℕ) (hn : 0 < n) :
    ¬ IsEvenGram (1 : Matrix (Fin n) (Fin n) ℤ) := by
  intro h
  have := h ⟨0, hn⟩
  simp at this

/-- The 4-divisibility of squared norms for Construction A lattices from
doubly-even codes implies that the rescaled inner product `(1/2) · ‖v‖²`
takes even values.  Stated here as a simple arithmetic fact connecting
the Construction A evenness proof to the Gram-matrix evenness concept. -/
theorem div_four_implies_half_even (k : ℤ) (h : 4 ∣ k) :
    2 ∣ (k / 2) := by
  obtain ⟨m, rfl⟩ := h
  omega

/-- ℤ-congruence preserves determinant up to sign: if `Uᵀ G₁ U = G₂`
and `det U = ±1`, then `det G₁ = det G₂`. -/
theorem intCongruent_det_eq {n : Type*} [Fintype n] [DecidableEq n]
    {G₁ G₂ : Matrix n n ℤ} (h : IntCongruent G₁ G₂) :
    G₁.det = G₂.det := by
  obtain ⟨U, hU, hcong⟩ := h
  have := congr_arg Matrix.det hcong
  simp [Matrix.det_mul, Matrix.det_transpose] at this
  rw [Int.isUnit_iff] at hU
  rcases hU with h1 | h1 <;> simp [h1] at this <;> linarith

/-
For a symmetric ℤ-matrix G with even diagonal, the quadratic form
`v ↦ ∑ i k, v i * G i k * v k` always takes even values. This is the
key algebraic fact behind evenness being preserved by ℤ-congruence.

Proof: Write the sum as `∑ᵢ G_{ii} vᵢ² + 2 ∑_{i<k} G_{ik} vᵢ vₖ`.
The diagonal terms are even because `2 ∣ G_{ii}`, and the cross terms
have an explicit factor of 2 from pairing `(i,k)` with `(k,i)`.
-/
theorem bilin_even_of_symm_even_diag {n : Type*} [Fintype n] [DecidableEq n]
    (G : Matrix n n ℤ) (hSymm : G.IsSymm) (hEven : ∀ i, 2 ∣ G i i)
    (v : n → ℤ) : 2 ∣ ∑ i, ∑ k, v i * G i k * v k := by
  replace hSymm := congr_arg ( fun m => m.map ( fun x => x : ℤ → ZMod 2 ) ) hSymm ; simp_all +decide [ ← Matrix.ext_iff, ZMod.intCast_eq_intCast_iff ] ;
  replace hSymm := fun i j => Int.modEq_iff_dvd.mp ( hSymm i j |> Int.ModEq.symm ) ; simp_all +decide [ ← even_iff_two_dvd, parity_simps ] ;
  induction' ( Finset.univ : Finset n ) using Finset.induction <;> simp_all +decide [ Finset.sum_insert, parity_simps ];
  simp_all +decide [ Finset.sum_add_distrib, mul_assoc, mul_comm, mul_left_comm, parity_simps ];
  simp_all +decide [ Finset.sum_int_mod, Int.even_iff ];
  rw [ Finset.sum_congr rfl fun i hi => by rw [ Int.mul_emod, Int.mul_emod ] ] ; simp_all +decide [ ← even_iff_two_dvd, parity_simps ] ;
  congr! 2 ; simp +decide [ Int.even_iff.mp ( hSymm _ _ |>.2 ( hEven _ ) ), Int.mul_emod ] ;
  grind

/-- ℤ-congruence preserves the evenness predicate. -/
theorem intCongruent_preserves_even {n : Type*} [Fintype n] [DecidableEq n]
    {G₁ G₂ : Matrix n n ℤ} (h : IntCongruent G₁ G₂)
    (hSymm : G₁.IsSymm) (hEven : IsEvenGram G₁) :
    IsEvenGram G₂ := by
  obtain ⟨U, _, hcong⟩ := h
  intro j
  rw [← hcong]
  show 2 ∣ (U.transpose * G₁ * U) j j
  have : (U.transpose * G₁ * U) j j = ∑ i, ∑ k, U i j * G₁ i k * U k j := by
    simp [Matrix.mul_apply, Matrix.transpose_apply]
    congr 1; ext i; rw [Finset.sum_mul]; congr 1; ext k
    have hsym : G₁ k i = G₁ i k := by
      have h := congr_fun (congr_fun hSymm.eq k) i
      simp [Matrix.transpose_apply] at h; exact h.symm
    rw [hsym]; ring
  rw [this]
  exact bilin_even_of_symm_even_diag G₁ hSymm hEven (fun i => U i j)

/-- ℤ-congruence preserves unimodularity. -/
theorem intCongruent_preserves_unimodular {n : Type*} [Fintype n] [DecidableEq n]
    {G₁ G₂ : Matrix n n ℤ} (h : IntCongruent G₁ G₂)
    (hU : IsUnimodularGram G₁) :
    IsUnimodularGram G₂ := by
  rw [IsUnimodularGram]
  rw [← intCongruent_det_eq h]
  exact hU

/-! ## Summary and handoff

### What this file provides

1. **Clean predicates**: `IsEvenGram`, `IsUnimodularGram`, `IsPosDef_over_reals`,
   `IntCongruent` — reusable definitions for integral lattice theory.

2. **Draft theorem statement**: `e8_even_unimodular_uniqueness` with precise
   types and documented proof plan.

3. **Precursor lemmas** (fully proved):
   - `e8Gram_isSymm`: the E8 Gram matrix is symmetric.
   - `e8Gram_isEven`: the E8 Gram matrix is even.
   - `e8Gram_isUnimodular`: the E8 Gram matrix has determinant 1.
   - `identity_not_even`: ℤⁿ with standard inner product is not even.
   - `div_four_implies_half_even`: arithmetic bridge to Construction A.
   - `intCongruent_det_eq`: congruence preserves determinant.
   - `intCongruent_preserves_unimodular`: congruence preserves unimodularity.
   - `intCongruent_refl`: congruence is reflexive.

4. **Blocker list**: precise identification of missing Mathlib infrastructure.

5. **API map**: mapping mathematical concepts to Mathlib definitions.

### What blocks full formalization

| Concept | Mathlib status | Difficulty |
|---------|---------------|------------|
| Theta series of lattices | Missing | High |
| Modular forms for SL₂(ℤ) | Missing | Very high |
| Eisenstein series E₄ | Missing | High |
| Root system classification | Missing | Very high |
| Mass formula | Missing | Very high |
| Integral quad. form genera | Missing | High |
| Sylvester criterion for PosDef | Available but not connected | Medium |

### Recommended next steps (if this route is pursued)

1. Prove `e8Gram_posDef` via Sylvester's criterion or eigenvalue bounds.
2. Develop theta series as formal power series (no analytic theory needed
   for the uniqueness argument).
3. Prove the space of weight-4 modular forms for SL₂(ℤ) is 1-dimensional.
4. Use this to show any rank-8 even unimodular lattice has 240 norm-2 vectors.
5. Show these 240 vectors form an E8 root system and generate the lattice.

Each of these is a substantial project.  The manuscript does NOT depend on
this route.
-/

end PhysicsSM.Draft.E8EvenUnimodularUniqueness
