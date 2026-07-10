/-
# S1-CC: the physical-sector b-eigenbasis EXISTENCE lemma (the last MEMO piece)

The closure Krein form on the physical Gauss sector `V'/N = ker Q_G / range Q_G`
is now proved **balanced** for compression by *any* `b`-eigenvector family
(`S1CCGeneralReduction.compression_balanced_eigbasis`, already proved in this
package, no `sorry`).  The single remaining gap in the S1-CC central-crux
resolution is an **existence** fact: that such a `b`-eigenbasis of the physical
sector actually exists.

## The mathematics

Setup on a finite carrier `ι` (for the physical program `ι = Fin 2 × Fin 3`,
Clifford ⊗ color, but state it generally):

* `M : Matrix ι ι ℂ` Hermitian — the closure Krein form `J Q_C`.
* `b = diagonal d`, a `±1` grading (`∀ i, d i = 1 ∨ d i = -1`), the closure
  bivector `σz ⊗ 1`, with `b * M * b = -M` (anticonjugation — already the
  witness fact `bg_anticonj`).
* `Q_G : Matrix ι ι ℂ` Hermitian, BRST-nilpotent (`Q_G * Q_G = 0`), and
  **commuting with the grading** (`b * Q_G = Q_G * b`) — true in the
  scalar-metric class because `Q_G = c ⊗ G` acts on the color leg and `b = σz⊗1`
  on the Clifford leg (they act on different tensor factors, hence commute).

The physical sector is `V'/N = ker Q_G / range Q_G` (with `range Q_G ⊆ ker Q_G`
from nilpotency + hermiticity).  Because `b` commutes with `Q_G`, both `ker Q_G`
and `range Q_G` are `b`-invariant, so `b` descends to an involution on the
quotient `V'/N`.  A self-adjoint involution on a finite-dimensional complex inner
product space is diagonalizable with `±1` eigenvalues, so `V'/N` has an
orthonormal basis of `b`-eigenvectors.  Lifting it to an orthonormal `b`-adapted
family `P : Matrix ι κ ℂ` (columns spanning a complement of `range Q_G` inside
`ker Q_G`) gives exactly the hypotheses of `compression_balanced_eigbasis`.

## The target (prize)

Combining the existence with `compression_balanced_eigbasis` yields the fully
general statement: **the induced closure form on the physical Gauss sector is
balanced, for the whole scalar-metric class** — upgrading the S1-CC central crux
from "witness M + presentation MEMO" to unconditional general **M**.

The suggested statement below is a *starting point*; please restate it in
whatever form (matrix / `LinearMap` / `Submodule` quotient) is cleanest to prove,
as long as it genuinely captures "an orthonormal `b`-eigenbasis of a complement
of `range Q_G` in `ker Q_G` exists", and then discharge the balance via
`compression_balanced_eigbasis`.  The nontrivial content is that `P` really
represents the physical sector `V'/N` (so `Q_G * P = 0`, `Pᴴ * P = 1`, and
`range P` is complementary to `range Q_G` in `ker Q_G`); a trivial `P` (empty
`κ`) must be excluded by pinning the dimension.
-/

import src.S1CCGeneralReduction

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence

open Matrix
open PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- **Existence of a physical-sector `b`-eigenbasis (TARGET, currently a
handoff `sorry`).**  A `±1` grading `b = diagonal d` commuting with a Hermitian
nilpotent Gauss charge `Q_G` admits an orthonormal family `P` whose columns are
`b`-eigenvectors, lie in `ker Q_G`, and are complementary to `range Q_G` there —
so `P` presents the physical sector `V'/N`.  (Restate as convenient; the content
is genuine simultaneous diagonalization of a commuting involution and a nilpotent,
adapted to the `range ⊆ ker` filtration.) -/
theorem physical_sector_b_eigenbasis_exists
    (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (QG : Matrix ι ι ℂ) (hQGherm : QG.IsHermitian) (hQGnil : QG * QG = 0)
    (hbQG : diagonal d * QG = QG * diagonal d) :
    ∃ (κ : Type) (_ : Fintype κ) (_ : DecidableEq κ)
      (P : Matrix ι κ ℂ) (e : κ → ℂ),
      (∀ j, e j = 1 ∨ e j = -1) ∧
      diagonal d * P = P * diagonal e ∧
      Pᴴ * P = 1 ∧
      QG * P = 0 := by
  sorry

/-- **The physical-sector balance, fully general (PRIZE, currently depends on the
`sorry` above).**  Feeding the existence lemma into
`compression_balanced_eigbasis` gives: the induced closure form `Pᴴ M P` on the
physical Gauss sector is balanced (equal positive/negative eigenvalue counts),
for *every* scalar-metric `Q_G`. -/
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
  obtain ⟨κ, fκ, dκ, P, e, he, hP, hiso, hker⟩ :=
    physical_sector_b_eigenbasis_exists d hd QG hQGherm hQGnil hbQG
  refine ⟨κ, fκ, dκ, P, ?_, hker, hiso, ?_⟩
  · -- Pᴴ M P is Hermitian since M is
    unfold Matrix.IsHermitian
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul,
      Matrix.conjTranspose_conjTranspose, hM.eq, Matrix.mul_assoc]
  · exact compression_balanced_eigbasis M d hd hanti P e he hP _

end PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence
