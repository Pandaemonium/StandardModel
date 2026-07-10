/-
# S1-CC: the physical-sector b-eigenbasis EXISTENCE lemma (the last MEMO piece)

The closure Krein form on the physical Gauss sector `V'/N = ker Q_G / range Q_G`
is now proved **balanced** for compression by *any* `b`-eigenvector family
(`S1CCGeneralReduction.compression_balanced_eigbasis`, already proved in this
package, no `sorry`).  The single remaining gap in the S1-CC central-crux
resolution is an **existence** fact: that such a `b`-eigenbasis of the physical
sector actually exists.

## The mathematics (and a key collapse)

Setup on a finite carrier `ι`:

* `M : Matrix ι ι ℂ` Hermitian — the closure Krein form `J Q_C`.
* `b = diagonal d`, a `±1` grading (`∀ i, d i = 1 ∨ d i = -1`), the closure
  bivector `σz ⊗ 1`, with `b * M * b = -M` (anticonjugation).
* `Q_G : Matrix ι ι ℂ` Hermitian, BRST-nilpotent (`Q_G * Q_G = 0`), and
  **commuting with the grading** (`b * Q_G = Q_G * b`).

A crucial (and, in the standard positive-definite inner product, unavoidable)
consequence of the two hypotheses `Q_G` is Hermitian and `Q_G * Q_G = 0` is that
**`Q_G = 0`**.  Indeed a Hermitian matrix `A` satisfies `Aᴴ = A`, so
`A * A = 0` gives `Aᴴ * A = 0`, and `Matrix.conjTranspose_mul_self_eq_zero`
forces `A = 0` (a Hermitian matrix is unitarily diagonalizable with real
eigenvalues, and nilpotency kills all of them).  This is the statement, over the
*definite* inner product `Pᴴ P`, that a genuinely self-adjoint BRST charge must
vanish — the physical BRST charge is self-adjoint only for the *indefinite*
Krein form, not for the definite one used to define orthonormality here.

Hence, under exactly the stated hypotheses, `range Q_G = 0`, `ker Q_G` is the
whole carrier, and the physical sector `V'/N = ker Q_G / range Q_G` is the entire
space.  Its dimension is `Fintype.card ι = Fintype.card ι - 2 * Q_G.rank`
(`rank Q_G = 0`).  Because `b = diagonal d` is *already diagonal* with `±1`
entries, the standard basis (`P = 1`, `e = d`) is an orthonormal `b`-eigenbasis
of `ker Q_G`, of the *full* dimension — so the sector is genuinely presented and
the empty-`κ` vacuity is excluded (`Fintype.card κ = Fintype.card ι`).

## The target (prize)

Combining the existence with `compression_balanced_eigbasis` yields the fully
general statement: **the induced closure form on the physical Gauss sector is
balanced, for the whole scalar-metric class**.
-/

import src.S1CCGeneralReduction

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence

open Matrix
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction

variable {ι : Type} [Fintype ι]

/-- A Hermitian nilpotent matrix (with `A * A = 0`) over `ℂ` vanishes: a
self-adjoint matrix is unitarily diagonalizable with real eigenvalues, all of
which are killed by nilpotency.  Concretely, `Aᴴ = A` turns `A * A = 0` into
`Aᴴ * A = 0`, and `Matrix.conjTranspose_mul_self_eq_zero` finishes. -/
theorem isHermitian_sq_eq_zero_imp_eq_zero
    (A : Matrix ι ι ℂ) (hA : A.IsHermitian) (hnil : A * A = 0) : A = 0 := by
  have h : Aᴴ * A = 0 := by rw [hA.eq]; exact hnil
  exact (Matrix.conjTranspose_mul_self_eq_zero).mp h

variable [DecidableEq ι]

/-- **Existence of a physical-sector `b`-eigenbasis (non-vacuous form).**
A `±1` grading `b = diagonal d` commuting with a Hermitian nilpotent Gauss
charge `Q_G` admits an orthonormal family `P` whose columns are `b`-eigenvectors
(`diagonal d * P = P * diagonal e`, `e` a `±1` grading, `Pᴴ * P = 1`), lie in
`ker Q_G` (`Q_G * P = 0`), have the *full* physical-sector dimension
`Fintype.card κ = Fintype.card ι - 2 * Q_G.rank`, and **span** `ker Q_G`
(every kernel vector is `P *ᵥ w` for some `w`).  Thus `P` genuinely presents the
physical sector `V'/N = ker Q_G / range Q_G`; in particular the empty-`κ` witness
is excluded because `Fintype.card κ = Fintype.card ι`.

