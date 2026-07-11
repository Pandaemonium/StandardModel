# Hostile semantic audit — Paper D `growingWindow_countableWeightedL2_tendsto_zero`

**Verdict: PASS WITH REQUIRED SCOPE EDITS.**

The main theorem is sound, non-vacuous, and correctly scoped to countable
coefficient space (it is *not* a Shannon/interpolation, Fourier-isometry,
position-space L² or Dirac-PDE statement, and the docstring says so). But it
carries a redundant hypothesis and over-advertises its proof method, and the
"nonzero control" does not exercise the Sobolev weight. None of these block
integration; they require scope-wording edits and one hypothesis change.

Note: the `PhysicsSM.*` module tree is not present in this project, so the
target could not be built here. Findings below are from the verbatim source
plus independent self-contained Lean re-derivations of the load-bearing steps.

---

## Issue table

| # | Audit item | Severity | Finding |
|---|------------|----------|---------|
| 1 | Vacuity / circular / impossible hyps | — (PASS) | Not vacuous, not circular. Instantiable (the control instantiates it). |
| 2 | `hdom`+`hr` without a nonnegativity assumption on `r` | — (PASS) | Correct. No `0 ≤ r` needed; `hdom` termwise forces the RHS nonneg wherever `bound ≠ 0`, and the direct comparison/squeeze goes through for possibly-negative `r`. Verified. |
| 3 | Single-mode control genuinely instantiates & nonzero at finite `n` | LOW | Genuine instantiation; error is `(1/(n+1))² > 0` at every finite `n`. **But** it lives on the zero mode where `modeRadius 0 = 0`, so the weight `(1+radius)^s` collapses to `1` and `s` is never exercised. |
| 4 | Hollow repackaging of imported Tannery vs. useful new composition | **MEDIUM/HIGH** | `hpoint` is **completely unused**: the conclusion follows from `hdom`+`hr`+`hSob` by comparison + `squeeze_zero` alone. The invocation of `tendsto_tsum_of_dominated_convergence` is unnecessary machinery. As stated it is a weaker (extra-hypothesis) wrapper around a one-line comparison, not a new composition. |
| 5 | Docstring / kernel mismatch | LOW | Kernel statement matches the prose *claim*, but the module bills itself as the "dominated-convergence rung" while the result needs no dominated convergence (monotone comparison suffices). Provenance line asserts independent compilation, which cannot be checked in this repo. |
| 6 | Missing hyps to instantiate with the live quartic 3+1 walk error | **HIGH** | The theorem's domination shape `‖err n k‖² ≤ r n·(1+radius)^s‖f k‖²` is *not* what the upstream `quartic_window_many_step_bound` provides. Real gaps listed below. This is the actual composition gate. |
| 7 | Manuscript wording + smallest next theorem | — | Provided below. |

---

## Detail

### (2) `r` needs no nonnegativity — confirmed
The file's proof uses `hr.eventually_le_const` to get `r n ≤ 1` eventually and
then `nlinarith [0 ≤ bound k]`. Independently, the whole theorem is provable by:
```
∑' k ‖err n k‖² ≤ ∑' k r n · bound k = r n · (∑' bound)  → 0.
```
`squeeze_zero` (0 ≤ ∑ ≤ r n·C, r n·C → 0) closes it. If `r n < 0` for some `n`
with a positive `bound k`, `hdom` is simply contradictory at that `n`, so no
`0 ≤ r` assumption is missing. **No omitted nonnegativity on `r`.**

### (4) `hpoint` is redundant — confirmed by re-derivation
A self-contained Lean proof closes the identical conclusion from only
`hr`, `hSob` (summable `bound`), and `hdom` — with **no** pointwise-limit
hypothesis, and even without a standalone `0 ≤ bound` assumption (it follows
termwise from `hdom`). Consequences:
- `hpoint` should be **dropped** from the statement (it is dead weight and
  makes the theorem strictly weaker than provable).
- The "dominated convergence / Tannery rung" framing is inaccurate; this is a
  monotone comparison + squeeze. Either rename/re-scope the module, or (better)
  keep Tannery only if a *future* version genuinely needs a non-monotone bound.
- As currently written it is closer to hollow repackaging than a new
  composition. Dropping `hpoint` and stating it as the comparison lemma it
  really is turns it into an honest, reusable rung.

