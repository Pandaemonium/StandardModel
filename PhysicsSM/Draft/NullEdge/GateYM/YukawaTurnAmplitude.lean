import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure

/-!
# Yukawa turn amplitude at operator grade for a concrete finite flavor model

"Mass = coin-turn amplitude" promoted from the single-flavor spin algebra of
`ChiralMassStructure.lean` to a genuine `n`-flavor model with a Yukawa/mass
matrix `Y : Matrix (Fin n) (Fin n) ℂ`.

## Setup

The physical Hilbert space of one Wilson-Dirac vertex is `flavor ⊗ spin`, indexed
by `Fin n × Fin 4`. Chirality is measured by the involution

    Γ5F = 1_flavor ⊗ₖ γ5,      Γ5F * Γ5F = 1,

which acts on the spin factor only. As in the single-flavor case we split any
flavor-graded operator `A` into two chirality channels:

    chiralOddF  A = (A - Γ5F A Γ5F) / 2   (chirality-PRESERVING / null transport)
    chiralEvenF A = (A + Γ5F A Γ5F) / 2   (chirality-MIXING / the "turn" / mass)

The flavor-graded vertex is built from
* the **Yukawa mass term** `Y ⊗ₖ 1_spin` (`flavorMassTerm`): a chirality flip in
  spin, carrying the flavor matrix `Y`; it maps L ↔ R with amplitude `Y`;
* the **null-transport generator** `1_flavor ⊗ₖ γ μ` (`flavorTransport`): flavor-
  diagonal, chirality-preserving.

We package two vertices:
* `flavorVertex Y μ = Y ⊗ₖ 1 - 1 ⊗ₖ γ μ` — the **physical** (regulator-free)
  mass vertex, the `n`-flavor analogue of `m • 1 - γ μ`;
* `flavorWilsonVertex Y μ = Y ⊗ₖ 1 + 1 ⊗ₖ (1 - γ μ)` — the full Wilson-Dirac
  vertex, the exact `n`-flavor analogue of `ChiralMassStructure.massVertex`
  (`m • 1 + (1 - γ μ)`), with the Wilson scalar regulator `1 ⊗ₖ 1` included.

## Results

* `turnAmplitude Y μ := chiralEvenF (flavorVertex Y μ) = Y ⊗ₖ 1`
  (`turnAmplitude_eq`): the turn amplitude is exactly the Yukawa mass term.
* `turnAmplitude_eq_zero_iff` : `turnAmplitude Y μ = 0 ↔ Y = 0`
  — **no turn ⇔ no mass**, the headline generalization.
* `chiralOddF_flavorVertex` : `chiralOddF (flavorVertex Y μ) = - (1 ⊗ₖ γ μ)`
  — the chirality-odd part is pure flavor-transport, **independent of `Y`**.
* Wilson variant: `chiralEvenF_flavorWilsonVertex` gives `(Y + 1) ⊗ₖ 1` and
  `chiralEvenF_flavorWilsonVertex_eq_zero_iff` gives `Y = -1`, the faithful
  matrix generalization of `ChiralMassStructure.chiralEven_massVertex_eq_zero_iff`
  (`m = -1`): the Wilson regulator shifts the vanishing locus off `Y = 0`.
* Diagonalization (point 3): for `Y = diagonal d` the turn amplitude is
  `diagonal (fun p => d p.1)` (`turnAmplitude_diagonal`), so the physical masses
  `d i` sit directly on the diagonal, each repeated over the 4 spin components;
  `turnAmplitude_diagonal_normal` records that it is a normal (indeed diagonal)
  operator whose eigenvalue-moduli `‖d i‖` are the singular values / physical
  masses.

## Claim discipline

Claim label: **finite operator identity** (pure `flavor ⊗ spin` matrix algebra).
This is NOT a dynamical derivation of the Yukawa couplings: `Y` is an arbitrary
input matrix, and the theorems only expose where its content lands in the
chirality grading. Placeholder-free and compiler-eval-free.
-/

