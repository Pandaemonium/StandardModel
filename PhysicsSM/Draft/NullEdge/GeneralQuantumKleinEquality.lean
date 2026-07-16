import PhysicsSM.Draft.NullEdge.GeneralQuantumKlein
import PhysicsSM.Draft.NullEdge.ScalarKleinEqualityCore

/-!
# Equality in the general noncommuting quantum Klein inequality

Focused Aristotle target.  `GeneralQuantumKlein.qKlein_nonneg` proves
nonnegativity of the CFC-free finite-dimensional quantum relative entropy.
`ScalarKleinEqualityCore.scalar_klein_eq` now proves the strict scalar
doubly-stochastic equality condition.  This target reconstructs the matrix
equality case, including degenerate eigenspaces.

The key intermediate statement is basis-independent: equality forces the
two-basis overlap to intertwine the two eigenvalue diagonals.  Combined with
the two spectral decompositions, that gives `rho = sigma` without requiring
the overlap itself to be a permutation inside degenerate eigenspaces.

Provenance: theorem statements and definitions were prepared locally; Aristotle
project `293198fd-5aa5-4336-b589-9aa8c1893774` supplied the proofs, which were
replayed under the repository's pinned Lean toolchain before integration.
-/

noncomputable section

open Matrix
open scoped BigOperators ComplexOrder

namespace PhysicsSM.Draft.NullEdge.GeneralQuantumKleinEquality

open GeneralQuantumKlein
open ScalarKleinEqualityCore

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Change-of-eigenbasis matrix from `rho` coordinates to `sigma`
coordinates. -/
def overlap (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian) :
    Matrix n n Complex :=
  (hrho.eigenvectorUnitary : Matrix n n Complex)ᴴ *
    (hsigma.eigenvectorUnitary : Matrix n n Complex)

/-- Vanishing relative entropy forces the overlap to connect only equal
eigenvalues, equivalently to intertwine the two spectral diagonals. -/
theorem overlap_intertwines_of_qRelEntropy_eq_zero
    (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoPsd : rho.PosSemidef) (hsigmaPd : sigma.PosDef)
    (hrhoTrace : rho.trace = 1) (hsigmaTrace : sigma.trace = 1)
    (hzero : qRelEntropy rho sigma hrho hsigma = 0) :
    diagonal (fun i => (hrho.eigenvalues i : Complex)) *
        overlap rho sigma hrho hsigma =
      overlap rho sigma hrho hsigma *
        diagonal (fun j => (hsigma.eigenvalues j : Complex)) := by
  -- Rewrite the vanishing relative entropy as the scalar Klein expression in
  -- the eigenvalues `lam`, `mu` and the doubly-stochastic weights
  -- `p i j = |W i j|²`, with `W = Uᴴ V` the overlap of the two eigenbases.
  have hsplit : qRelEntropy rho sigma hrho hsigma
      = (rho * logHermitian rho hrho).trace.re
        - (rho * logHermitian sigma hsigma).trace.re := by
    unfold qRelEntropy
    rw [Matrix.mul_sub, Matrix.trace_sub, Complex.sub_re]
  rw [hsplit, entropy_trace_eq_sum rho hrho,
      cross_trace_eq_sum rho sigma hrho hsigma] at hzero
  have hWmem := overlap_mem_unitaryGroup rho sigma hrho hsigma
  -- The scalar equality core: every nonzero overlap weight joins equal
  -- eigenvalues, i.e. `|W i j|² ≠ 0 → mu j = lam i`.
  have hkey := scalar_klein_eq hrho.eigenvalues hsigma.eigenvalues
    (fun i j => Complex.normSq (((hrho.eigenvectorUnitary : Matrix n n ℂ)ᴴ *
      (hsigma.eigenvectorUnitary : Matrix n n ℂ)) i j))
    (fun i => hrhoPsd.eigenvalues_nonneg i)
    (fun j => hsigmaPd.eigenvalues_pos j)
    (fun _ _ => Complex.normSq_nonneg _)
    (fun i => unitary_normSq_row_sum _ hWmem i)
    (fun j => unitary_normSq_col_sum _ hWmem j)
    (by have h := hrho.trace_eq_sum_eigenvalues; rw [hrhoTrace] at h
        have := congrArg Complex.re h.symm; simpa using this)
    (by have h := hsigma.trace_eq_sum_eigenvalues; rw [hsigmaTrace] at h
        have := congrArg Complex.re h.symm; simpa using this)
    hzero
  -- Entrywise: `(Dl W) i j = lam i * W i j` and `(W Dm) i j = W i j * mu j`.
  -- Where `W i j = 0` both vanish; elsewhere `hkey` gives `lam i = mu j`.
  ext i j
  rw [Matrix.diagonal_mul, Matrix.mul_diagonal]
  by_cases h : overlap rho sigma hrho hsigma i j = 0
  · rw [show overlap rho sigma hrho hsigma i j
          = ((hrho.eigenvectorUnitary : Matrix n n ℂ)ᴴ *
              (hsigma.eigenvectorUnitary : Matrix n n ℂ)) i j from rfl] at h ⊢
    rw [h]; ring
  · have hne : Complex.normSq (((hrho.eigenvectorUnitary : Matrix n n ℂ)ᴴ *
        (hsigma.eigenvectorUnitary : Matrix n n ℂ)) i j) ≠ 0 :=
      fun hc => h (Complex.normSq_eq_zero.mp hc)
    have hcast : (hsigma.eigenvalues j : ℂ) = (hrho.eigenvalues i : ℂ) := by
      exact_mod_cast (hkey i j hne)
    rw [show overlap rho sigma hrho hsigma i j
          = ((hrho.eigenvectorUnitary : Matrix n n ℂ)ᴴ *
              (hsigma.eigenvectorUnitary : Matrix n n ℂ)) i j from rfl, hcast]
    ring

