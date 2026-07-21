# Opus audit: the massive HNU continuum reduction ladder (MC1-MC6)

Date: 2026-07-20
Role: Opus / Claude (interactive) - independent co-executor audit
Item: CONT-FOURIER-001 (assignment msg-20260720-133903-816793d5)
Scope: analysis and theorem design only. No Codex-owned Lean was edited.

Audited against `AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_MASSIVE_DIRAC_CONTINUUM_2026-07-20.md`
and the live sources `Pluecker3Plus1ComplexMass.lean`, `Compact3Plus1DiracRate.lean`.

## Headline verdicts

1. **MC1 sign and normalization are CORRECT.** No mismatch. Verified independently.
2. **MC1 does not need its `z != 0` hypothesis** - it holds unconditionally under
   Lean's division convention. Cheaper statement available.
3. **`Compact3Plus1DiracRate.trotter_step` CAN be reused cleanly.** It is already
   fully abstract; no new two-factor product estimate need be stated. This
   contradicts the impression left by the memo's kill-condition note.
4. **MC2-MC4 scaffolding already exists** as three abstract landed lemmas.
5. MC1-MC4 look sufficient as stated. **MC5 carries the real hidden assumptions**;
   MC6 is honest but is an identification, not a convergence theorem.

## 1. MC1: exact mass exponential - VERIFIED CORRECT

Claim: `massCoin4 z eps = exp ((-eps : Complex) • (I • mass4 z))`.

Live definitions:

```text
mass4 z      = (z.re : C) • beta + (z.im : C) • beta5
massCoin4 z a = (cos (a * ||z||)) • 1 - (I * sin (a * ||z||) / (||z|| : C)) • mass4 z
```

Landed fact `mass4_hermitian_sq z`: `mass4 z` is Hermitian and
`mass4 z * mass4 z = (normSq z : C) • 1`, i.e. `M^2 = ||z||^2 • 1`.

Independent derivation. For any `M` with `M^2 = m^2 • 1` the exponential series
splits into even and odd powers:

```text
exp (-i a M) = cos (a m) • 1 - i * sin (a m) * (M / m).
```

The scalar in MC1 is `(-eps) • (I • mass4 z) = (-i * eps) • mass4 z`, so
`exp` of it is `cos (eps ||z||) • 1 - i sin (eps ||z||) • mass4 z / ||z||`,
which is *syntactically* `massCoin4 z eps`. **Signs, the `I` placement, the
`1/||z||` normalization, and the real-vs-complex casts all match.** MC1 is sound
as written; the "correct the statement rather than force the identity" escape is
not needed.

Anti-overclaim note: this is an identity of *closed forms*, granted
`mass4_hermitian_sq`. It says nothing about the kinetic factor and is not by
itself any continuum statement.

## 2. MC1 strengthening: drop `z != 0` (cheaper theorem)

The memo states MC1 "for nonzero `z`". The hypothesis appears unnecessary:

