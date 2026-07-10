/-
# S1-CC: the physical-sector b-eigenbasis EXISTENCE lemma (corrected, non-degenerate)

The closure Krein form on the physical Gauss sector `V'/N = ker Q_G / range Q_G`
is proved **balanced** for compression by *any* `b`-eigenvector family
(`S1CCGeneralReduction.compression_balanced_eigbasis`, already proved in this
package, no `sorry`).  The remaining gap was an **existence** fact: that such a
`b`-eigenbasis presenting the physical sector actually exists.

## The physically correct hypotheses

The physical Gauss/BRST charge is **nilpotent and NON-Hermitian** (self-adjoint
only with respect to the indefinite Krein form, exactly like the witness's
`c₁ = E₀₁` on the Clifford factor: `c₁² = 0`, `c₁ ≠ c₁ᴴ`).  Imposing
`Q_G.IsHermitian` together with `Q_G * Q_G = 0` over the *definite* inner product
would force `Q_G = 0` (`isHermitian_sq_eq_zero_imp_eq_zero`), collapsing the
sector to the whole carrier — a degenerate, unphysical special case.  We
therefore drop the Hermitian hypothesis entirely.  The correct structural data
is:

* `b = diagonal d`, a `±1` grading (`∀ i, d i = 1 ∨ d i = -1`), the closure
  bivector `σz ⊗ 1` — a self-adjoint `±1` involution;
* `Q_G : Matrix ι ι ℂ` **nilpotent** (`Q_G * Q_G = 0`); and
* `Q_G` **commutes with the grading** (`diagonal d * Q_G = Q_G * diagonal d`) —
  the scalar-metric case.  This does *not* collapse `Q_G`: the witness
  `Q_G = c₁(x)·diag(0,0,1)` is nonzero, nilpotent, non-Hermitian, and commutes
  with `b = σz ⊗ 1`.

## The genuine simultaneous-structure argument

Because `b` is a `±1` involution commuting with the nilpotent `Q_G`, both
`ker Q_G` and `range Q_G` are `b`-invariant, and `range Q_G ⊆ ker Q_G` (from
`Q_G² = 0`).  Hence `b` descends to the quotient `ker Q_G / range Q_G`, and one
can choose a `b`-eigenbasis of a **complement of `range Q_G` inside `ker Q_G`**.
This is carried out at the linear-map level in `S1CCEigenbasis.eigenbasis_core`
(non-degenerate: no Hermitian hypothesis is used, so `Q_G` is genuinely free to
be a nonzero nilpotent).

Here we bridge that abstract core to the matrix presentation `P : Matrix ι κ ℂ`
whose columns are the eigenbasis vectors, and feed it to
`compression_balanced_eigbasis` for the prize.
-/

import src.S1CCGeneralReduction
import src.S1CCEigenbasis

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCPresentationExistence

open Matrix
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction
open PhysicsSM.Draft.NullEdge.GateYM.S1CCEigenbasis

variable {ι : Type} [Fintype ι] [DecidableEq ι]

