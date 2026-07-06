# Adversarial audit — `DoublingTurnPrice.lean` ("price of the turn" / finite Nielsen–Ninomiya)

Scope: `DoublingTurnPrice.lean` and its dependencies (`EuclideanGamma`,
`WilsonDiracOperator`, `ChiralMassStructure`, `MassTaxonomySeparation`).
Review only; no build changes. All cited lemmas exist and typecheck as claimed.

## What the module actually contains

Every operational object is a **single 4×4 spin matrix** over `ℂ`:

* `DoublingTurnPrice.wilsonProjector r μ = r • 1 - γ μ`
* `DoublingTurnPrice.massVertexW m r μ = m • 1 + wilsonProjector r μ`

and the two `γ5`-conjugation projections `ChiralMassStructure.chiralEven`,
`ChiralMassStructure.chiralOdd` applied to them. Established identities:

* `chiralEven_wilsonProjector : chiralEven (wilsonProjector r μ) = r • 1`
* `chiralOdd_wilsonProjector  : chiralOdd  (wilsonProjector r μ) = - γ μ`
* `chiralEven_massVertexW     : chiralEven (massVertexW m r μ) = (m + r) • 1`
* `chiralOdd_massVertexW      : chiralOdd  (massVertexW m r μ) = - γ μ`

There is **no momentum variable, no Brillouin torus, no dispersion relation, no
pole/zero of a dispersion, and no sum of chiralities**. Nothing global or
topological appears anywhere in the file or its dependencies.

## Per-point verdict

**(1) Does `no_chiral_and_doubler_removal` capture Nielsen–Ninomiya? — OVER-CLAIM (and near-VACUOUS).**
Statement: `¬ (chiralEven (massVertexW m r μ) = 0 ∧ chiralOdd (massVertexW m r μ) = 0)`.
Its proof `rintro ⟨_, hodd⟩; rw [chiralOdd_massVertexW] at hodd; exact γ_ne_zero μ (neg_eq_zero.mp hodd)`
**discards the even conjunct** (`_`). So the theorem is logically just
"`chiralOdd (massVertexW m r μ) ≠ 0`", i.e. "the fixed matrix `-γ μ` is nonzero".
This is a purely local algebraic fact about one vertex; it says nothing
topological, has no torus, no ± pole pairing, and no chirality sum. Naming it a
"finite shadow of Nielsen–Ninomiya" is an over-claim. It also carries no
genuine tension between the two channels: the odd channel is a nonzero constant
independent of `m, r`, so no parameter choice could ever zero it — the "cannot
have both" is trivially about one channel alone.

**(2) Is the necessity direction established? — NO (missing).**
No theorem has the shape "chiral symmetry (a `{γ5, D} = 0` / even-channel-vanishing
hypothesis) ⟹ forced doubling / forced even (Wilson) term". `no_chiral_and_doubler_removal`
is not such an implication (chiral symmetry is not even a used hypothesis). The
file only shows the even and odd channels are algebraically independent
functions of `(m, r)`. The intended necessity claim is unproved. See "biggest gap".

**(3) Vacuity / triviality per headline.**
* `no_chiral_and_doubler_removal` — NEAR-VACUOUS: reduces to `-γ μ ≠ 0`; the even hypothesis is unused.
* `naive_limit_doubler_survives` — SOUND but TRIVIAL: at `m = r = 0`, `chiralEven = (0+0)•1 = 0` and `chiralOdd = -γ μ ≠ 0`. Real content = `γ μ ≠ 0`; "doubler survives" is interpretive gloss, no doubler is modelled.
* `chiralEven_massVertexW_eq_zero_iff` — SOUND, mild content: `(m+r)•1 = 0 ↔ m = -r` (one linear scalar equation). Honest and correct, but elementary.
* `regulator_turn_tie` — see (4).

