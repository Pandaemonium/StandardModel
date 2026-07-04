# Aristotle proof job: YM1 comb-gauge plaquette coordinatization of the 2D open rectangle

Standalone Mathlib-only Lean 4 target. Repo pinned toolchain:
leanprover/lean4:v4.28.0. Target file:
`Ym1TreeGauge/RectCoordinatization.lean`. Run
`lake env lean Ym1TreeGauge/RectCoordinatization.lean` first (fast,
Mathlib-only); do not attempt a full project build (this package
intentionally has no dependencies beyond Mathlib).

## Context (assume you are blind to the source repository)

This is the last geometric layer of a kernel-checked finite-group 2D lattice
Yang-Mills area-law chain. The parent repository has already proved, against
the abstract `PlaquetteCoordinatization` interface copied verbatim into the
target file: the link-ensemble partition function factorizes as
`|G|^(tree links) * (single-plaquette sum)^(number of plaquettes)`, and the
link-ensemble Wilson-loop expectation equals
`chi_R(1) * gamma^(area)` exactly. All of that is generic. The ONLY missing
piece is the concrete instance this package asks for: the comb-gauge
change of variables on the `Lx x Ly` open (free-boundary) rectangle.

## What to do

1. Replace the single `s o r r y` (spelled normally in the file) in
   `rectCoordinatization` with a construction. Everything else in the file
   already compiles; the conventions (link orientations, plaquette walk,
   holonomy parenthesization, tree choice) are pinned in the module
   docstring and kernel-pinned by the `rfl` lemma
   `rectPlaquette_hol_formula` - keep that lemma compiling unchanged.
2. The designed-in easy path (see the target's docstring): take
   `coord := Equiv.ofBijective toCoord hbij` with
   `toCoord U := (fun p => (rectPlaquette Lx Ly p).hol U, fun t => U (treeLink Lx Ly t))`,
   which makes the interface field `hol_coord` definitional (`rfl`). Then
   the entire content is `Function.Bijective toCoord`, which you can get
   from injectivity plus `Fintype.bijective_iff_injective_and_card`
   (cardinalities: both sides are functions from types of equal finite
   cardinality `2*Lx*Ly + Lx + Ly` into `G`, via `Fintype.card_fun`,
   `Fintype.card_sum`, `Fintype.card_prod`, `Fintype.card_fin`), or from an
   explicit per-row recursive inverse - your choice.
3. Injectivity sketch (row independence is the key structural fact): two
   link fields with equal tree restrictions agree on all horizontal links
   and on the leftmost vertical column (`i = 0`). If they also have equal
   plaquette holonomies, then by induction along `i : Fin (Lx+1)` (per row
   `j`), they agree on vertical column `i`: the induction step solves the
   vertical link `(i+1, j)` from the plaquette holonomy at `(i, j)` and the
   three links already known equal, using `rectPlaquette_hol_formula`
   (group cancellation; note the formula's exact parenthesization).
4. Do NOT weaken the statement: no added hypotheses (no abelian `G`, no
   `Nonempty`, no `DecidableEq` beyond what instances already provide), do
   not replace the `Equiv` by an injection or a cardinality claim, do not
   alter any definition or the pinned `rfl` lemma. If the general case
   truly stalls, an explicitly-labeled fallback is acceptable: the same
   statement specialized to `Lx = 1` as a new
   `rectCoordinatizationOneColumn`, with the general target left as a
   documented `s o r r y` and a failure note saying exactly where the
   general induction broke.
5. Sanity self-check before finishing: for `Lx = Ly = 1` and `G = Multiplicative (ZMod 2)`
   (or any small group), the two sides of the equivalence have cardinality
   `|G|^4` (four links: two horizontal, two vertical) and
   `|G|^1 * |G|^3` (one plaquette; tree = two horizontal + one leftmost
   vertical). If your construction fails this count, the construction is
   wrong, not the target.

## Success criteria

- `lake env lean Ym1TreeGauge/RectCoordinatization.lean` passes with zero
  `s o r r y` / `a d m i t` / new `a x i o m` and no `n a t i v e _ d e c i d e`.
- `rectPlaquette_hol_formula` still compiles unchanged.
- `#print axioms Ym1TreeGauge.rectCoordinatization` reports at most
  `[propext, Classical.choice, Quot.sound]`.

## Output format

Return the completed `Ym1TreeGauge/RectCoordinatization.lean`. If you added
helper lemmas, keep them in the same file, above the target, each with a
docstring. If you could not complete the general case, return the file with
the fallback (if achieved) plus a short failure note at the bottom of the
module docstring: exact failing goal, what was tried, suspected missing
lemma.
