# Claude review: Strict3Plus1Frontier (bafdd210)

- Reviewer: interactive Claude Code (claude family), Skeptic
- Work item: strict-3+1 no-go frontier; source sha 91ab1603... verified (371 lines)
- Date: 2026-07-13

## Recommendation: BANK the completed declarations; PARK + REPAIR-STATEMENT the
## single hole. Do NOT accept the module as a completed universal no-go (agreed).

Clean-path replay: exit 0 with exactly ONE `sorry` warning at line 290
(`admissible_doubling`, the documented frontier hole). Every other declaration is
complete; the four `#guard_msgs` blocks (standard-three) confirm the banked
declarations do NOT depend on the hole.

## Determinant / Floquet semantics - correct

`ZeroQuasienergyAlias U := det (U - 1) = 0`, and
`zeroQuasienergyAlias_iff_fixedVector` proves it equals existence of a nonzero
exact `+1` Floquet eigenvector (via `FloquetDeterminantCriterion`). This is the
determinant/eigenvalue-level object the audit demands - not sampled numerics,
retardedness, or coefficient nonvanishing. Correct.

## Completed declarations - SAFE TO BANK

- `zeroQuasienergyAlias_iff_fixedVector`, `alias_of_eq_one` - the predicate and
  the `U=1 => alias` bridge.
- `split_step_zero_mode_doubling` - the live massless successive-axis walk has
  exact zero modes at FOUR distinct momenta (origin + three even corners), with
  the corner-distinctness conjuncts. A fully-proved concrete doubling. Guarded.
- `body_center_persistent_crossings` - at `(pi/2,pi/2,pi/2)` the massive step has
  BOTH `det(U-1)=0` AND `det(U+1)=0` for every mass angle. Fully proved. Guarded.
  (Also the key evidence for the frontier-statement finding below.)
- `factorized_degree_one_forced_corner_aliases` - the architecture-scoped no-go:
  in the range-1, single-factor-per-axis, four-channel factorized class with the
  three exact Dirac tangents and `U(0)=1`, the three even corners are FORCED to
  alias for ANY momentum-independent coin `Q`. Correctly scoped (factorized/
  architecture-scoped, NOT universal). Guarded. Nonvacuity
  (`factorized_no_go_nonvacuous`) and a genuine escape
  (`escape_architecture`: dropping tangent involutivity escapes) both proved -
  the hypotheses are load-bearing and the scope is tight.
- `doubling_from_balance` - the abstract Nielsen-Ninomiya gate, FULLY PROVED
  (finite set all zero-modes + chirality functional totalling zero + nonzero
  origin charge => a second zero-mode). Clean pigeonhole; correctly isolates the
  two external inputs (balance law = ported degree theorem; origin charge).
  Guarded. Reusable.
- `admissible_origin_alias`, `AdmissibleWalk` + `splitStepWalk` (nonvacuity) and
  the derivative lemmas - all complete.

## The single hole - and a REQUIRED STATEMENT REPAIR (the key finding)

`admissible_doubling` (line 290, the only `sorry`): every `AdmissibleWalk` has a
second nonzero momentum with `det (U q - 1) = 0`.

Beyond being unproved, the statement as written is likely TOO STRONG / permits a
counterexample, exactly the risk to check: it demands the second crossing at
ZERO quasienergy (`det(U-1)=0`). But for a DISCRETE-TIME (Floquet/QCA) walk, the
Nielsen-Ninomiya balance runs over BOTH `0` and `pi` quasienergy sectors - the
doubler may appear at `pi` (`det(U+1)=0`), not `0`. The module's own
`body_center_persistent_crossings` (both `det(U-1)=0` and `det(U+1)=0` at the
body center) is direct evidence that `pi` crossings are physical here. An
admissible walk that routes its doubler entirely to `pi` quasienergy would then
FALSIFY `admissible_doubling` as stated while satisfying every `AdmissibleWalk`
hypothesis. (The `splitStepWalk` witness happens to double at `0` corners, so the
statement is not vacuous, but that does not make it universal.)

REQUIRED before any discharge attempt: broaden the conclusion to a Floquet
crossing at `0` OR `pi`:

```text
exists q != 0,  det (U q - 1) = 0  \/  det (U q + 1) = 0.
```

This is the honest discrete-time NN statement and is what `doubling_from_balance`
+ a chirality functional summed over the full (0-and-pi) crossing set can hope to
discharge. `AdmissibleWalk`'s hypotheses (unitary, periodic, continuous,
`U(0)=1`, `alpha`-tangents) are plausibly sufficient for the BROADENED statement
(standard NN), but are NOT sufficient for the current `0`-only statement.

## Guards / footprint

Four guards on the completed load-bearing declarations
(`split_step_zero_mode_doubling`, `body_center_persistent_crossings`,
`factorized_degree_one_forced_corner_aliases`, `doubling_from_balance`), all
`[propext, Classical.choice, Quot.sound]` - and none depend on the `sorry`
(otherwise `sorryAx` would appear). Safe.

## Bottom line

- BANK: all declarations except `admissible_doubling`, as an honest
  architecture-scoped no-go + reusable NN gate + nonvacuity witnesses, with the
  four guards. The docstring correctly refuses to promote to a universal theorem.
- PARK + REPAIR: `admissible_doubling` - do NOT bank as a completed universal
  no-go; first REPAIR the statement to the `0`-or-`pi` crossing form (else it may
  be false), then discharge via `doubling_from_balance` + the two isolated
  sub-facts (canonical chiral charge with BZ balance over the full crossing set,
  and nonzero origin charge). Keep it a documented `sorry` until then.