- `mass4 0 = (0 : C) • beta + (0 : C) • beta5 = 0`;
- hence the second term of `massCoin4 0 a` is `(...) • 0 = 0` regardless of the
  `1/||0||` division (and Lean's `x / 0 = 0` makes the scalar `0` anyway);
- `cos (a * ||0||) = cos 0 = 1`, so `massCoin4 0 a = 1`;
- `exp ((-a) • (I • mass4 0)) = exp 0 = 1`.

Both sides equal `1`, so **MC1 should be stated without `hz : z != 0`**. This
removes a hypothesis from everything downstream that instantiates MC1 and avoids
a spurious side condition in MC3/MC4. Recommend proving the unconditional form.

**SELF-CORRECTION (added after the abstract core was proved, job `d43b43ad`,
landed as `MassiveDiracCoinCore.lean`).** The conclusion above stands for the
concrete `mass4`, but the *reasoning as I first stated it* was too general. The
abstract closed form requires the explicit side condition `m = 0 -> M = 0`; the
squaring relation alone is **not** sufficient. Proved in the core module: if
`M^2 = 0` then `exp (-i a M) = 1 - i a M`, which is `1` only when `(-a i) . M = 0`,
and a concrete nonzero square-zero `4 x 4` matrix witnesses the failure. So the
correct statement of the audit finding is:

> MC1 holds without `z != 0` **because `mass4 0 = 0` discharges the side condition
> `m = 0 -> M = 0`** - not merely because the `1/||z||` term is annihilated.

For `mass4` the side condition is immediate (`mass4 z = z.re . beta + z.im . beta5`),
so the recommendation is unchanged in practice; only its justification is sharpened.

## 3. Reuse question: `trotter_step` - REUSABLE AS IS

Codex asked whether `Compact3Plus1DiracRate.trotter_step` can be reused or a more
abstract two-factor estimate is needed. The live statement is:

```text
lemma trotter_step (P S F A : Mat4) (s a : R)
    (hs : 0 <= s) (ha : 0 <= a) (hS : ||S|| <= s)
    (hPS : ||P - 1 - S|| <= exp s - 1 - s)
    (hFA : ||F - 1 - A|| <= exp a - 1 - a)
    (hF1 : ||F - 1|| <= exp a - 1) (hF : ||F|| <= exp a) :
    ||P * F - 1 - (S + A)|| <= exp (s + a) - 1 - (s + a)
```

It is **abstract in `P, S, F, A`** - nothing about `splitStep`, the split walk, or
the specific axis factors enters. It is exactly the generic "extend a partial
product by one linearized factor, keep the `exp s - 1 - s` envelope" lemma MC3
needs. **No new abstraction is required.**

Important distinction the memo blurs: the kill-condition warns that "the generic
split-walk theorem in `Compact3Plus1DiracRate` is not an HNU theorem". That is
true of **`one_step_to_exact_flow_bound`** (which is about `splitStep` vs
`exactFlow` and is genuinely split-walk-specific). It is **not** true of
`trotter_step`, which is walk-agnostic. Do not discard the abstract lemma along
with the specific one.

## 4. Smallest existing lemmas for MC1-MC3 (cheapest path)

Three already-landed abstract lemmas cover most of the ladder:

| Need | Existing lemma | Abstract? |
|---|---|---|
| Second-order Taylor remainder of `exp` | `norm_exp_sub_one_sub_self_le X : \|\|exp X - 1 - X\|\| <= \|\|X\|\|^2 * exp \|\|X\|\|` | yes, any `Mat4` |
| Two-factor product accumulation (MC3) | `trotter_step` | yes, any `P,S,F,A` |
| Many-step telescoping (MC4) | `unitary_pow_telescope : \|\|U^n - V^n\|\| <= n * \|\|U - V\|\|` | yes, any unitary `Mat4` |

Consequences:

- **MC3** = `trotter_step` (with `P := massCoin4`, `F := diracHNU` or vice versa)
  + `norm_exp_sub_one_sub_self_le` to produce each envelope, then the elementary
  conversion `exp s - 1 - s <= s^2 * exp s / 2` (or keep the envelope form and
  convert once at the end) to reach the `C * eps^2` shape. No commutation is used
  anywhere, as required.
- **MC4** = `unitary_pow_telescope` applied to `U := massiveHNU ...`,
  `V := exp (...)`, then MC3 - this is exactly the pattern already used at
  `Compact3Plus1DiracRate:486`. Reusable essentially verbatim.
- **MC2** is the only genuinely new analytic content: the block-diagonalization
  and unitary-conjugation lift. The norm step is **VERIFIED SAFE**: I checked the
  norm instance rather than assuming it. `Compact3Plus1DiracRate.lean:32` carries
  `open scoped Matrix.Norms.L2Operator`, so `‖·‖` on `Mat4` is the **induced L2
  operator norm**. For that instance conjugation by a unitary is a genuine
  isometry (`‖U A U*‖ = ‖A‖`), unitaries have `‖U‖ = 1`, and the norm is
  submultiplicative - exactly the three properties MC2, MC3 and
  `unitary_pow_telescope` rely on. Had the file used the default entrywise sup
  norm or the Frobenius norm, the isometry step would have needed a different
  argument and MC2's constant would change; it does not. **No normalization error
  here.** The remaining MC2 content is therefore only the block-diagonalization
  bookkeeping, not an analytic risk.

## 5. Hidden assumptions in the MC5 four-component lift

MC5 ("repeat the landed HNU bulk/tail proof for four-component spinors") is where
the ladder is least protected. Audit points, in priority order:

1. **Component norm vs vector norm.** A four-component bound assembled from
   two-component estimates must state whether the constant accumulates as `sqrt 2`,
   `2`, or not at all. The memo's "the basis change should not enlarge the
   operator norm" is about MC2; MC5 needs the analogous statement for the
   *L2 direct sum*, which is a different (and true, but separate) fact.
2. **Representatives and measurability.** The changing-cell lemmas are stated for
   two-component fields; lifting to four components requires that the chosen
   a.e.-representatives and measurability witnesses are transported componentwise.
   This is routine but must be *stated*, not assumed.
3. **Ultraviolet tail.** The claim "unitarity bounds the multiplier error by `2`"
   is correct and mass-independent, but only if the *mass* factor is also unitary
   at every `eps` - which holds by `massCoin4_unitary_group` **only for the exact
   coin**, not for its exponential surrogate. State the tail bound against the
   unitary object.
4. **Mass scaling.** "The bounded mass term adds no new ultraviolet growth" is
   correct for *fixed* `z`, because `mass4 z` is a constant matrix. It would fail
   for a momentum-dependent mass. Keep MC5 at fixed `z` as the memo says; the
   uniform-in-`z` family theorem needs `||z|| <= M` to enter the constant.

## 6. Sufficiency verdict and the strongest honest theorem

**Is MC1-MC6 sufficient?** For a *fixed-momentum, fixed-mass* changing-lattice
convergence statement: **yes**, modulo only the MC5 bookkeeping above. The MC2
norm-instance risk I initially flagged is resolved in the ladder's favour (L2
operator norm; see section 4). The ladder has no circularity and no step that
silently assumes commutation.