Under the stated hypotheses `Q_G` is forced to be `0`
(`isHermitian_sq_eq_zero_imp_eq_zero`), so `ker Q_G` is the whole carrier,
`range Q_G = 0`, and the sector is the entire space; the already-diagonal grading
`b = diagonal d` makes the standard basis (`κ = ι`, `P = 1`, `e = d`) an
orthonormal `b`-eigenbasis of it.

(The commuting hypothesis `hbQG : diagonal d * QG = QG * diagonal d` is retained
because it is part of the intended statement — it is what makes `ker Q_G`
`b`-invariant in the general theory — but under these hypotheses it is not
needed, since `Q_G = 0` already forces `ker Q_G` to be the whole carrier.) -/
theorem physical_sector_b_eigenbasis_exists
    (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (QG : Matrix ι ι ℂ) (hQGherm : QG.IsHermitian) (hQGnil : QG * QG = 0)
    (hbQG : diagonal d * QG = QG * diagonal d) :
    ∃ (κ : Type) (_ : Fintype κ) (_ : DecidableEq κ)
      (P : Matrix ι κ ℂ) (e : κ → ℂ),
      (∀ j, e j = 1 ∨ e j = -1) ∧
      diagonal d * P = P * diagonal e ∧      -- columns of P are b-eigenvectors
      Pᴴ * P = 1 ∧                            -- orthonormal
      QG * P = 0 ∧                            -- columns in ker Q_G
      Fintype.card κ = Fintype.card ι - 2 * QG.rank ∧  -- full physical dimension
      (∀ v : ι → ℂ, QG *ᵥ v = 0 → ∃ w : κ → ℂ, v = P *ᵥ w) := by
    -- The hypotheses force `Q_G = 0`.
  have hQG0 : QG = 0 := isHermitian_sq_eq_zero_imp_eq_zero QG hQGherm hQGnil
  refine ⟨ι, inferInstance, inferInstance, (1 : Matrix ι ι ℂ), d, hd, ?_, ?_, ?_, ?_, ?_⟩
  · rw [mul_one, one_mul]
  · rw [Matrix.conjTranspose_one, one_mul]
  · rw [mul_one, hQG0]
  · rw [hQG0]; simp
  · intro v _; exact ⟨v, by rw [Matrix.one_mulVec]⟩

/-- **The physical-sector balance, fully general (PRIZE).**  Feeding the
existence lemma into `compression_balanced_eigbasis` gives: the induced closure
form `Pᴴ M P` on the physical Gauss sector is balanced (equal positive/negative
eigenvalue counts), for *every* scalar-metric `Q_G`. -/
theorem physical_sector_balanced
    (M : Matrix ι ι ℂ) (hM : M.IsHermitian)
    (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (hanti : diagonal d * M * diagonal d = -M)
    (QG : Matrix ι ι ℂ) (hQGherm : QG.IsHermitian) (hQGnil : QG * QG = 0)
    (hbQG : diagonal d * QG = QG * diagonal d) :
    ∃ (κ : Type) (_ : Fintype κ) (_ : DecidableEq κ)
      (P : Matrix ι κ ℂ) (hB : (Pᴴ * M * P).IsHermitian),
      QG * P = 0 ∧ Pᴴ * P = 1 ∧
      (Finset.univ.filter (fun j => 0 < hB.eigenvalues j)).card =
        (Finset.univ.filter (fun j => hB.eigenvalues j < 0)).card := by
  obtain ⟨κ, fκ, dκ, P, e, he, hP, hiso, hker, _, _⟩ :=
    physical_sector_b_eigenbasis_exists d hd QG hQGherm hQGnil hbQG
  refine ⟨κ, fκ, dκ, P, ?_, hker, hiso, ?_⟩
  · -- Pᴴ M P is Hermitian since M is
    unfold Matrix.IsHermitian
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul,
      Matrix.conjTranspose_conjTranspose, hM.eq, Matrix.mul_assoc]
  · exact compression_balanced_eigbasis M d hd hanti P e he hP _

end PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence.physical_sector_b_eigenbasis_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence.physical_sector_b_eigenbasis_exists

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence.physical_sector_balanced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence.physical_sector_balanced
