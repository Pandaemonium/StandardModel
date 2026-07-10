# Summary of changes for run ba852cc1-a0d5-4c85-9efc-fbe1facac853
Delivered `RequestProject/Main.lean` (namespace `LambdaEdgeCount`) and `ARISTOTLE_SUMMARY.md`, formalizing the "everpresent Lambda" scaling law routed through the pierced-null-edge count. The file builds cleanly (~15s) with no `sorry`/`admit`/`native_decide`/new axioms, Mathlib only.

Model: a finite causal region is a `Finset` of pierced null edges; `edgeCount A = A.card` is its discrete 4-volume; `lambdaOf deltaN N = deltaN / N`.

Targets proved:
1. `edgecount_extensive` — `edgeCount (A ∪ B) = edgeCount A + edgeCount B` for disjoint A, B (extensive volume measure); plus `edgecount_mono` (A ⊆ B → edgeCount A ≤ edgeCount B).
2. `lambda_secondMoment_eq_inv_count` — under the Poisson hypothesis `deltaN^2 = N`, `(deltaN/N)^2 = 1/N`.
3. `lambda_rms_eq_inv_sqrt_count` (payload) — `Real.sqrt (N / N^2) = 1 / Real.sqrt N`, using `Real.sqrt_inv` (no numeric sqrt evaluation).
4. `everpresent_verdict` — packages the second moment (1/N) and RMS (1/sqrt N).

Mandatory non-degeneracy at N = 100: `nondeg_poisson_N100` (10^2 = 100), `nondeg_secondMoment_N100` (= 1/100), `nondeg_rms_N100` (= 1/10), and `nondeg_extensive`/`nondeg_counts` on the concrete disjoint edge-sets {0,1,2} (count 3) and {3,4} (count 2) giving 5 = 3 + 2.

Every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>`; all analytic/numeric theorems have footprint `[propext, Classical.choice, Quot.sound]`, and the purely combinatorial `edgecount_mono` has the smaller `[propext, Quot.sound]` (no forbidden axioms). The docstrings state the honest scope: this proves the scaling given the Poisson input and extensive edge count, not the value of Lambda nor the Lambda–V conjugacy, and predicts a fluctuating dark energy. Work committed and pushed.

# claude-lambda-edge-count — the cosmological constant from the null-edge count

`RequestProject/Main.lean` (namespace `LambdaEdgeCount`) formalizes the
"everpresent Lambda" scaling law `Lambda ~ 1/sqrt(N)` routed through the
pierced-null-edge count `N` of a finite causal region.

## Model

* A finite causal region is modeled by its finite set of pierced null edges
  (`Finset α`).
* `edgeCount A = A.card` is its discrete 4-volume.
* `lambdaOf deltaN N = deltaN / N` is the normalized cosmological constant
  (over `ℚ`).

## Results (all kernel-checked, no `sorry`/`admit`/`native_decide`/new axioms)

1. **`edgecount_extensive`** — additivity over disjoint sub-regions:
   `edgeCount (A ∪ B) = edgeCount A + edgeCount B` when `Disjoint A B`.
   Companion **`edgecount_mono`** gives monotonicity: `A ⊆ B → edgeCount A ≤ edgeCount B`.
2. **`lambda_secondMoment_eq_inv_count`** — under the Poisson discreteness
   hypothesis `deltaN^2 = N`, the second moment is `(deltaN/N)^2 = 1/N`.
3. **`lambda_rms_eq_inv_sqrt_count`** (payload) — the RMS magnitude is
   `Real.sqrt (N / N^2) = 1 / Real.sqrt N` (via `Real.sqrt_inv`, no numeric
   sqrt evaluation).
4. **`everpresent_verdict`** — packages the second moment (`1/N`) and RMS
   (`1/sqrt N`) together.

## Non-degeneracy (`N = 100`)

* `nondeg_poisson_N100 : (10:ℚ)^2 = 100`
* `nondeg_secondMoment_N100 : (lambdaOf 10 100)^2 = 1/100`
* `nondeg_rms_N100 : Real.sqrt ((100:ℝ)/100^2) = 1/10`
* `nondeg_extensive` / `nondeg_counts` — extensivity on two concrete disjoint
  edge-sets `{0,1,2}` (count 3) and `{3,4}` (count 2), giving total 5 = 3 + 2.

## Axiom footprint

Each headline carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>`. All numeric/analytic
theorems have footprint `[propext, Classical.choice, Quot.sound]`; the purely
combinatorial `edgecount_mono` has the smaller `[propext, Quot.sound]`. No
forbidden axioms are used anywhere.

## Honest scope

This proves the SCALING law given the Poisson input (`deltaN^2 = N`) and the
extensive edge count. It does NOT derive the value of Lambda nor the Lambda–V
conjugacy (imported physical input), and it predicts a FLUCTUATING dark energy.
