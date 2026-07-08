/-
# S1-CC: the general-representative reduction (witness ⇒ general)

This file upgrades the explicit `6×6` witness of `S1CCPhysicalSectorWitness.lean`
to the **general scalar-metric statement**: the closure Krein form on the
physical Gauss sector is balanced (`n₊ = n₋`) for *every* representative, not
just the coordinate-aligned witness.

## The structural point

The witness balance is proved by a `b`-anticonjugation `b (J Q_C) b = -(J Q_C)`
of the full-carrier closure form, together with the descent of `b` to the
physical sector `V'/N`.  The key observation of this file is that this mechanism
is **structural and coordinate-free**:

* The closure grading `b = σz ⊗ 1` is a **diagonal `±1` grading** of the carrier.
* Passing to the physical sector `V'/N = ker Q_G / range Q_G` is *conjecturally*
  (grade **MEMO** — this is the remaining un-transcribed piece, see below) realized,
  after diagonalizing the Hermitian Gauss operator `G` on the color leg (`[G,K]=0`
  makes `K` block-diagonal in the `G`-eigenbasis and leaves `b = σz ⊗ 1`
  untouched), as a **compression** `J ↦ Pᴴ J P` onto a `b`-adapted presentation of
  the sector. The coordinate special case is a `submatrix r r` onto representatives
  `r`; the presentation-independent statement (`compression_balanced_eigbasis`)
  takes any `b`-eigenvector family `P`. What is *not* discharged in Lean is that
  such a `P` genuinely presents `V'/N` (right dimension, complementary to
  `range Q_G`, form descending to the quotient) — see the scope note below.
* A diagonal grading anticonjugation is inherited by *any* submatrix compression
  (`compression_inherits_anticonj`), for *any* choice of representatives `r`.

Everything is stated over arbitrary finite index types: `ι` indexes the full
carrier (for the physical program a *product* type such as `Fin 2 × Fin 3`,
Clifford ⊗ color), and `κ` indexes the coset representatives.  Hence, by the
balance engine `hermitian_balanced_count_of_neg_charpoly`, the compressed form is
balanced for every scalar-metric `Q_G`.  The particular `Q_G` only fixes *which*
index set `r : κ → ι` the compression uses; it never affects the inherited
anticonjugation, so it never affects the balance.

This is the promised "upgrade witness → general": balance holds for the whole
scalar-metric class, and the only escape (a genuinely *soldered* `Q_G` mixing
the Clifford and color legs, so that `b` no longer preserves `ker Q_G`/`range Q_G`)
is exactly the pre-registered kill condition **K-A**.  The witness itself is
re-derived as a literal instance in `S1CCWitnessAsInstance.lean`.

## Provenance

All-mass solo run 2026-07-08 [orig].  Proof from Aristotle (standalone package
`AgentTasks/aristotle-standalone/allmass-strategy-s1ccgen-20260708`), reviewed for
semantic alignment and **re-based here onto the project's real
`S1CCBalancedInertia`** (the sandbox reconstructed the balance engine because the
project brick library was absent from its import graph; here we import the
project's actual `hermitian_balanced_count_of_neg_charpoly` /
`anticonj_charpoly_eq`, no reconstruction).  Successor: `S1CCWitnessAsInstance`
(the `6×6` witness re-derived as an instance).
-/

import PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction

open Matrix
open PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia

variable {ι κ : Type*} [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]

/-- A `±1` grading `d` yields an involutive diagonal matrix, `(diagonal d)² = 1`. -/
theorem diagonal_grading_sq (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1) :
    diagonal d * diagonal d = 1 := by
  ext i j; by_cases hi : i = j <;> simp_all +decide [ Matrix.mul_apply ] ;
  · cases hd j <;> simp +decide [ *, Matrix.one_apply ]; all_goals simp +decide [ *, diagonal ];
  · simp +decide [ diagonal, hi ]

omit [Fintype ι] in
/-- A real `±1`-diagonal matrix is conjugate-transpose-invariant. -/
theorem diagonal_pm1_conjTranspose (e : ι → ℂ) (he : ∀ i, e i = 1 ∨ e i = -1) :
    (diagonal e)ᴴ = diagonal e := by
  rw [Matrix.diagonal_conjTranspose]
  congr 1; funext i; rcases he i with h | h <;> simp [Pi.star_apply, h]

