# Summary of changes for run 8bcdf750-37a7-4662-8e4f-484be1aea670
Delivered `RequestProject/Main.lean` (namespace `LambdaCountDichotomy`) and `ARISTOTLE_SUMMARY.md`. The file builds kernel-checked with no `sorry`/`admit`/`native_decide` and no new axioms; every headline theorem has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]` (also independently verified).

Setup: `E w f = ∑ x, w x * f x` and `Var w f = E w (f²) − (E w f)²` over finite spaces with rational weights, plus reusable building blocks (independence factorization, additivity of expectation/variance for independent products, variance of a constant).

Targets proved (finite, explicit rational distributions):
1. `free_variance_extensive`: for `n` independent edges with occupancy `p`, `Var(N) = n·p·(1−p)` (extensive), for all `n` by induction over `Fin n → Bool`; with `free_E : ⟨N⟩ = n·p`.
2. `constrained_variance_hard`: uniform `k`-of-`n` (Gauss/neutrality) gives `Var(N) = 0` for every `n` (with `k ≤ n`), `⟨N⟩ = k`; `soft_variance`: soft two-value mixture gives `Var(N) = wt·(1−wt)`, an `n`-independent constant. Both are sub-extensive (`Var/n → 0`).
3. `dichotomy_criterion`: free ⇒ `Extensive` (`Var/n = c > 0`), hard & soft ⇒ `Subextensive` (`Var/n ≤ C/n`). Corollary `everpresent_iff_extensive`: with `Λ²_rms = Var/⟨N⟩²`, `0 < Λ² ↔ 0 < Var` when `⟨N⟩ ≠ 0`; instantiated by `free_everpresent` (Λ² > 0, everpresent) and `hard_suppressed` (Λ² = 0, suppressed).
4. `which_count_matters`: a two-register (edge × charge) model whose Gauss constraint fixes total charge (charge variance 0) while the bare edge count stays free (variance `n·p·(1−p)`) in the same model — so the fork depends on which count Λ is conjugate to.

Explicit witnesses (rationals stated in-theorem): `free_witness` (n=3, p=1/2 ⇒ ⟨N⟩=3/2, Var=3/4, Var/n=1/4), `hard_witness` (2-of-3 ⇒ ⟨N⟩=2, Var=0), `soft_witness` (wt=1/3 ⇒ Var=2/9), `tworeg_witness` (charge-Var 0, edge-Var 3/4).

The summary file records the honest scope note: these are finite witnesses establishing the fork and its criterion, not a computation of the physical ensemble's actual statistics.

# λ-count dichotomy — finite witnesses and the pre-registered kill criterion

All results live in `RequestProject/Main.lean`, namespace `LambdaCountDichotomy`, and build
kernel-checked with no `sorry`/`admit`/`native_decide` and no new axioms. Every headline theorem
carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check confirming the
footprint is exactly `[propext, Classical.choice, Quot.sound]`.

## Setup

* `E w f` — expectation `∑ x, w x * f x` over a finite space with rational weights `w : Ω → ℚ`.
* `Var w f = E w (f²) − (E w f)²` — variance.

Reusable building blocks: `E_prod_cross` (independence factorization), `E_prod_fst`/`E_prod_snd`,
`E_add`, `E_smul`, `Var_add` (variance of an independent sum adds), `Var_prod_fst`/`Var_prod_snd`,
`Var_const_zero`.

## Targets delivered

1. **`free_variance_extensive`** — `n` independent edges, occupancy `p`:
   `Var(N) = n · p · (1−p)`, proportional to `n` (extensive). Proved for all `n` by induction over
   the product space `Fin n → Bool` (with `free_E : ⟨N⟩ = n·p` and `freeW_sum_one`).

2. **`constrained_variance_hard`** — uniform `k`-of-`n` (Gauss/neutrality) on the space of
   `k`-subsets: `Var(N) = 0` for **every** `n` (with `k ≤ n`), and `hard_E : ⟨N⟩ = k`.
   **`soft_variance`** — soft two-value mixture (`k` w.p. `wt`, `k+1` w.p. `1−wt`):
   `Var(N) = wt·(1−wt)`, an explicit constant independent of `n`. Both give `Var/n → 0`.

3. **`dichotomy_criterion`** — with `Extensive V := ∃ c>0, ∀ n≥1, V n / n = c` and
   `Subextensive V := ∃ C≥0, ∀ n≥1, V n / n ≤ C/n`: the free sequence is `Extensive` (for
   `0<p<1`), the hard and soft sequences are `Subextensive`.
   **`everpresent_iff_extensive`** — with `Λ²_rms = Var/⟨N⟩²`, `0 < Λ² ↔ 0 < Var` when `⟨N⟩ ≠ 0`.
   Instantiated by `free_everpresent` (`Λ² > 0`, everpresent) and `hard_suppressed` (`Λ² = 0`,
   suppressed).

4. **`which_count_matters`** — a two-register model (edge occupancy × internal charge). Its Gauss
   constraint fixes total *charge* (charge variance `0`) while the bare *edge* count stays free
   (variance `n·p·(1−p)`) in the *same* model. So the fork's resolution depends on which count
   `Λ` is conjugate to.

## Explicit non-degeneracy witnesses (all rationals in-theorem)

* `free_witness`: `n=3, p=1/2 ⇒ ⟨N⟩ = 3/2`, `Var = 3/4`, `Var/n = 1/4`.
* `hard_witness`: uniform `2`-of-`3` ⇒ `⟨N⟩ = 2`, `Var = 0`.
* `soft_witness`: `wt = 1/3` ⇒ `Var = 2/9` (independent of `n`).
* `tworeg_witness`: `n=3, p=1/2` edges × `2`-of-`3` charge ⇒ charge-`Var = 0`, edge-`Var = 3/4`.

## Honest scope note

These are **finite witnesses** that establish the FORK and its criterion — they exhibit both
branches concretely and prove the pre-registered extensive-vs-subextensive dichotomy. They are
**not** a computation of the physical ensemble's actual edge-count statistics; deciding which
branch the everpresent-Λ mechanism actually lands in is the follow-up oracle probe.
