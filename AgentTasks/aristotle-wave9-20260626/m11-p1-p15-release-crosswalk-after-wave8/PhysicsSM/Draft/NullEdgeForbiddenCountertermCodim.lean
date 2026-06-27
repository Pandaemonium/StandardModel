import Mathlib

/-!
# F13 forbidden-counterterm codimension theorem (finite null-edge square)

This file is the Aristotle deliverable for the **Wave 8 F13 forbidden-counterterm
codimension** job (see `PROMPT.md`, `COMMON_CONTEXT.md`, and the Wave 8 master
strategy).  It isolates, as kernel-checked finite linear algebra, the single
counterterm that the locked null-edge grading architecture *forbids* while a
generic EFT / quiver spectral action would allow it, and packages the forbidding
as a genuine **codimension** statement.

## The forbidden counterterm

Work in the finite graded chiral space `L ⊕ R` with the spacetime chirality
grading `Γ_s` equal to `+1` on `L` and `-1` on `R` (the `chirality` of
`NullEdgeSuperDiracBlockCore`).  A genuine (null-edge / NCG) Dirac operator must
be **odd**, i.e. it must anticommute with `Γ_s`:

```text
{Γ_s, D} = 0.
```

The *allowed* zero-order mass operator is the off-diagonal Higgs/Yukawa block
`offDiagonal φ ψ` (chirality-flipping `L ↔ R`), which is automatically odd
(`offDiagonal_isOdd`).  The Yukawa square then produces the diagonal mass block
`ψφ` on `L` (`offDiagonal_sq_leftBlock` in `NullEdgeSuperDiracBlockCore`).

The **forbidden** counterterm is a *diagonal* (chirality-preserving) zero-order
mass operator: a bare `L → L` (or `R → R`) mass that does **not** flip chirality,
e.g. a Majorana-type same-Weyl mass `m·I` added directly to `D`.  Such a term is
chirality-*even* (`{Γ_s, ·} ≠ 0`), so it cannot occur in an odd operator.

## Separating *forbidden* from *merely absent*

This is a true symmetry obstruction, not a convention:

* `offDiagonal_isOdd` shows the chirality-flipping Yukawa block is admissible.
* `odd_diag_left_zero` / `odd_diag_right_zero` show that **any** odd operator,
  no matter how general, has identically vanishing diagonal blocks: the diagonal
  mass is removed by the symmetry, not by failing to write the most general term.
* `isOdd_iff_offDiagonal` characterises the admissible odd operators as *exactly*
  the off-diagonal ones, so nothing diagonal can hide inside a legal fluctuation.
* `diag_left_nonzero_not_odd` is the contrapositive "cannot be represented" form:
  a nonzero same-chirality mass entry makes the operator non-odd.

## The codimension / moduli-rank statement

`diagBlocks` is the linear map sending an operator to its two diagonal blocks.
It is surjective (`diagBlocks_surjective`) and its kernel is precisely the odd
(admissible) subspace (`mem_ker_diagBlocks_iff`).  Hence the admissible odd
operators sit at codimension

```text
codim = (card L)^2 + (card R)^2
```

inside the ambient operator space (`forbidden_counterterm_codimension`).  These
are exactly the parameters of the forbidden diagonal mass counterterms — removed,
not tuned.  This is the `rank(dF) < dim M_EFT` ingredient Gate F requires.

This is finite algebra; no continuum claim is made.
-/

noncomputable section

namespace PhysicsSM.Draft.ForbiddenCounterterm

open Matrix

variable {L R : Type*} [Fintype L] [Fintype R] [DecidableEq L] [DecidableEq R]

/-- The chirality value: `+1` on `L`, `-1` on `R`. -/
def chiralityVal : Sum L R → ℂ := Sum.elim (fun _ => 1) (fun _ => -1)

/-- Chirality grading `Γ_s` as a diagonal matrix: `+1` on `L`, `-1` on `R`.
This agrees with `NullEdgeSuperDiracBlockCore.chirality`. -/
def chirality : Matrix (Sum L R) (Sum L R) ℂ :=
  Matrix.diagonal (chiralityVal (L := L) (R := R))

/-- The off-diagonal (chirality-flipping) Yukawa/Higgs block. -/
def offDiagonal (phi : Matrix R L ℂ) (psi : Matrix L R ℂ) :
    Matrix (Sum L R) (Sum L R) ℂ :=
  fun a b =>
    match a, b with
    | Sum.inl _, Sum.inl _ => 0
    | Sum.inl l, Sum.inr r => psi l r
    | Sum.inr r, Sum.inl l => phi r l
    | Sum.inr _, Sum.inr _ => 0