/-- **Compression inherits anticonjugation.** If a diagonal grading `diagonal d`
anticonjugates a matrix `J` on the full carrier (`diagonal d * J * diagonal d = -J`),
then for *any* representative selection `r : κ → ι` the descended grading
`diagonal (d ∘ r)` anticonjugates the submatrix compression `J.submatrix r r`.
This holds entrywise and is independent of which indices `r` selects — the heart
of the witness → general upgrade. -/
theorem compression_inherits_anticonj (J : Matrix ι ι ℂ) (d : ι → ℂ)
    (hanti : diagonal d * J * diagonal d = -J) (r : κ → ι) :
    diagonal (d ∘ r) * J.submatrix r r * diagonal (d ∘ r) = -(J.submatrix r r) := by
  ext i j; simp +decide [ *, Matrix.mul_apply, Matrix.diagonal ] ;
  replace hanti := congr_fun ( congr_fun hanti ( r i ) ) ( r j ) ; simp_all +decide [ Matrix.mul_apply, Matrix.diagonal ] ;

/-- **General reduction (prize).** Let `J` be Hermitian on the full carrier `ι`,
`d` a `±1` closure grading whose diagonal matrix anticonjugates `J`, and
`r : κ → ι` *any* selection of physical-sector coset representatives.
Then the compressed closure form `J.submatrix r r` is **balanced**: it has
exactly as many strictly positive as strictly negative Hermitian eigenvalues.