### (3) control does not test the weight
`weighted_single_mode_control` uses `f = δ₀`, `s = 2`, and evaluates at the
zero mode, where `modeRadius 0 = 0 ⇒ (1+0)^2 = 1`. So the polynomial Sobolev
weight is never nontrivially engaged. Strengthen by placing the occupied mode
at a nonzero radius (e.g. `q = ((1,0),0)`, `modeRadius q = 1`, weight `2^s`),
which exercises `s` and still gives nonzero finite-`n` error.

### (6) what is actually missing to feed the live quartic error
`quartic_window_many_step_bound` yields, for a *single* momentum tuple with
`B4(kx,ky,kz,m) ≤ K` and `n = K⁴`,
```
‖(splitStep …)^n − exactFlow …‖ ≤ 2 t²/K² · exp(|t|/K³),
```
an **operator/propagator** bound that (a) does not carry `‖f k‖`, (b) does not
carry the weight `(1+radius)^s`, and (c) **only holds while `B4 ≤ K`** — i.e.
it fails on the high-radius tail of any fixed `K⁴` window. To instantiate
`growingWindow_countableWeightedL2_tendsto_zero` you must supply:

1. **Mode→momentum embedding + action identity.** A map `Mode → (kx,ky,kz,m)`
   and the identity `err n k = (splitStep^{…} − exactFlow) (f k)`, converting
   the operator bound into `‖err n k‖ ≤ (rate n)·‖f k‖`.
2. **A mode-uniform bound covering `radius > K`.** The sharp rate is valid only
   for `B4(k) ≤ K`; high modes need a crude fallback (e.g. `‖splitStep^n‖ ≤ 1`
   and `‖exactFlow‖ = 1 ⇒ ‖err‖ ≤ 2`). The single scalar `r n` in the current
   statement cannot be uniform across all modes unless `s > 0` absorbs the
   radius growth **or** the error is cut off outside `modeBox` (using
   `residual_energy_eq_tail` / `outside_mode_killed` from `SobolevTailRate`).
3. **`B4` ↔ radius comparison.** A lemma `B4(k) ≤ c·(1 + modeRadius k)` (linear
   in the max-coordinate radius) so `B4 ≤ K` becomes a statement about the box,
   letting the weight power `s` dominate the tail.
4. **A concrete scalar rate** `r n := (2 t²/K² · exp(|t|/K³))²` (with `n=K⁴`),
   already shown `→ 0` upstream, matched to the squared-norm form.
5. **`hSob` for the actual wavepacket** `f`: summability of
   `(1+radius)^s ‖f k‖²` for the packet whose coefficients are being propagated.

`hpoint` for the packet is free from `quartic_window_error_tendsto_zero`, but
per (4) it is not even needed.

### (7) required manuscript wording + smallest next theorem

**Required scope wording (add near the theorem / in the module docstring):**
> "This lemma is a countable coefficient-space comparison: given a scalar rate
> `r n → 0` and a *single, `n`-independent, summable* Sobolev-weighted envelope
> dominating every modewise squared error, the total squared coefficient error
> vanishes. It assumes the modewise error has already been reduced to the
> weighted form `‖err n k‖² ≤ r n·(1+radius)^s‖f k‖²` uniformly in `k`
> (including the high-radius tail). It does **not** perform the operator→
> coefficient reduction, does not cut off the tail, and does not identify any
> physical map. Pointwise convergence is not required; the bound is monotone."

Also correct the "dominated-convergence rung" phrasing to "monotone comparison
rung," and drop the redundant `hpoint` argument (or explicitly mark it as
retained-but-unused with justification).

**Smallest next theorem (the true next gate):** a bridge lemma
```
B4_le_modeRadius : ∀ k : Mode, B4 (embed k) ≤ c * (1 + modeRadius k)
```
(with `c` explicit), followed by a wrapper that, from
`quartic_window_many_step_bound` + a crude `‖err‖ ≤ 2` tail bound, produces the
`hdom` instance `‖err n k‖² ≤ r n·(1+radius)^s‖f k‖²` for a fixed
Sobolev-summable packet — i.e. a theorem whose statement is exactly the
hypotheses of `growingWindow_countableWeightedL2_tendsto_zero` discharged for
the live quartic walk. Prove `B4_le_modeRadius` first; it is small, purely
arithmetic, and unblocks everything above.