/-- **General quantum Klein equality capstone.** For an arbitrary finite
density matrix and a positive-definite reference density matrix, quantum
relative entropy vanishes exactly when the states coincide. -/
theorem qKlein_eq_zero_iff
    (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoPsd : rho.PosSemidef) (hsigmaPd : sigma.PosDef)
    (hrhoTrace : rho.trace = 1) (hsigmaTrace : sigma.trace = 1) :
    qRelEntropy rho sigma hrho hsigma = 0 <-> rho = sigma := by
  constructor
  · -- Forward direction: reconstruct `rho = sigma` from the intertwining.
    intro hzero
    have hint := overlap_intertwines_of_qRelEntropy_eq_zero rho sigma hrho hsigma
      hrhoPsd hsigmaPd hrhoTrace hsigmaTrace hzero
    -- Abbreviations for the two eigenbases and eigenvalue diagonals.
    set U := (hrho.eigenvectorUnitary : Matrix n n ℂ) with hU
    set V := (hsigma.eigenvectorUnitary : Matrix n n ℂ) with hV
    set Dl := diagonal (fun i => (hrho.eigenvalues i : ℂ)) with hDl
    set Dm := diagonal (fun j => (hsigma.eigenvalues j : ℂ)) with hDm
    set W := overlap rho sigma hrho hsigma with hWdef
    -- Unitarity facts: `U Uᴴ = 1` and `W Wᴴ = 1`.
    have hUUh : U * Uᴴ = 1 := by
      have h := (hrho.eigenvectorUnitary).2
      rw [Matrix.mem_unitaryGroup_iff, Matrix.star_eq_conjTranspose] at h
      exact h
    have hVWmem := overlap_mem_unitaryGroup rho sigma hrho hsigma
    have hWWh : W * Wᴴ = 1 := by
      have h := hVWmem
      rw [Matrix.mem_unitaryGroup_iff, Matrix.star_eq_conjTranspose] at h
      exact h
    -- Spectral decompositions `rho = U Dl Uᴴ`, `sigma = V Dm Vᴴ`.
    have hrho_eq : rho = U * Dl * Uᴴ := by
      conv_lhs => rw [hrho.spectral_theorem, Unitary.conjStarAlgAut_apply]
      rw [Matrix.star_eq_conjTranspose]; rfl
    have hsigma_eq : sigma = V * Dm * Vᴴ := by
      conv_lhs => rw [hsigma.spectral_theorem, Unitary.conjStarAlgAut_apply]
      rw [Matrix.star_eq_conjTranspose]; rfl
    -- `V = U W` since `W = Uᴴ V` and `U Uᴴ = 1`.
    have hVUW : V = U * W := by
      rw [hWdef, overlap, ← Matrix.mul_assoc, hUUh, Matrix.one_mul]
    -- `sigma = U (W Dm) Wᴴ Uᴴ = U (Dl W) Wᴴ Uᴴ = U Dl Uᴴ = rho`.
    rw [hrho_eq, hsigma_eq, hVUW, Matrix.conjTranspose_mul]
    rw [show (U * W) * Dm * (Wᴴ * Uᴴ) = U * (W * Dm) * (Wᴴ * Uᴴ) by
      rw [Matrix.mul_assoc U W Dm]]
    rw [← hint]
    simp only [Matrix.mul_assoc]
    rw [← Matrix.mul_assoc W Wᴴ Uᴴ, hWWh, Matrix.one_mul]
  · -- Backward direction: equal states have vanishing relative entropy.
    intro h
    subst h
    unfold qRelEntropy
    rw [show logHermitian rho hrho = logHermitian rho hsigma from rfl, sub_self,
      Matrix.mul_zero, Matrix.trace_zero, Complex.zero_re]

/-- Strictness control: distinct admissible states have strictly positive
quantum relative entropy. -/
theorem qKlein_pos_of_ne
    (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoPsd : rho.PosSemidef) (hsigmaPd : sigma.PosDef)
    (hrhoTrace : rho.trace = 1) (hsigmaTrace : sigma.trace = 1)
    (hne : rho != sigma) :
    0 < qRelEntropy rho sigma hrho hsigma := by
  -- Nonnegativity plus the equality iff gives strict positivity.
  have hne' : rho ≠ sigma := by simpa using hne
  have hnonneg := qKlein_nonneg rho sigma hrho hsigma hrhoPsd hsigmaPd hrhoTrace hsigmaTrace
  have hiff := qKlein_eq_zero_iff rho sigma hrho hsigma hrhoPsd hsigmaPd hrhoTrace hsigmaTrace
  refine lt_of_le_of_ne hnonneg (fun hz => hne' (hiff.mp hz.symm))

/-! ## Axiom-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GeneralQuantumKleinEquality.overlap_intertwines_of_qRelEntropy_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms overlap_intertwines_of_qRelEntropy_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.GeneralQuantumKleinEquality.qKlein_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms qKlein_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.GeneralQuantumKleinEquality.qKlein_pos_of_ne' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms qKlein_pos_of_ne

end PhysicsSM.Draft.NullEdge.GeneralQuantumKleinEquality