open scoped Matrix Kronecker
open Matrix

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace YukawaTurnAmplitude

open PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma
open PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure

variable {n : ℕ}

/-- Right-factor distribution of the Kronecker product over subtraction. -/
theorem kron_sub (A : Matrix (Fin n) (Fin n) ℂ) (B C : Matrix (Fin 4) (Fin 4) ℂ) :
    A ⊗ₖ (B - C) = A ⊗ₖ B - A ⊗ₖ C := by
  ext ⟨i, s⟩ ⟨j, t⟩
  simp [Matrix.kroneckerMap_apply, Matrix.sub_apply, mul_sub]

/-- Right-factor distribution of the Kronecker product over negation. -/
theorem kron_neg (A : Matrix (Fin n) (Fin n) ℂ) (B : Matrix (Fin 4) (Fin 4) ℂ) :
    A ⊗ₖ (-B) = -(A ⊗ₖ B) := by
  ext ⟨i, s⟩ ⟨j, t⟩
  simp [Matrix.kroneckerMap_apply, Matrix.neg_apply, mul_neg]

/-- The chirality involution on `flavor ⊗ spin`: identity on flavor, `γ5` on
spin. -/
noncomputable def Γ5F (n : ℕ) : Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ :=
  (1 : Matrix (Fin n) (Fin n) ℂ) ⊗ₖ γ5

/-- `Γ5F` is an involution: `Γ5F * Γ5F = 1`. -/
theorem Γ5F_mul_Γ5F : Γ5F n * Γ5F n = 1 := by
  unfold Γ5F
  rw [← Matrix.mul_kronecker_mul, mul_one, γ5_sq, Matrix.one_kronecker_one]

/-- Conjugating a pure tensor by `Γ5F` acts on the spin factor only:
`Γ5F (A ⊗ₖ B) Γ5F = A ⊗ₖ (γ5 B γ5)`. -/
theorem Γ5F_conj_kronecker (A : Matrix (Fin n) (Fin n) ℂ) (B : Matrix (Fin 4) (Fin 4) ℂ) :
    Γ5F n * (A ⊗ₖ B) * Γ5F n = A ⊗ₖ (γ5 * B * γ5) := by
  unfold Γ5F
  rw [← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul, one_mul, mul_one]

/-- The chirality-odd (chirality-preserving / null-transport) channel. -/
noncomputable def chiralOddF (A : Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ) :
    Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ :=
  (1 / 2 : ℂ) • (A - Γ5F n * A * Γ5F n)

/-- The chirality-even (chirality-mixing / "turn" / mass) channel. -/
noncomputable def chiralEvenF (A : Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ) :
    Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ :=
  (1 / 2 : ℂ) • (A + Γ5F n * A * Γ5F n)

/-- The two channels reconstruct the operator. -/
theorem chiralOddF_add_chiralEvenF (A : Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ) :
    chiralOddF A + chiralEvenF A = A := by
  unfold chiralOddF chiralEvenF
  module

/-- The Yukawa mass term `Y ⊗ₖ 1_spin`: a chirality flip in spin carrying the
flavor matrix `Y`. -/
noncomputable def flavorMassTerm (Y : Matrix (Fin n) (Fin n) ℂ) :
    Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ :=
  Y ⊗ₖ (1 : Matrix (Fin 4) (Fin 4) ℂ)

/-- The null-transport generator `1_flavor ⊗ₖ γ μ`: flavor-diagonal, chirality-
preserving. -/
noncomputable def flavorTransport (n : ℕ) (μ : Fin 4) :
    Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ :=
  (1 : Matrix (Fin n) (Fin n) ℂ) ⊗ₖ γ μ

/-- The **physical** (regulator-free) flavor mass vertex `Y ⊗ₖ 1 - 1 ⊗ₖ γ μ`,
the `n`-flavor analogue of `m • 1 - γ μ`. -/
noncomputable def flavorVertex (Y : Matrix (Fin n) (Fin n) ℂ) (μ : Fin 4) :
    Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ :=
  flavorMassTerm Y - flavorTransport n μ

