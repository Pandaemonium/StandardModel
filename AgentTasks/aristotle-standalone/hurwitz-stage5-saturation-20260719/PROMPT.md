# Task: Hurwitz stage 5 - the saturation endgame (finrank in {1,2,4,8})

Project: Lean 4 (v4.28.0) + Mathlib. Kernel-checked Hurwitz theorem
campaign, final assembly. Self-contained package: stage-1 toolkit (PROVEN),
stage-2 doubling (PROVEN on its tower; two documented Moufang holes remain
upstream of `doubling_closed` - a separate job is closing them; inheritance
through `doubled_isUnitalSubalgebra`/`ladder_step` is accepted and
tracked), stage-3a `orthogonal_forces_associative` (PROVEN, zero holes),
stage-4a ladder theorems (ALL PROVEN, five with zero holes).

## Target

`HurwitzToolkit/Stage5.lean` - seven theorems ending in a hole, ordered as
a ladder. The final one is THE theorem: a nontrivial finite-dimensional
real composition algebra has dimension 1, 2, 4, or 8.

Proof route (pre-registered; the file docstring has the full sketch):

1. `Q_one`: `comp` at `1*1` gives `Q 1 = Q 1 * Q 1`; anisotropy plus
   `(1 : A) ≠ 0` (Nontrivial) excludes `Q 1 = 0`.
2. `spanOne_isUnitalSubalgebra`: closure is scalar arithmetic; conj fixes
   `1` (`conj Q 1 = polar Q 1 1 • 1 - 1` and `polar Q 1 1 = 2 * Q 1 = 2`).
3. `finrank_spanOne`: standard (`finrank_span_singleton`, `one_ne_zero`).
4. `exists_conj_ne_of_one_lt_finrank`: if conj fixed every element of `S`,
   then every `x ∈ S` satisfies `2 • x = polar Q x 1 • 1`, so `S` lies in
   the scalar line, contradicting `1 < finrank`.
5. `doubled_not_commutative`: `a ∈ doubledSubmodule S a` (as `0 + 1*a`) and
   `x ∈` it too; `mul_orthogonal_commute` with `w = 1` gives
   `x * a = a * conj Q x`; commutativity would force
   `a * (conj Q x - x) = 0`, but `Q (a * z) = Q a * Q z` (comp) plus
   anisotropy makes left multiplication by `a` injective.
6. `doubled_not_associative`: witnesses `x, y, a`;
   `mul_mul_orthogonal_right` gives `x * (y * a) = (y * x) * a`; if
   associativity held then `((x * y) - (y * x)) * a = 0`, and right
   multiplication by `a` is injective (comp + anisotropy), contradiction.
7. `hurwitz_finrank_mem`: build the tower from `span {1}` with
   `ladder_step` (stage 4a). At each proper rung double; track dimension
   (1 -> 2 -> 4 -> 8) and structure: the dim-2 rung is conj-nontrivial
   (step 4), so the dim-4 rung is non-commutative (step 5), so the dim-8
   rung is non-associative (step 6). If the dim-8 rung were PROPER,
   `exists_orthogonal_ne_zero` (stage 4a) plus anisotropy plus stage-3a
   `orthogonal_forces_associative` would force it associative -
   contradiction. So the tower must exhaust `A` at dimension 1, 2, 4, or
   8. (Formally: case on which rung equals `⊤`; `finrank_doubled` gives
   the dimension bookkeeping; `Submodule.finrank_eq_top`-style lemmas
   convert `S = ⊤` to `finrank S = finrank A`.)

## Honesty protocol (pre-registered)

- Do NOT weaken `hurwitz_finrank_mem`. If an intermediate needs an extra
  standard hypothesis, add it explicitly, record it prominently, and keep
  the endgame exact.
- Intermediate helper lemmas (e.g. `a ∈ doubledSubmodule S a`, injectivity
  of multiplication by an anisotropic element, commutativity of the dim-2
  rung if you route through it) are welcome deliverables.
- If the tower induction resists full formalization, prove targets 1-6
  plus the dim-8 contradiction as a standalone conditional
  (`proper-dim-8-nonassociative rung is impossible`) and return a precise
  report of the remaining assembly gap.
- Accepted inheritance: anything routed through `doubling_closed` carries
  the two documented Stage2 Moufang holes; do not attempt those two
  lemmas here.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only, apart from the accepted Stage2 inheritance.
- Do not modify Target/Stage2/Stage3/Stage4.
- Verify with `lake env lean HurwitzToolkit/Stage5.lean` first.

## Success criteria

`hurwitz_finrank_mem` proven (with only the accepted inheritance) is FULL
SUCCESS - the campaign's headline. Targets 1-6 plus a precise assembly
report is partial success. Completion report: solved targets, helpers
added, statement changes, axioms used.
