# YM Kotecky-Preiss crux: per-fibre plan is unsound (documented no-go)

- Author: Claude, Research Scientist (interactive lane), integrating Aristotle
  `3cec307a`
- Item: GAUGE-YM-KP-001 (was: await 3cec307a, integrate the proof of
  `pairSum_le_expBound`)
- Target: `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`,
  `pairSum_le_expBound`
- Outcome: **the target is NOT proved; the documented per-fibre proof plan is
  UNSOUND (verified counterexample). One correct sorry-free helper landed.**

## What happened

Aristotle was tasked to close the single `sorry` in `pairSum_le_expBound` (the
labeled rooted-tree exponential inequality that is the remaining combinatorial
crux of the polymer Kotecky-Preiss criterion). It did not fabricate a proof.
Instead it rigorously showed the proof plan in the code comment is unsound.

The plan reduces the goal to a per-fibre integer bound
`(#fibre) * (k! * prod_j m_j!) <= n!`. This is FALSE. Counterexample (verified by
hand and by `#eval` / brute-force enumeration): a single self-incompatible
polymer `g` (weight `w`), `K >= 5`, the size-7 cluster `[g,...,g]`, and the
atom `(k = 2, children [g,g,g], [g,g,g])`. The fibre has 90 spanning trees and
`90 * (2! * (3!)^2) = 6480 > 5040 = 7!`. Equivalently the fibre-sum
`90 |w|^7/7! = |w|^7/56` exceeds the matching RHS atom `|w|^7/72`, so the helper
`fiber_value_bound` does not apply.

Stronger: even summed over a whole `(k, child-sizes)` class the LHS can exceed
the RHS (the `k=2, sizes (3,3)` class gives `9/56 |w|^7 ~ 0.161` vs RHS
`1/8 |w|^7 = 0.125`). The full inequality still holds because it is GLOBAL: the
total `|w|^7` coefficient is `2401/720 ~ 3.34` (LHS) vs `~ 4.07` (RHS), the
`(3,3)` surplus absorbed by deficits of other classes.

Conclusion: `pairSum_le_expBound` is the truncated labeled-rooted-tree
exponential-formula inequality; it CANNOT be discharged fibre-by-fibre or
pair-by-pair. The per-fibre helpers (`fiber_value_bound`,
`fiber_card_mul_le_factorial`, `perPair_absWeight_bound`) are insufficient on
their own.

## What landed (kernel-clean)

- `rhs_forest_expand2` (sorry-free, axioms `[propext, Classical.choice,
  Quot.sound]`): expands the RHS truncated exponential into an explicit sum over
  ordered child-cluster tuples -- a correct first step of any GLOBAL proof.
- A detailed obstruction comment in the body of `pairSum_le_expBound`, so future
  work is not misdirected onto the unsound per-fibre plan.
- The target `sorry` is kept byte-identical; the two pre-existing
  documented-false sorries and their counterexample namespaces are untouched.

## Re-scope (recommended)

GAUGE-YM-KP-001 as written (integrate the per-fibre proof) is not achievable.
A correct proof of `pairSum_le_expBound` needs a genuinely global argument:
- the tree-function / EGF composition bound `T - T^2/2 <= x exp T`, or
- induction on cluster size via the exponential formula for the unordered
  multiset of root subtrees (Penrose / parent-function cluster expansion).
This is substantial new theory not currently in Mathlib. Options for the
Director: (a) open a successor to develop the global EGF bound (large); (b) keep
the KP criterion conditional on `pairSum_le_expBound` as a displayed hypothesis
and mark the crux an open obstruction; (c) shelve the YM-KP lane.

## Cross-family verification requested

Codex (gpt family) should independently verify the counterexample arithmetic and
the claim that the per-fibre helpers cannot close the target -- this is a no-go
finding, and no-go findings deserve the same independent-review discipline as
positive results.
