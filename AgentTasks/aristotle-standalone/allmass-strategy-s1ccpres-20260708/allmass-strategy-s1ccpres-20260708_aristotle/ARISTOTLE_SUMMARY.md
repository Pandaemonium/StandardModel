# Summary of changes for run 158f3e38-6542-44a4-bb41-66a46475ba76
Closed the single documented `sorry` (`physical_sector_b_eigenbasis_exists`) in `src/S1CCPresentationExistence.lean`, and, following the reviewer correction, delivered a **non-vacuous** statement rather than the trivial empty-`κ` one.

Key mathematical point: the two Lean hypotheses on the Gauss charge — `QG.IsHermitian` and `QG * QG = 0` — together force `QG = 0` over ℂ with the definite conjugate-transpose adjoint (a Hermitian matrix `A` has `Aᴴ = A`, so `A*A = 0` gives `Aᴴ*A = 0`, and `Matrix.conjTranspose_mul_self_eq_zero` yields `A = 0`). This is isolated as the helper lemma `isHermitian_sq_eq_zero_imp_eq_zero`. Consequently `range Q_G = 0`, `ker Q_G` is the whole carrier, and the physical sector `V'/N = ker Q_G / range Q_G` is the entire space.

The existence theorem was strengthened with two clauses that exclude vacuity and pin the full physical dimension:
- `Fintype.card κ = Fintype.card ι - 2 * QG.rank` (full physical dimension; here `= Fintype.card ι` since `rank Q_G = 0`), and
- a spanning clause `∀ v, QG *ᵥ v = 0 → ∃ w, v = P *ᵥ w`,
in addition to the original four (`±1` eigenvalues, `diagonal d * P = P * diagonal e`, `Pᴴ * P = 1`, `QG * P = 0`). Because `b = diagonal d` is already diagonal with `±1` entries and `ker Q_G` is the whole carrier, the standard basis (`κ = ι`, `P = 1`, `e = d`) is a genuine full-dimensional orthonormal `b`-eigenbasis of `ker Q_G`; `card κ = card ι`, so the empty-`κ` witness is excluded.

The prize theorem `physical_sector_balanced` is unchanged in meaning and still fires via the already-proved `compression_balanced_eigbasis` (no weakening of any existing lemma).

Verification: the project builds (only a deliberate `unused variable hbQG` linter warning — the commuting hypothesis is retained as part of the intended statement, noted in the docstring). No `sorry`/`admit`/`native_decide`/new `axiom`. `lean_verify` and in-file `#guard_msgs` confirm the axiom footprint `[propext, Classical.choice, Quot.sound]` for both `physical_sector_b_eigenbasis_exists` and `physical_sector_balanced`.

`ARISTOTLE_SUMMARY.md` documents the final statements, the proof strategy, exactly how the empty-`κ` vacuity is excluded, and an honest caveat: under these (definite-inner-product) hypotheses `Q_G` collapses to `0`, so the general simultaneous-diagonalization machinery is not exercised; a genuinely nontrivial sector would require stating `Q_G`'s self-adjointness with respect to the indefinite Krein form instead. All work is committed and pushed.

# S1-CC physical-sector `b`-eigenbasis existence — completion summary

## What was asked

Close the single documented `sorry`
(`physical_sector_b_eigenbasis_exists`) in
`src/S1CCPresentationExistence.lean`, non-vacuously, so that the physical-sector
closure balance becomes a fully general kernel theorem. Kernel-checked only: no
`sorry`/`admit`/new `axiom`/`native_decide`; target axiom footprint
`[propext, Classical.choice, Quot.sound]`.

## Key mathematical observation (why the sector is the whole carrier)

The hypotheses on the Gauss charge are, in Lean:

* `hQGherm : QG.IsHermitian` (self-adjoint w.r.t. the **definite** inner product
  `Pᴴ P`), and
* `hQGnil  : QG * QG = 0`.

Over `ℂ`, with the standard (positive-definite) conjugate-transpose adjoint,
these two together **force `QG = 0`**:

> a Hermitian matrix `A` has `Aᴴ = A`, so `A * A = 0` gives `Aᴴ * A = 0`, and
> `Matrix.conjTranspose_mul_self_eq_zero` yields `A = 0`
> (equivalently: a Hermitian matrix is unitarily diagonalizable with real
> eigenvalues, and `A² = 0` kills all of them).

This is captured by the helper lemma `isHermitian_sq_eq_zero_imp_eq_zero`.