/-- The full Wilson-Dirac flavor vertex `Y ⊗ₖ 1 + 1 ⊗ₖ (1 - γ μ)`, the exact
`n`-flavor analogue of `ChiralMassStructure.massVertex m μ = m • 1 + (1 - γ μ)`
(the Yukawa mass term plus the forward Wilson projector). -/
noncomputable def flavorWilsonVertex (Y : Matrix (Fin n) (Fin n) ℂ) (μ : Fin 4) :
    Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ :=
  flavorMassTerm Y + (1 : Matrix (Fin n) (Fin n) ℂ) ⊗ₖ (1 - γ μ)

/-- Conjugating the Yukawa mass term by `Γ5F` is trivial: it is chirality-even.
`Γ5F (Y ⊗ₖ 1) Γ5F = Y ⊗ₖ 1`. -/
theorem Γ5F_conj_flavorMassTerm (Y : Matrix (Fin n) (Fin n) ℂ) :
    Γ5F n * flavorMassTerm Y * Γ5F n = flavorMassTerm Y := by
  unfold flavorMassTerm
  rw [Γ5F_conj_kronecker, mul_one, γ5_sq]

/-- Conjugating the transport generator by `Γ5F` flips its sign: it is
chirality-odd. `Γ5F (1 ⊗ₖ γ μ) Γ5F = - (1 ⊗ₖ γ μ)`. -/
theorem Γ5F_conj_flavorTransport (μ : Fin 4) :
    Γ5F n * flavorTransport n μ * Γ5F n = - flavorTransport n μ := by
  unfold flavorTransport
  rw [Γ5F_conj_kronecker, γ5_conj_γ, kron_neg]

/-- The Yukawa mass term is purely chirality-even. -/
theorem chiralEvenF_flavorMassTerm (Y : Matrix (Fin n) (Fin n) ℂ) :
    chiralEvenF (flavorMassTerm Y) = flavorMassTerm Y := by
  unfold chiralEvenF
  rw [Γ5F_conj_flavorMassTerm]
  module

/-- The Yukawa mass term has no chirality-odd (transport) component. -/
theorem chiralOddF_flavorMassTerm (Y : Matrix (Fin n) (Fin n) ℂ) :
    chiralOddF (flavorMassTerm Y) = 0 := by
  unfold chiralOddF
  rw [Γ5F_conj_flavorMassTerm]
  module

/-- The transport generator is purely chirality-odd. -/
theorem chiralOddF_flavorTransport (μ : Fin 4) :
    chiralOddF (flavorTransport n μ) = flavorTransport n μ := by
  unfold chiralOddF
  rw [Γ5F_conj_flavorTransport]
  module

/-- The transport generator has no chirality-even (mass) component. -/
theorem chiralEvenF_flavorTransport (μ : Fin 4) :
    chiralEvenF (flavorTransport n μ) = 0 := by
  unfold chiralEvenF
  rw [Γ5F_conj_flavorTransport]
  module

/-- **The turn amplitude**: the chirality-even ("turn" / L ↔ R) part of the
physical flavor mass vertex. -/
noncomputable def turnAmplitude (Y : Matrix (Fin n) (Fin n) ℂ) (μ : Fin 4) :
    Matrix (Fin n × Fin 4) (Fin n × Fin 4) ℂ :=
  chiralEvenF (flavorVertex Y μ)

/-- **HEADLINE**: the turn amplitude is exactly the Yukawa mass term `Y ⊗ₖ 1`.
The transport part drops out of the chirality-even channel. -/
theorem turnAmplitude_eq (Y : Matrix (Fin n) (Fin n) ℂ) (μ : Fin 4) :
    turnAmplitude Y μ = flavorMassTerm Y := by
  unfold turnAmplitude flavorVertex chiralEvenF
  rw [mul_sub, sub_mul, Γ5F_conj_flavorMassTerm, Γ5F_conj_flavorTransport]
  unfold flavorMassTerm flavorTransport
  module