No hypothesis on the Gauss charge `Q_G` appears: the only role `Q_G` plays is to
determine the representative set `r`, and balance holds for *every* `r`. -/
theorem compression_balanced (J : Matrix ι ι ℂ) (hJ : J.IsHermitian)
    (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (hanti : diagonal d * J * diagonal d = -J) (r : κ → ι) :
    (Finset.univ.filter (fun i => 0 < (hJ.submatrix r).eigenvalues i)).card =
      (Finset.univ.filter (fun i => (hJ.submatrix r).eigenvalues i < 0)).card := by
  set B := J.submatrix r r with hBdef
  set S := diagonal (d ∘ r) with hSdef
  have hSsq : S * S = 1 := diagonal_grading_sq (d ∘ r) (fun i => hd (r i))
  haveI : Invertible S := ⟨S, hSsq, hSsq⟩
  have hinv : ⅟S = S := invOf_eq_right_inv hSsq
  have hAnti : ⅟S * B * S = -B := by
    rw [hinv]; exact compression_inherits_anticonj J d hanti r
  exact hermitian_balanced_count_of_neg_charpoly B (hJ.submatrix r)
    (anticonj_charpoly_eq B S hAnti)

/-- **General reduction, eigenbasis (presentation-independent) form.** The
`compression_balanced` result compresses `J` by a *coordinate* `submatrix r r`;
this strengthens it to compression by an **arbitrary `b`-eigenvector family**
`P : Matrix ι κ ℂ`.  If `M` is Hermitian and anticonjugated by the `±1` grading
`diagonal d`, and `P` intertwines that grading with a `±1` grading `e` on the
compressed index (`diagonal d * P = P * diagonal e` — the columns of `P` are
`b`-eigenvectors), then the compression `Pᴴ * M * P` is **balanced**: it has as
many strictly positive as strictly negative eigenvalues.

This is the presentation-independent form of the balance *mechanism*: the reps of
`V'/N` need not be coordinate axes; *any* `b`-eigenvector family gives a balanced
compression, and the mechanism is `Q_G`-blind (no `Q_G` appears). What it does
**not** establish (grade **MEMO**, per Fable call-09) is that a given `P`
genuinely *presents* the physical sector `V'/N`: the remaining gap is the
existence of a `b`-eigenvector family in `ker Q_G` that is **complementary to
`range Q_G`** with dimension `dim ker Q_G − rank Q_G`, together with the descent
of the closure form to the quotient — not merely "a `b`-eigenbasis exists" (that
alone is satisfiable by the empty family). Simultaneous diagonalization via
`[b, Q_G] = 0` supplies the eigenbasis; the dimension/complementarity/descent are
un-transcribed. The coordinate witness `submatrix r r` is the special case
`P = (1 : Matrix ι ι ℂ).submatrix id r`. -/
theorem compression_balanced_eigbasis
    (M : Matrix ι ι ℂ) (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (hanti : diagonal d * M * diagonal d = -M)
    (P : Matrix ι κ ℂ) (e : κ → ℂ) (he : ∀ i, e i = 1 ∨ e i = -1)
    (hP : diagonal d * P = P * diagonal e)
    (hB : (Pᴴ * M * P).IsHermitian) :
    (Finset.univ.filter (fun i => 0 < hB.eigenvalues i)).card =
      (Finset.univ.filter (fun i => hB.eigenvalues i < 0)).card := by
  set S := diagonal e with hSdef
  have hSsq : S * S = 1 := diagonal_grading_sq e he
  haveI : Invertible S := ⟨S, hSsq, hSsq⟩
  have hinv : ⅟S = S := invOf_eq_right_inv hSsq
  -- left intertwiner: `diagonal e * Pᴴ = Pᴴ * diagonal d` (conjTranspose of `hP`).
  have hLeft : S * Pᴴ = Pᴴ * diagonal d := by
    have h := congrArg Matrix.conjTranspose hP
    rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul,
      diagonal_pm1_conjTranspose d hd, diagonal_pm1_conjTranspose e he] at h
    exact h.symm
  have hAnti : ⅟S * (Pᴴ * M * P) * S = -(Pᴴ * M * P) := by
    rw [hinv, hSdef]
    calc diagonal e * (Pᴴ * M * P) * diagonal e
        = (diagonal e * Pᴴ) * M * (P * diagonal e) := by simp only [Matrix.mul_assoc]
      _ = (Pᴴ * diagonal d) * M * (diagonal d * P) := by rw [← hSdef, hLeft, ← hP]
      _ = Pᴴ * (diagonal d * M * diagonal d) * P := by simp only [Matrix.mul_assoc]
      _ = Pᴴ * (-M) * P := by rw [hanti]
      _ = -(Pᴴ * M * P) := by rw [Matrix.mul_neg, Matrix.neg_mul]
  exact hermitian_balanced_count_of_neg_charpoly (Pᴴ * M * P) hB
    (anticonj_charpoly_eq (Pᴴ * M * P) S hAnti)

/-- **No-positivity corollary.** If, in addition, the compressed form is
nondegenerate (`IsUnit (J.submatrix r r).det`) on a nonempty sector, then it has
a strictly negative eigenvalue — so the closure form is **never positive
semidefinite** on a nontrivial physical sector. -/
theorem compression_has_neg_eigenvalue (J : Matrix ι ι ℂ)
    (hJ : J.IsHermitian) (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (hanti : diagonal d * J * diagonal d = -J) (r : κ → ι)
    (hdet : IsUnit (J.submatrix r r).det) (hκ : Nonempty κ) :
    ∃ i, (hJ.submatrix r).eigenvalues i < 0 := by
  contrapose! hdet; have := compression_balanced J hJ d hd hanti r; simp_all +decide ;
  -- No strictly negative eigenvalue ⇒ that filter is empty.
  have h_empty_neg : Finset.univ.filter (fun i => (hJ.submatrix r).eigenvalues i < 0) = ∅ := by
    exact Finset.eq_empty_of_forall_notMem fun i hi => not_lt_of_ge ( hdet i ) ( Finset.mem_filter.mp hi |>.2 );
  simp_all +decide [ Finset.ext_iff ];
  rw [ Matrix.IsHermitian.det_eq_prod_eigenvalues ( hJ.submatrix r ) ];
  exact Finset.prod_eq_zero ( Finset.mem_univ hκ.some ) ( by norm_num [ le_antisymm ( this _ ) ( hdet _ ) ] )

end PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction.compression_balanced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction.compression_balanced

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction.compression_balanced_eigbasis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction.compression_balanced_eigbasis

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction.compression_has_neg_eigenvalue' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction.compression_has_neg_eigenvalue