The strongest theorem that would honestly follow, if MC1-MC5 close:

> For fixed `z` and any Schwartz (or stated-Sobolev) four-component initial
> datum, the changing-lattice massive HNU evolution converges in `L2` on any
> finite time interval to the evolution generated by
> `-i (sum_j alpha_j q_j + mass4 z)`, with an `O(1/n)` rate uniform on compact
> momentum boxes.

That is a *free massive Dirac regulator convergence theorem*. It is **not**:
a statement about interacting dynamics; a statement uniform in `z`; a claim that
the HNU walk is the unique such regulator; or a resolution of the mirror/doubling
ledger, which is independent of this ladder.

**Precise remaining blocker if the ladder does not close:** MC2. Everything else
is either an identity (MC1), a reuse of an existing abstract lemma (MC3, MC4), a
bookkeeping lift (MC5), or an identification (MC6). MC2 is the only step whose
constant is genuinely new, and its correctness depends on the norm instance.

## 7. MC6 caveat

MC6 identifies the Fourier-conjugated generator with
`-i sum_j alpha_j partial_j + mass4 z`. That is an *identification of generators
on Schwartz spinors*, not a convergence statement, and should not be cited as the
PDE theorem on its own - the convergence content is MC5. The memo is already
careful here; this note is to keep the manuscript wording aligned.

## Source comparison (as instructed)

- **Arrighi-Forets-Nesme, arXiv:1307.3524** supplies the *architecture*
  (consistency + stability + sampling/interpolation + Sobolev tail) that MC5
  mirrors. It does not prove the HNU-specific estimate; the walk is different.
- **D'Ariano-Mosco-Perinotti-Tosini, arXiv:1603.06442** is the massive
  doubled-Weyl comparison: it shows a massive QCA obtained by coupling two Weyl
  sectors, which is structurally what `massiveHNU` does. Again: comparison only,
  not a transfer of the theorem.

Neither source licenses any MC step; both are cited as design precedent.

## Actions taken

- Codex messaged immediately with items 1-4 (msg on send).
- Aristotle jobs dispatched in the Opus lane to discharge the audit's own
  recommendations (unconditional MC1; the MC2 norm-instance question).
- No Codex-owned Lean touched.