**(4) `regulator_turn_tie` — OVER-CLAIM ("coincidence at `r = 0`").**
It proves: for real `r`, `r = 0 ⟹ (chiralEven (wilsonProjector r μ) = 0 ∧ wilsonRegulatorMass r = 0)`
and `0 < r ⟹ (chiralEven (wilsonProjector r μ) ≠ 0 ∧ 0 < wilsonRegulatorMass r)`.
`chiralEven (wilsonProjector r μ) = r • 1` (linear in `r`) and
`MassTaxonomySeparation.wilsonRegulatorMass r = Real.log (1 + 4 r)` are two
**separately defined** objects; the only thing tying them is that both cross
zero at `r = 0` and are strictly positive for `r > 0`. There is no functional
identity or derived relationship — it is a shared threshold/sign coincidence,
not a "tie" showing the regulator turn *is* the Wilson turn. The phrasing
overstates a sign-agreement lemma.

**(5) Trust surface — clean, but names oversell.**
No `sorry`, no `axiom`, no `native_decide`, no `@[implemented_by]` in any of the
five source files (matches present only inside docstrings). Standard axioms.
However several headline **names/docstrings are stronger than the statements**:
`no_chiral_and_doubler_removal` (really `chiralOdd ≠ 0`), `naive_limit_doubler_survives`
(really `γ μ ≠ 0` at the origin), and `regulator_turn_tie` (really a sign match).

## Single biggest gap and the statement that would close it

The framing promises the **topological/global Nielsen–Ninomiya no-go and its
necessity direction**; the module delivers only **local per-vertex spin algebra
with no momentum/torus**. Nothing here counts poles or their chiralities, and
"chiral symmetry ⟹ forced doubling" is never stated.

An honest finite statement (discrete Brillouin torus `T = (ZMod N)^d`, `N ≥ 2`)
would be roughly:

```
theorem nn_chirality_sum_zero
    {N d : ℕ} [NeZero N]
    (D : (Fin d → ZMod N) → Matrix (Fin 4) (Fin 4) ℂ)   -- free lattice Dirac symbol
    (hchiral : ∀ p, γ5 * D p + D p * γ5 = 0)              -- exact chiral symmetry {γ5,D}=0
    (hzeros : {p | ¬ IsUnit (D p)}.Finite)                -- isolated zeros (doublers)
    (hnondeg : ∀ p ∈ zeros, nondegenerate/simple pole condition) :
    ∑ p ∈ zeros, chirality_sign (D p) = 0
```

i.e. the signed count of doublers (zeros of the symbol) over the torus is zero,
so doublers come in ± pairs and cannot be removed while keeping `{γ5, D} = 0`.
The **necessity** corollary would then read: if `{γ5, D} = 0` and `D` has a
single simple zero at the origin, the finiteness+sum-zero forces a second zero
(a doubler) — hence a chirality-**even** (Wilson-type) term, which breaks
`{γ5, D} = 0`, is *necessary* to reach a single-zero (doubler-free) operator.

Finite provability: the sum-zero identity IS provable on a discrete torus, but
it is a genuine degree/index argument (a discrete Poincaré–Hopf / winding-number
count), **not** a one-line spin identity. It requires (a) a momentum-dependent
symbol `D(p)`, (b) a chirality-sign functional at each zero, and (c) a
telescoping/degree argument over `(ZMod N)^d`. None of this machinery is present;
it would have to be built. It is finitely statable and plausibly finitely
provable, but it is substantially more than the current module attempts.

## Citation guidance

The module is safe to cite ONLY as: *a finite spin-algebra channel decomposition
of the Wilson vertex* — namely that the Wilson/mass term is chirality-even
(`chiralEven_wilsonProjector`, `chiralEven_massVertexW`), the transport generator
is chirality-odd and parameter-independent (`chiralOdd_massVertexW`), and the
even channel vanishes iff `m = -r` (`chiralEven_massVertexW_eq_zero_iff`,
`chiralEven_standardVertex_eq_zero_iff`). These are correct, `sorry`-free finite
identities.

It is **not** safe to cite as "the finite Nielsen–Ninomiya no-go", "the
price-of-the-turn / T-leg obstruction proper", or as establishing the
**necessity** of the Wilson term / forced doubling. That framing must be
downgraded: the topological chirality-sum theorem and the chiral-symmetry ⟹
forced-even-term implication are absent. In particular
`no_chiral_and_doubler_removal` should be read as `chiralOdd (massVertexW) ≠ 0`,
not as a doubling no-go.