/-
A matrix with an injective associated linear map has a left inverse.
-/
theorem exists_leftInverse_of_mulVecLin_injective {κ : Type} [Fintype κ] [DecidableEq κ]
    (P : Matrix ι κ ℂ) (h : Function.Injective P.mulVecLin) :
    ∃ L : Matrix κ ι ℂ, L * P = 1 := by
  -- Apply the fact that if the linear map is injective, then there exists a left inverse.
  obtain ⟨L, hL⟩ : ∃ L : (ι → ℂ) →ₗ[ℂ] (κ → ℂ), L ∘ₗ P.mulVecLin = LinearMap.id := by
    exact?;
  -- Convert the linear map $L$ to a matrix $L'$.
  obtain ⟨L', hL'⟩ : ∃ L' : Matrix κ ι ℂ, L = Matrix.toLin' L' := by
    use Matrix.of (fun i j => L (Pi.single j 1) i);
    ext x i; simp +decide [ Matrix.mulVec, dotProduct ] ;
    rw [ Finset.sum_eq_single x ] <;> aesop;
  use L';
  rw [ ← Matrix.toLin'.injective.eq_iff ] ; aesop

/-
**Existence of a physical-sector `b`-eigenbasis (corrected, non-degenerate).**
Let `b = diagonal d` be a `±1` grading commuting with a **nilpotent**
Gauss charge `Q_G` (`Q_G * Q_G = 0`) — no Hermitian hypothesis, so `Q_G` may be a
genuine nonzero nilpotent.  Then there is a family `P : Matrix ι κ ℂ` whose
columns:

* are `b`-eigenvectors with `±1` eigenvalues `e` (`diagonal d * P = P * diagonal e`);
* lie in `ker Q_G` (`Q_G * P = 0`);
* have the **full physical-sector dimension**
  `Fintype.card κ = Fintype.card ι - 2 * Q_G.rank`
  (since `range Q_G ⊆ ker Q_G`, so `dim(ker/range) = (card ι − rank) − rank`);
* are **linearly independent** (there is a left inverse `L` with `L * P = 1`); and
* span a **complement of `range Q_G` in `ker Q_G`**: every `v` with `Q_G *ᵥ v = 0`
  is `P *ᵥ w + Q_G *ᵥ z` for some `w, z`.

Thus `P` genuinely presents `V'/N = ker Q_G / range Q_G`.
-/
theorem physical_sector_b_eigenbasis_exists
    (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (QG : Matrix ι ι ℂ) (hQGnil : QG * QG = 0)
    (hbQG : diagonal d * QG = QG * diagonal d) :
    ∃ (κ : Type) (_ : Fintype κ) (_ : DecidableEq κ)
      (P : Matrix ι κ ℂ) (e : κ → ℂ),
      (∀ j, e j = 1 ∨ e j = -1) ∧
      diagonal d * P = P * diagonal e ∧                      -- columns are b-eigenvectors
      QG * P = 0 ∧                                            -- columns in ker Q_G
      Fintype.card κ = Fintype.card ι - 2 * QG.rank ∧         -- full physical dimension
      (∃ L : Matrix κ ι ℂ, L * P = 1) ∧                       -- columns linearly independent
      (∀ v : ι → ℂ, QG *ᵥ v = 0 →                             -- span a complement of range Q_G
        ∃ (w : κ → ℂ) (z : ι → ℂ), v = P *ᵥ w + QG *ᵥ z) := by
  revert hd hbQG hQGnil;
  intro hd hQGnil hbQG
  obtain ⟨κ, fκ, dκ, v, e, he, hev, hkerφ, hindep, hspan, hcard⟩ := eigenbasis_core (Matrix.mulVecLin (diagonal d)) (Matrix.mulVecLin QG) (by
  ext; simp [diagonal_grading_sq, hd];
  grind +extAll) (by
  exact LinearMap.ext fun x => by simp +decide [ ← Matrix.mul_assoc, hQGnil ] ;) (by
  simp_all +decide [ LinearMap.ext_iff ]);
  refine' ⟨ κ, fκ, dκ, Matrix.of ( fun i j => v j i ), e, he, _, _, _, _ ⟩;
  · ext i j; simp +decide [ Matrix.mul_apply, Matrix.diagonal_apply ] ;
    replace hev := congr_fun ( hev j ) i; simp_all +decide [ mul_comm, Matrix.mulVec ] ;
  · ext i j; simp +decide [ Matrix.mul_apply ] ;
    simpa [ Matrix.mulVec, dotProduct ] using congr_fun ( hkerφ j ) i;
  · simp_all +decide [ Matrix.rank ];
    exact eq_tsub_of_add_eq hcard;
  · refine' ⟨ _, _ ⟩;
    · apply exists_leftInverse_of_mulVecLin_injective;
      exact Matrix.mulVec_injective_iff.mpr ( by simpa [ funext_iff, Matrix.mulVec, dotProduct ] using hindep );
    · intro x hx; specialize hspan x hx; simp_all +decide [ funext_iff, Matrix.mulVec ] ;
      simpa only [ dotProduct, mul_comm ] using hspan

/-- **The physical-sector balance, fully general (PRIZE).**  Feeding the corrected
existence lemma into `compression_balanced_eigbasis` gives: the induced closure
form `Pᴴ M P` on the physical Gauss sector is balanced (equal positive/negative
eigenvalue counts), for *every* scalar-metric nilpotent `Q_G`.  Note that
`compression_balanced_eigbasis` requires only the `b`-intertwining, not any
orthonormality `Pᴴ P = 1` — appropriate now that `Q_G` is non-Hermitian. -/
theorem physical_sector_balanced
    (M : Matrix ι ι ℂ) (hM : M.IsHermitian)
    (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (hanti : diagonal d * M * diagonal d = -M)
    (QG : Matrix ι ι ℂ) (hQGnil : QG * QG = 0)
    (hbQG : diagonal d * QG = QG * diagonal d) :
    ∃ (κ : Type) (_ : Fintype κ) (_ : DecidableEq κ)
      (P : Matrix ι κ ℂ) (hB : (Pᴴ * M * P).IsHermitian),
      QG * P = 0 ∧ (∃ L : Matrix κ ι ℂ, L * P = 1) ∧
      (Finset.univ.filter (fun j => 0 < hB.eigenvalues j)).card =
        (Finset.univ.filter (fun j => hB.eigenvalues j < 0)).card := by
  obtain ⟨κ, fκ, dκ, P, e, he, hP, hker, _, hLinv, _⟩ :=
    physical_sector_b_eigenbasis_exists d hd QG hQGnil hbQG
  refine ⟨κ, fκ, dκ, P, ?_, hker, hLinv, ?_⟩
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