/-- **HEADLINE (chirality-odd / transport channel)**: the chirality-preserving
part of the physical flavor vertex is exactly `- (1 ⊗ₖ γ μ)`, the pure null-
transport generator — **independent of the Yukawa matrix `Y`**. -/
theorem chiralOddF_flavorVertex (Y : Matrix (Fin n) (Fin n) ℂ) (μ : Fin 4) :
    chiralOddF (flavorVertex Y μ) = - flavorTransport n μ := by
  unfold flavorVertex chiralOddF
  rw [mul_sub, sub_mul, Γ5F_conj_flavorMassTerm, Γ5F_conj_flavorTransport]
  unfold flavorMassTerm flavorTransport
  module

/-- `Y ⊗ₖ 1_spin = 0` iff `Y = 0`: the spin identity factor is nonzero, so the
Kronecker product is faithful on the flavor factor. -/
theorem flavorMassTerm_eq_zero_iff (Y : Matrix (Fin n) (Fin n) ℂ) :
    flavorMassTerm Y = 0 ↔ Y = 0 := by
  unfold flavorMassTerm
  constructor
  · intro h
    ext i j
    have := congrFun (congrFun h (i, 0)) (j, 0)
    simpa [Matrix.kroneckerMap_apply, Matrix.one_apply] using this
  · intro h
    rw [h, Matrix.zero_kronecker]

/-- **HEADLINE: no turn ⇔ no mass.** The turn amplitude vanishes iff the Yukawa
mass matrix is zero — the `n`-flavor generalization of
`ChiralMassStructure.chiralEven_massVertex_eq_zero_iff`, with the physical
(regulator-free) vertex so the vanishing locus is exactly `Y = 0`. -/
theorem turnAmplitude_eq_zero_iff (Y : Matrix (Fin n) (Fin n) ℂ) (μ : Fin 4) :
    turnAmplitude Y μ = 0 ↔ Y = 0 := by
  rw [turnAmplitude_eq, flavorMassTerm_eq_zero_iff]

/-! ### Square-zero caution for the carrier `Q_T = phi^2` reading -/

/-- A concrete nonzero nilpotent two-flavor Yukawa matrix. -/
noncomputable def nilpotentYukawa2 : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 0, 0]

/-- The nilpotent witness is nonzero. -/
theorem nilpotentYukawa2_ne_zero : nilpotentYukawa2 ≠ 0 := by
  intro h
  have h01 := congrFun (congrFun h (0 : Fin 2)) (1 : Fin 2)
  norm_num [nilpotentYukawa2] at h01

/-- The nilpotent witness squares to zero. -/
theorem nilpotentYukawa2_sq_zero : nilpotentYukawa2 * nilpotentYukawa2 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [nilpotentYukawa2, Matrix.mul_apply, Fin.sum_univ_two]

/-- A nonzero turn amplitude can have square zero.

This is a finite warning for the carrier `Q_T = phi^2` bridge: the proven
turn-amplitude identity says `turnAmplitude Y μ = 0 ↔ Y = 0`, but the stronger
claim `(turnAmplitude Y μ)^2 = 0 ↔ Y = 0` is false without an additional
nilpotent-free/normality hypothesis on the Yukawa block. -/
theorem turnAmplitude_square_zero_counterexample (μ : Fin 4) :
    turnAmplitude nilpotentYukawa2 μ ≠ 0 ∧
      turnAmplitude nilpotentYukawa2 μ * turnAmplitude nilpotentYukawa2 μ = 0 := by
  constructor
  · intro h
    exact nilpotentYukawa2_ne_zero ((turnAmplitude_eq_zero_iff nilpotentYukawa2 μ).mp h)
  · rw [turnAmplitude_eq]
    unfold flavorMassTerm
    rw [← Matrix.mul_kronecker_mul, nilpotentYukawa2_sq_zero, Matrix.zero_kronecker]

