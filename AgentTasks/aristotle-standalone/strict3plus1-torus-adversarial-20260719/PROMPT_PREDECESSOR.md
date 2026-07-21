# Task: the strict 3+1 zero-or-pi combined doubling gate (frontier successor)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, strict local 3+1
Dirac quantum-cellular-automaton lane (Paper B: locality, doubling, and
onsite mass). Self-contained package; the whole landed frontier layer is
included (`Strict3Plus1Frontier.lean` and its import chain, all PROVEN
except the one intentionally parked historical hole `admissible_doubling`,
which you must NOT attempt in its zero-only form).

## Target

`PhysicsSM/Draft/NullEdge/Strict3Plus1FrontierSuccessor.lean` - three
targets, pre-registered ladder:

1. `doubling_from_combined_balance` - mechanical: same finite counting
   argument as the proved `doubling_from_balance` (in the frontier file),
   with the combined predicate `ZeroOrPiAlias U q = (det (U q - 1) = 0 or
   det (U q + 1) = 0)`.
2. `splitStep_combined_corner_census` - concrete finite census on the LIVE
   massless successive-axis walk `splitU`: exhibit a finite momentum set S
   containing the origin, all combined crossings, with an explicit integer
   charge summing to zero, nonzero at the origin, and `1 < S.card`.  The
   four even-parity zero-crossing corners are already landed
   (`split_step_zero_mode_doubling`); a minimal solution takes S = those
   four corners with charges (+1, -1, +1, -1) if the origin charge can be
   normalized nonzero - any honest explicit choice satisfying the stated
   conjuncts is acceptable.  If the odd-parity corners carry pi-crossings
   and make a more natural census, extend S honestly.
3. `admissible_doubling_zero_or_pi` - the RESEARCH FRONTIER: every
   `AdmissibleWalk` (exactly unitary, 2pi-periodic, continuous, `U 0 = 1`,
   three exact Dirac tangents) has a second, nonzero momentum with a
   zero-or-pi crossing.  Intended route: target 1 fed by a canonical chiral
   charge with a Brillouin-zone balance law - a clean-room port of the
   degree/winding theorem for `q |-> det (U q - 1) * det (U q + 1)` on the
   3-torus - plus a nonzero origin charge from the Dirac tangents.  Use
   Mathlib's degree theory / winding-number / compactness infrastructure as
   available.

## Honesty protocol (pre-registered)

- Target 3 is allowed to FAIL: if the degree-theorem port is out of reach,
  prove targets 1-2, leave target 3's hole documented, and return a precise
  proof-plan report: candidate charge construction, exact missing
  ingredients (with Mathlib names if they exist), and a decomposition into
  at most 3 follow-up lemmas.
- A kernel COUNTEREXAMPLE to target 3 (an admissible walk with no second
  combined crossing) would be a first-class result - report it prominently,
  do not suppress it.
- Do not modify `Strict3Plus1Frontier.lean` or attempt its parked zero-only
  hole. Do not weaken the successor statements.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/Strict3Plus1FrontierSuccessor.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

Targets 1-2 proven with zero holes; target 3 proven, refuted, or returned
with the documented hole plus the required proof-plan report.  Completion
report: solved targets, statement changes, remaining holes, axioms used.
