# S1-CC adversarial finding: the closure grading balances the aperture too

**Date:** 2026-07-08 (all-mass overnight run). **Origin:** Fable call-04
(whole-manuscript strengthening review), adversarial section. **Status:**
numeric-oracle probe + structural argument (MEMO). **Probe:**
`Scripts/oracle/probe_s1cc_aperture_grading.py`.

## The finding in one sentence

On the S1-CC witness's own conventions, the closure bivector grading
`b = sigma_z (x) I` anticonjugates **not only** the closure Krein form
`J Q_C` **but also** the aperture `J Q_A` and turn `J Q_T` forms, so the
**total** operator `J(Q_A + Q_C + 4 Q_T)` is balanced (inertia `(2,2,0)`) on
the physical sector `V'/N` — i.e. the aperture does **not** rescue positivity,
and the resolution's "positivity from the J-definite complement" escape route
**fails on the only witness the program has**.

## Why it is structural, not a witness artifact

The resolution needs `b^{-1}(J Q_C) b = -(J Q_C)` (closure balanced). Writing
everything in the Clifford-`(x)`-color factorization:

- The **closure** block is a bivector on the Clifford factor:
  `Q_C = [gamma_e, gamma_f] (x) (...) ~ sigma_z (x) K` (for a 2-edge rep,
  `[sigma_x, sigma_y] = 2 i sigma_z`), so `Q_C` is `sigma_z`-even.
- For `J Q_C` to be `b`-**odd** (negated), `J` must carry `sigma_x`/`sigma_y`
  Clifford content — i.e. **`J` must anticommute with `b`**. The witness's
  `J = sigma_x (x) I` does exactly this (`J b = - b J`, verified).
- But the **aperture** block is Clifford-**scalar**:
  `Q_A = {gamma_e, gamma_f}(...) = g(e,f) . (transports) = I (x) A`, because the
  anticommutator is a scalar by the Clifford relation `hcl`
  (`{gamma_e,gamma_f} = algebraMap(g e f)`). The **turn** block
  `Q_T = phi^2 = I (x) T` is `Gamma`-even and (when `Gamma = b`, as the program
  asserts) `b`-even. Both are `sigma_z`-**even**.
- Therefore `J Q_A` and `J Q_T` are `sigma_x`-times-(sigma_z-even) =
  `sigma_z`-**odd** = `b`-**negated**, by the *same* `J ⊥ b` that balanced
  closure.

So: **any carrier whose metric `g` is central/scalar (as `hcl` forces) has an
aperture block that is Clifford-scalar, hence balanced by the very grading
that balances closure.** The obstruction follows from the axioms, not from the
smallness of the toy.

## Probe output (exact)

```text
J b = - b J ? True
b^-1 (J Q_C) b = NEGATED       (closure balanced -- expected)
b^-1 (J Q_A) b = NEGATED       (aperture ALSO balanced -- the finding)
b^-1 (J Q_T) b = NEGATED       (turn ALSO balanced)
b^-1 (J Q_A_odd) b = FIXED     (a hypothetical sigma_z-ODD aperture would survive)
b^-1 [J(Q_A+Q_C+4Q_T)] b = -(same) ? True   (whole form congruent to its negative)
sig(J(Q_A+Q_C+4Q_T) |_{V'/N}) = (2, 2, 0)   (balanced on the physical sector)
```

## What it does and does NOT kill

- **Does NOT kill:** the abstract balanced-inertia engine
  (`anticonj_odd_pow_trace_zero`, etc.) is conditional and correct; the
  headline "closure `Q_C` is a balanced Krein square (signature zero)" stands;
  the S1-CC *no-go* half is unaffected.
- **DOES obstruct:** the resolution's *surviving positivity* half (manuscript
  §6 crux #1 / §4 rail 3 / §10 crux 0) — "physical positivity comes from the
  aperture on the J-definite complement." On the witness this is false, and
  the structural argument says it is false for **every scalar-metric carrier
  with `J ⊥ b` and a `b`-invariant physical sector**. Since the metric is
  scalar by `hcl`, and `b` preserves the gauge sectors by construction, the
  escape route as stated has no room.

## The exact structural requirement for a rescue (pre-registered)

A carrier that restores a positive physical sector must break one of the three
premises the obstruction rests on:

1. **Non-scalar aperture:** give `Q_A` genuine `sigma_z`-**odd** Clifford
   content. But `hcl` makes `{gamma,gamma}` central, so this needs the
   aperture to include terms *beyond* the symmetric Clifford part — e.g. a
   larger Clifford factor where `J` and `b` do not exhaust the `sigma_x/sigma_z`
   pair, so that "the grading that balances closure" and "the grading that
   would balance the aperture" are **different** elements.
2. **`J` not anticommuting with `b`:** then closure must be balanced by some
   *other* mechanism (not this `b`-anticonjugation), reopening the S1-CC
   analysis itself.
3. **Non-`b`-invariant physical sector:** then the "b preserves every gauge
   sector" step (used to define balanced inertia on `V'/N`) fails, again
   reopening S1-CC.

The cleanest live hypothesis is (1) with a **larger Clifford algebra** (more
than one soldered edge pair), where the closure bivector and the chirality are
distinct gradings. **This is now the sharpest, most decisive open problem of
the closure channel**, and it is exactly the "one fully-instantiated Krein
model, end to end" that Fable call-04 ranked as the #1 strengthening move: a
genuine multi-edge carrier is needed both to *state* `sector_ground_mass` on
something and to *test* whether any positive sector survives this obstruction.

## Manuscript actions taken

- §6: the adversarial caveat upgraded from "must check" to "checked on the
  witness — escape fails; structural obstruction; rescue requirements pinned."
- §10: added to the kill/finding list at theorem prominence; crux #1 reframed
  as obstructed-on-the-witness with the structural requirement pinned; crux #0
  (`sector_ground_mass`) noted to require a carrier that evades this.
- Grade: pre-registered probe finding (numeric oracle + structural argument);
  NOT a Lean result.