Physically this says that a genuinely *self-adjoint* (definite-inner-product)
BRST charge must vanish — the physical BRST charge is self-adjoint only for the
*indefinite* Krein form, not for the definite form used to define orthonormality
here. So, under **exactly the stated Lean hypotheses**, `range Q_G = 0`,
`ker Q_G` is the whole carrier, and `V'/N = ker Q_G / range Q_G` is the entire
space of dimension `Fintype.card ι = Fintype.card ι − 2·rank Q_G` (`rank 0 = 0`).

## The delivered (non-vacuous) statement

`physical_sector_b_eigenbasis_exists` now produces, in addition to the original
four properties, **two clauses that exclude the trivial/empty witness and pin the
full physical dimension**:

```
∃ (κ : Type) (_ : Fintype κ) (_ : DecidableEq κ) (P : Matrix ι κ ℂ) (e : κ → ℂ),
  (∀ j, e j = 1 ∨ e j = -1) ∧
  diagonal d * P = P * diagonal e ∧            -- columns are b-eigenvectors
  Pᴴ * P = 1 ∧                                  -- orthonormal
  QG * P = 0 ∧                                  -- columns in ker Q_G
  Fintype.card κ = Fintype.card ι - 2 * QG.rank ∧   -- FULL physical dimension
  (∀ v : ι → ℂ, QG *ᵥ v = 0 → ∃ w : κ → ℂ, v = P *ᵥ w)  -- columns SPAN ker Q_G
```

### How the empty-`κ` vacuity is excluded

The empty-`κ` witness satisfies the original four clauses but is killed by the
two new ones:

* `Fintype.card κ = Fintype.card ι - 2 * QG.rank` pins the number of columns to
  the true physical dimension. Since `QG = 0` here, `rank Q_G = 0` and this is
  `Fintype.card κ = Fintype.card ι` — full dimension, not `0` (empty `κ` would
  need `Fintype.card ι = 0`).
* the spanning clause forces the columns of `P` to span all of `ker Q_G`.

Together with `QG * P = 0` (columns in `ker Q_G`) and `Pᴴ * P = 1` (orthonormal,
hence linearly independent), `P` is a genuine **orthonormal `b`-eigenbasis of
`ker Q_G = V'/N`**.

### The witness used

Because `b = diagonal d` is *already diagonal* with `±1` entries and `ker Q_G` is
the whole carrier, the standard basis is an orthonormal `b`-eigenbasis:
`κ = ι`, `P = 1`, `e = d`. Verification of each clause is immediate
(`mul_one`/`one_mul`, `conjTranspose_one`, `QG = 0`, `rank 0 = 0`, `one_mulVec`).

## The prize

`physical_sector_balanced` is unchanged in meaning: it obtains the eigenbasis,
checks `Pᴴ M P` is Hermitian, and applies the already-proved
`compression_balanced_eigbasis` (no weakening of that lemma). With the full-
dimensional `P` above it states that the induced closure form on the physical
Gauss sector is balanced (equal counts of strictly positive and strictly
negative eigenvalues), for the whole scalar-metric class.

## What is and is not captured

* **Captured (proved, kernel-checked):** existence of a full-dimensional
  orthonormal `b`-eigenbasis of `ker Q_G = V'/N`, with the dimension pinned to
  `card ι − 2·rank Q_G` and explicit spanning of `ker Q_G`; and the resulting
  physical-sector balance. Non-vacuous: `card κ = card ι`.
* **Honest caveat:** under the given Lean hypotheses (`QG` Hermitian *and*
  nilpotent w.r.t. the definite inner product) the Gauss charge is forced to
  `0`, so the "complement of `range Q_G` in `ker Q_G`" degenerates (`range Q_G =
  0`) and the sector is the full carrier. The general simultaneous-diagonalization
  machinery (spectral theorem for the involution `b` restricted to a nontrivial
  `ker Q_G`) is therefore not exercised — it is unnecessary here because the
  hypotheses themselves collapse `Q_G`. A genuinely nontrivial physical sector
  would require restating `Q_G`'s self-adjointness with respect to the indefinite
  Krein form rather than the definite `Pᴴ P` product.

## Verification

* `lake build` succeeds (only a benign `unused variable hbQG` linter warning; the
  commuting hypothesis is retained deliberately as part of the intended
  statement, per the docstring note).
* No `sorry` / `admit` / `native_decide` / new `axiom` in the proof.
* `#print axioms` (and `lean_verify`) confirm the footprint for both
  `physical_sector_b_eigenbasis_exists` and `physical_sector_balanced`:
  `[propext, Classical.choice, Quot.sound]` — enforced in-file via `#guard_msgs`.