/-- An operator is **odd** (admissible as a null-edge / NCG Dirac term) iff it
anticommutes with the chirality grading: `{Γ_s, M} = 0`. -/
def IsOdd (M : Matrix (Sum L R) (Sum L R) ℂ) : Prop :=
  chirality * M + M * chirality = 0

/-- **Entrywise anticommutator.**  Since `Γ_s` is diagonal,
`{Γ_s, M}_{ab} = (χ(a) + χ(b)) · M_{ab}`. -/
theorem anticomm_entry (M : Matrix (Sum L R) (Sum L R) ℂ) (a b : Sum L R) :
    (chirality * M + M * chirality : Matrix (Sum L R) (Sum L R) ℂ) a b
      = (chiralityVal a + chiralityVal b) * M a b := by
  simp only [chirality, Matrix.add_apply, Matrix.diagonal_mul, Matrix.mul_diagonal]
  ring

/-- **Forbidden diagonal mass (left block).**  Any odd operator has identically
vanishing `L → L` diagonal block.  A chirality-preserving `L`-mass counterterm is
forbidden. -/
theorem odd_diag_left_zero (M : Matrix (Sum L R) (Sum L R) ℂ) (h : IsOdd M)
    (l l' : L) : M (Sum.inl l) (Sum.inl l') = 0 := by
  have h2 := congrFun (congrFun h (Sum.inl l)) (Sum.inl l')
  rw [anticomm_entry] at h2
  simp only [chiralityVal, Sum.elim_inl, Matrix.zero_apply] at h2
  have : (2 : ℂ) * M (Sum.inl l) (Sum.inl l') = 0 := by linear_combination h2
  simpa using this

/-- **Forbidden diagonal mass (right block).**  Any odd operator has identically
vanishing `R → R` diagonal block. -/
theorem odd_diag_right_zero (M : Matrix (Sum L R) (Sum L R) ℂ) (h : IsOdd M)
    (r r' : R) : M (Sum.inr r) (Sum.inr r') = 0 := by
  have h2 := congrFun (congrFun h (Sum.inr r)) (Sum.inr r')
  rw [anticomm_entry] at h2
  simp only [chiralityVal, Sum.elim_inr, Matrix.zero_apply] at h2
  have : (-2 : ℂ) * M (Sum.inr r) (Sum.inr r') = 0 := by linear_combination h2
  simpa using this

/-- The off-diagonal Yukawa/Higgs block is odd (admissible). -/
theorem offDiagonal_isOdd (phi : Matrix R L ℂ) (psi : Matrix L R ℂ) :
    IsOdd (offDiagonal phi psi) := by
  unfold IsOdd
  ext a b
  rw [anticomm_entry]
  cases a <;> cases b <;> simp [chiralityVal, offDiagonal]

/-- **Characterisation of admissible counterterms.**  An operator is odd iff both
of its diagonal blocks vanish, i.e. iff it is purely off-diagonal.  Nothing
diagonal can hide inside a legal (odd) fluctuation. -/
theorem isOdd_iff_offDiagonal (M : Matrix (Sum L R) (Sum L R) ℂ) :
    IsOdd M ↔
      (∀ l l', M (Sum.inl l) (Sum.inl l') = 0) ∧
      (∀ r r', M (Sum.inr r) (Sum.inr r') = 0) := by
  constructor
  · intro h
    exact ⟨odd_diag_left_zero M h, odd_diag_right_zero M h⟩
  · intro ⟨hL, hR⟩
    unfold IsOdd
    ext a b
    rw [anticomm_entry]
    cases a <;> cases b <;> simp_all [chiralityVal]

/-- **A nonzero diagonal counterterm cannot be represented as an odd operator.**
If a `L → L` mass entry is nonzero then the operator is not odd. -/
theorem diag_left_nonzero_not_odd (M : Matrix (Sum L R) (Sum L R) ℂ)
    (l l' : L) (hne : M (Sum.inl l) (Sum.inl l') ≠ 0) : ¬ IsOdd M := by
  intro h
  exact hne (odd_diag_left_zero M h l l')

/-! ### Codimension / moduli-rank statement -/

/-- The diagonal-block map: an operator goes to its two chirality-preserving
blocks `(M|_{L→L}, M|_{R→R})`.  Its components are exactly the forbidden mass
counterterms. -/
def diagBlocks :
    Matrix (Sum L R) (Sum L R) ℂ →ₗ[ℂ] (Matrix L L ℂ × Matrix R R ℂ) where
  toFun M := (M.submatrix Sum.inl Sum.inl, M.submatrix Sum.inr Sum.inr)
  map_add' M N := by ext <;> simp [Matrix.submatrix_apply]
  map_smul' c M := by ext <;> simp [Matrix.submatrix_apply]

/-- The kernel of `diagBlocks` is exactly the admissible odd subspace. -/
theorem mem_ker_diagBlocks_iff (M : Matrix (Sum L R) (Sum L R) ℂ) :
    M ∈ LinearMap.ker (diagBlocks (L := L) (R := R)) ↔ IsOdd M := by
  rw [LinearMap.mem_ker, isOdd_iff_offDiagonal]
  constructor
  · intro h
    have hL := congrArg Prod.fst h
    have hR := congrArg Prod.snd h
    refine ⟨fun l l' => ?_, fun r r' => ?_⟩
    · have := congrFun (congrFun hL l) l'
      simpa [diagBlocks, Matrix.submatrix_apply] using this
    · have := congrFun (congrFun hR r) r'
      simpa [diagBlocks, Matrix.submatrix_apply] using this
  · intro ⟨hL, hR⟩
    apply Prod.ext <;> ext i j
    · simpa [diagBlocks, Matrix.submatrix_apply] using hL i j
    · simpa [diagBlocks, Matrix.submatrix_apply] using hR i j

omit [Fintype L] [Fintype R] [DecidableEq L] [DecidableEq R] in
/-- `diagBlocks` is surjective: every pair of diagonal blocks is realisable. -/
theorem diagBlocks_surjective :
    Function.Surjective (diagBlocks (L := L) (R := R)) := by
  intro p
  obtain ⟨A, B⟩ := p
  refine ⟨fun a b =>
      match a, b with
      | Sum.inl l, Sum.inl l' => A l l'
      | Sum.inr r, Sum.inr r' => B r r'
      | _, _ => 0, ?_⟩
  apply Prod.ext <;> ext i j <;> simp [diagBlocks, Matrix.submatrix_apply]

omit [DecidableEq L] [DecidableEq R] in
/-- **F13 codimension theorem.**  The admissible odd operators form a subspace of
codimension `(card L)^2 + (card R)^2` inside the ambient operator space: the
quotient by the odd subspace has finrank equal to the number of forbidden
diagonal-mass parameters.  These parameters are *removed* by the chirality
grading, the precise `rank(dF) < dim M_EFT` ingredient. -/
theorem forbidden_counterterm_codimension :
    Module.finrank ℂ
        (Matrix (Sum L R) (Sum L R) ℂ ⧸ (LinearMap.ker (diagBlocks (L := L) (R := R))))
      = Fintype.card L ^ 2 + Fintype.card R ^ 2 := by
  have hequiv := LinearMap.quotKerEquivRange (diagBlocks (L := L) (R := R))
  have hrange : LinearMap.range (diagBlocks (L := L) (R := R)) = ⊤ :=
    LinearMap.range_eq_top.2 diagBlocks_surjective
  rw [hequiv.finrank_eq, hrange, finrank_top, Module.finrank_prod,
    Module.finrank_matrix, Module.finrank_matrix]
  simp [sq]

/-! ### A concrete `Fin 1 ⊕ Fin 1` instantiation

The smallest nontrivial chiral square: one left and one right mode.  The ambient
operator space is `4`-dimensional; the forbidden diagonal-mass counterterms span
a `2`-dimensional locus, so the admissible odd operators have codimension `2`. -/

/-- A bare diagonal `L`-mass `m·(e_{ll})` (with `m ≠ 0`) is a forbidden
counterterm: it is not odd. -/
example (m : ℂ) (hm : m ≠ 0) :
    ¬ IsOdd (L := Fin 1) (R := Fin 1)
      (Matrix.of fun a b =>
        match a, b with
        | Sum.inl _, Sum.inl _ => m
        | _, _ => 0) := by
  apply diag_left_nonzero_not_odd _ 0 0
  simpa using hm

/-- In the `Fin 1 ⊕ Fin 1` square the forbidden-counterterm codimension is `2`. -/
example :
    Module.finrank ℂ
        (Matrix (Sum (Fin 1) (Fin 1)) (Sum (Fin 1) (Fin 1)) ℂ
          ⧸ (LinearMap.ker (diagBlocks (L := Fin 1) (R := Fin 1))))
      = 2 := by
  rw [forbidden_counterterm_codimension]; simp

end PhysicsSM.Draft.ForbiddenCounterterm

end
