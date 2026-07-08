# S1-CC presentation: prove the physical-sector b-eigenbasis EXISTENCE lemma

## What this package is

A self-contained Lean 4 package (Mathlib + four small `src/` files, all building
under the pinned toolchain) from a formalization program on finite null-edge
Dirac algebra. You are blind to the wider repo; everything you need is here.

The physics context (for intuition only — the Lean is self-contained): a "closure
Krein form" `M = J Q_C` on a finite carrier is shown to be **balanced** (equal
numbers of positive and negative eigenvalues) on the physical Gauss-law sector
`V'/N = ker Q_G / range Q_G`, which is a no-go for closure-channel positivity.
The balance mechanism is a `±1` grading `b = diagonal d` (the closure bivector
`σz ⊗ 1`) that anticonjugates the form: `b * M * b = -M`.

## What is ALREADY PROVED (no `sorry`, kernel-checked in this package)

`src/S1CCGeneralReduction.lean` contains, fully proved:

- `compression_balanced` — for any coordinate representative selection `r : κ → ι`
  and any `±1` grading anticonjugating `J`, the submatrix `J.submatrix r r` is
  balanced.
- `compression_balanced_eigbasis` — the **presentation-independent** strengthening:
  for a Hermitian `M` anticonjugated by `diagonal d` (`±1`), and **any**
  `b`-eigenvector family `P : Matrix ι κ ℂ` with `diagonal d * P = P * diagonal e`
  (`e` a `±1` grading) and `hB : (Pᴴ * M * P).IsHermitian`, the compression
  `Pᴴ * M * P` is balanced.

So compression of `M` in *any* `b`-eigenbasis of the physical sector is already
proved balanced. The last remaining gap is **existence** of such a basis.

## Your target (`src/S1CCPresentationExistence.lean`)

That file has TWO theorems. The second, `physical_sector_balanced` (the prize —
"the physical-sector closure form is balanced for the whole scalar-metric class"),
is **already proved MODULO the first**: it obtains the eigenbasis, checks
`Pᴴ M P` is Hermitian, and applies `compression_balanced_eigbasis`. It compiles.

The first, `physical_sector_b_eigenbasis_exists`, is a **documented `sorry`** — it
is the ONLY thing you must prove:

```
theorem physical_sector_b_eigenbasis_exists
    (d : ι → ℂ) (hd : ∀ i, d i = 1 ∨ d i = -1)
    (QG : Matrix ι ι ℂ) (hQGherm : QG.IsHermitian) (hQGnil : QG * QG = 0)
    (hbQG : diagonal d * QG = QG * diagonal d) :
    ∃ (κ : Type) (_ : Fintype κ) (_ : DecidableEq κ)
      (P : Matrix ι κ ℂ) (e : κ → ℂ),
      (∀ j, e j = 1 ∨ e j = -1) ∧
      diagonal d * P = P * diagonal e ∧      -- columns of P are b-eigenvectors
      Pᴴ * P = 1 ∧                            -- orthonormal
      QG * P = 0                              -- columns in ker Q_G
```

The mathematics: `b = diagonal d` is a self-adjoint `±1` involution commuting
with the Hermitian nilpotent `Q_G`. Hence `ker Q_G` is `b`-invariant, `b`
restricts to a self-adjoint involution on `ker Q_G`, and a self-adjoint
involution on a finite-dimensional complex inner-product space is orthogonally
diagonalizable into its `±1` eigenspaces. Choosing an orthonormal `b`-eigenbasis
of `ker Q_G` gives exactly a `P` with the four properties above (columns in
`ker Q_G`, orthonormal, `b`-eigenvectors).

Note: the version above only asks that the columns lie in `ker Q_G` and are
orthonormal `b`-eigenvectors. That is enough to make `physical_sector_balanced`
type-check and fire, but it does **not yet** pin `range P` to a *complement of
`range Q_G`* inside `ker Q_G` (i.e. it does not exclude a sub-basis). If it is
convenient, please ALSO strengthen the statement so that `P` spans a complement
of `range Q_G` in `ker Q_G` (dimension `dim ker Q_G − rank Q_G`), which is what
genuinely "presents `V'/N`"; adjust `physical_sector_balanced` accordingly. If
that is materially harder, deliver the `ker Q_G` version first (it is already a
real theorem: closure is balanced on all of `ker Q_G`), and note the quotient
refinement as a follow-up.

## Constraints (hard)

- Use the pinned Lean 4 + Mathlib toolchain you scaffold for this package; the
  `src/` files already build under it. Do not change the toolchain.
- **No `sorry`, no `admit`, no new `axiom`, no `native_decide`** in the final
  `physical_sector_b_eigenbasis_exists` proof. Kernel-checked only. The intended
  axiom footprint is `[propext, Classical.choice, Quot.sound]`.
- Do not weaken `compression_balanced_eigbasis` or the other proven lemmas.
- Prefer restating the existence lemma in whatever setting (raw `Matrix`,
  `LinearMap`/`Submodule`, `EuclideanSpace`, spectral theorem for
  `Matrix.IsHermitian` involutions) is cleanest — as long as the FINAL exported
  statement still lets `physical_sector_balanced` fire (or you provide an adapted
  `physical_sector_balanced` with the same meaning). Search Mathlib for existing
  API on self-adjoint involutions / orthogonal projections / invariant subspaces
  before building from scratch (e.g. an involution `b` gives a projection
  `(1+b)/2`; simultaneous block structure of commuting normal operators).

## Deliverable / output format

1. The completed `src/S1CCPresentationExistence.lean` (or a cleanly restated
   equivalent), building with no `sorry`.
2. `#print axioms physical_sector_balanced` output confirming the footprint.
3. A short `ARISTOTLE_SUMMARY.md`: the final statement(s), the proof strategy,
   which Mathlib lemmas carried the diagonalization, and — if you used the
   `ker Q_G` version rather than the full `V'/N` complement — exactly what is and
   is not yet captured, so the reviewing agent can grade the claim honestly.

If you get fully stuck on existence, deliver the strongest partial (e.g. the
`(1+b)/2` projection reformulation, or the existence of the `±1` eigenspace
decomposition of `b|ker Q_G`) plus a precise proof plan and the blocking lemma.