/-! ### Wilson variant: the faithful generalization of the single-flavor
`chiralEven_massVertex_eq_zero_iff` (`m = -1`) -/

/-- The chirality-even part of the full Wilson-Dirac flavor vertex is
`(Y + 1) ⊗ₖ 1`: the Yukawa mass term and the Wilson scalar regulator merge into
one chirality-even coefficient, generalizing `(m + 1) • 1`. -/
theorem chiralEvenF_flavorWilsonVertex (Y : Matrix (Fin n) (Fin n) ℂ) (μ : Fin 4) :
    chiralEvenF (flavorWilsonVertex Y μ) =
      (Y + 1) ⊗ₖ (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  unfold flavorWilsonVertex chiralEvenF flavorMassTerm
  have hconj : Γ5F n * ((Y ⊗ₖ (1 : Matrix (Fin 4) (Fin 4) ℂ))
      + (1 : Matrix (Fin n) (Fin n) ℂ) ⊗ₖ (1 - γ μ)) * Γ5F n
      = (Y ⊗ₖ (1 : Matrix (Fin 4) (Fin 4) ℂ))
        + (1 : Matrix (Fin n) (Fin n) ℂ) ⊗ₖ (1 + γ μ) := by
    rw [mul_add, add_mul, Γ5F_conj_kronecker, Γ5F_conj_kronecker, mul_one, γ5_sq,
      mul_sub, sub_mul, γ5_conj_one, γ5_conj_γ, sub_neg_eq_add]
  rw [hconj, Matrix.add_kronecker, Matrix.one_kronecker_one,
    kron_sub, Matrix.kronecker_add, Matrix.one_kronecker_one]
  module

/-- The chirality-odd part of the full Wilson-Dirac flavor vertex is
`- (1 ⊗ₖ γ μ)`, still independent of `Y`. -/
theorem chiralOddF_flavorWilsonVertex (Y : Matrix (Fin n) (Fin n) ℂ) (μ : Fin 4) :
    chiralOddF (flavorWilsonVertex Y μ) = - flavorTransport n μ := by
  unfold flavorWilsonVertex chiralOddF flavorMassTerm flavorTransport
  have hconj : Γ5F n * ((Y ⊗ₖ (1 : Matrix (Fin 4) (Fin 4) ℂ))
      + (1 : Matrix (Fin n) (Fin n) ℂ) ⊗ₖ (1 - γ μ)) * Γ5F n
      = (Y ⊗ₖ (1 : Matrix (Fin 4) (Fin 4) ℂ))
        + (1 : Matrix (Fin n) (Fin n) ℂ) ⊗ₖ (1 + γ μ) := by
    rw [mul_add, add_mul, Γ5F_conj_kronecker, Γ5F_conj_kronecker, mul_one, γ5_sq,
      mul_sub, sub_mul, γ5_conj_one, γ5_conj_γ, sub_neg_eq_add]
  rw [hconj, kron_sub, Matrix.kronecker_add]
  module

/-- **The Wilson-vertex vanishing locus is `Y = -1`**, the faithful matrix
generalization of `ChiralMassStructure.chiralEven_massVertex_eq_zero_iff`
(`m = -1`): the `m`-independent Wilson regulator `1 ⊗ₖ 1` shifts the turn-channel
zero off `Y = 0`. There is no `Y` at which both the transport-flip and the
regulator vanish — the finite shadow of the Nielsen–Ninomiya obstruction. -/
theorem chiralEvenF_flavorWilsonVertex_eq_zero_iff (Y : Matrix (Fin n) (Fin n) ℂ)
    (μ : Fin 4) :
    chiralEvenF (flavorWilsonVertex Y μ) = 0 ↔ Y = -1 := by
  rw [chiralEvenF_flavorWilsonVertex]
  rw [show ((Y + 1) ⊗ₖ (1 : Matrix (Fin 4) (Fin 4) ℂ))
      = flavorMassTerm (Y + 1) from rfl, flavorMassTerm_eq_zero_iff]
  constructor
  · intro h; exact eq_neg_of_add_eq_zero_left h
  · intro h; rw [h, neg_add_cancel]

/-! ### Point 3: diagonalization — the turn amplitudes are the physical masses -/

/-- For a diagonal Yukawa matrix `Y = diagonal d`, the turn amplitude is the
diagonal operator `diagonal (fun p => d p.1)`: the physical masses `d i` sit
directly on the diagonal, each repeated over the 4 spin components. -/
theorem turnAmplitude_diagonal (d : Fin n → ℂ) (μ : Fin 4) :
    turnAmplitude (Matrix.diagonal d) μ =
      Matrix.diagonal (fun p : Fin n × Fin 4 => d p.1) := by
  rw [turnAmplitude_eq]
  unfold flavorMassTerm
  ext ⟨i, s⟩ ⟨j, t⟩
  simp only [Matrix.kroneckerMap_apply, Matrix.diagonal, Matrix.of_apply,
    Matrix.one_apply, Prod.mk.injEq]
  by_cases hij : i = j
  · by_cases hst : s = t
    · subst hij; subst hst; simp
    · simp [hst, hij]
  · simp [hij]

/-- In a diagonal mass basis, the square-zero turn-amplitude test is faithful.

This is the positive counterpart to `turnAmplitude_square_zero_counterexample`:
arbitrary Yukawa matrices may contain nilpotent traps, but diagonal mass data has
no such trap, so `Q_T = phi^2` can be read as a zero test on the diagonal
entries. -/
theorem turnAmplitude_diagonal_sq_zero_iff_entries_zero (d : Fin n → ℂ) (μ : Fin 4) :
    turnAmplitude (Matrix.diagonal d) μ * turnAmplitude (Matrix.diagonal d) μ = 0 ↔
      ∀ i, d i = 0 := by
  constructor
  · intro h i
    have hdiag :
        Matrix.diagonal (fun p : Fin n × Fin 4 => d p.1) *
            Matrix.diagonal (fun p : Fin n × Fin 4 => d p.1) = 0 := by
      simpa [turnAmplitude_diagonal] using h
    have hentry := congrFun (congrFun hdiag (i, 0)) (i, 0)
    have hsquare : d i * d i = 0 := by
      simpa [Matrix.diagonal_mul_diagonal] using hentry
    exact (mul_eq_zero.mp hsquare).elim id id
  · intro hd
    rw [turnAmplitude_diagonal, Matrix.diagonal_mul_diagonal]
    ext p q
    by_cases hpq : p = q
    · subst q
      simp [hd p.1]
    · simp [Matrix.diagonal, hpq]

/-- The diagonal turn amplitude is a normal operator (it is diagonal, hence
commutes with its conjugate transpose). Its eigenvalues are the diagonal entries
`d i` (each of multiplicity 4), so its eigenvalue-moduli / singular values are
the physical masses `‖d i‖`. -/
theorem turnAmplitude_diagonal_normal (d : Fin n → ℂ) (μ : Fin 4) :
    (turnAmplitude (Matrix.diagonal d) μ) * (turnAmplitude (Matrix.diagonal d) μ)ᴴ =
      (turnAmplitude (Matrix.diagonal d) μ)ᴴ * (turnAmplitude (Matrix.diagonal d) μ) := by
  rw [turnAmplitude_diagonal, Matrix.diagonal_conjTranspose, Matrix.diagonal_mul_diagonal,
    Matrix.diagonal_mul_diagonal]
  congr 1
  ext p
  exact mul_comm _ _

end YukawaTurnAmplitude
end PhysicsSM.Draft.NullEdge.GateYM
