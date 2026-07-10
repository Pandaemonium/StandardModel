# Is a finite mass-VALUE map constructible? — the neutrino-ratio gap

**Verdict in one line:** the within-carrier level *ratio* is a genuine prediction
(spacing ratio `= 1`, kernel-proved), but the cross-generation neutrino mass ratio
is a **category error at this generality** (with an input-only fallback): the finite
structural data has no generation index and no cross-carrier scale, so `m₂/m₃`
cannot be a prediction — only an external Yukawa-like texture could supply it.

The claims are backed by the Mathlib-only file `RequestProject/Main.lean`
(namespace `NeutrinoRatio`), which builds with no `sorry` and no extra axioms.

---

## 1. What a "mass-value map" would be, and what finite input actually exists

A mass-value map is a function

```
M : (couplings) → (carrier decorations) → (particle label) → ℝ
```

returning a mass value, or a dimensionless map returning a mass *ratio*. To be a
*prediction* (not an input) every argument must itself be fixed by the finite
structural theory.

**What the program actually has for one carrier.** The complete finite data of the
sector block `B(lam, kappa)` is:

* two real couplings `(lam, kappa)` — `lam` = aperture/closure center, `kappa` =
  aperture−closure half-width; and
* a **three-valued sector level index** `Fin 3` selecting one of the three squared
  masses `{lam−kappa, lam, lam+kappa}` (formalised as `spectrum : Fin 3 → ℝ`).

That is all. Concretely, the only discrete/combinatorial invariant present is the
3-element level index of a *single* block.

**Could any discrete invariant carry generation structure?** The candidates one
might reach for — edge count, Clifford dimension, sector multiplicity, a graded
(K-theoretic) index — are all *per-carrier* scalars: each returns one number for one
carrier. None of them is a **family/replication label**. To distinguish the three
neutrino generations you need a degree of freedom that ranges over generations
`g ∈ {1,2,3}` *and* relates their scales; the current data has neither. The 3-level
sector index is the wrong three: it enumerates the closure/mean/aperture of *one*
block (an internal Clifford-graded triple), not three copies of "the neutrino."
So **generation is simply not present in the current data.**

---

## 2. The sharpest honest verdict — (c) category error (with a (b) fallback)

**The theory fixes ratios only of the form `(lam−kappa) : lam : (lam+kappa)` within
one carrier, and only up to overall scale. It has no cross-carrier / cross-generation
scale. Therefore a neutrino mass ratio is a category error at this generality.**

Two independent kernel facts force this (both in `Main.lean`):

1. **No absolute value is fixed** — `specMid_surjective`: the central level can be
   made equal to *any* real by choice of couplings. Structural data pins down no
   mass value, only within-block relations.

2. **No cross-block scale is fixed** — `spectrum_scale_underdetermined`: for any
   target factor `r`, a genuinely different carrier reproduces the whole spectrum
   scaled by `r`, level by level. Two carriers cannot be compared without an
   *external* scale choice.

Fact (2) is exactly the obstruction to a *cross-generation* ratio: three generations
would be three distinct carriers, and their relative scales are undetermined.

**Why not (a) "constructible from richer decorations"?** You could *add* a generation
index `g` and a family of carriers `(lam_g, kappa_g)`. But the resulting `m₂/m₃` is
then whatever the added `(lam_g, kappa_g)` texture says — it is read off the input,
not derived. That is the **(b) input-only** fallback: with an external Yukawa-like
texture the ratio exists but is an INPUT, not a prediction. Absent that texture it is
(c). Either way it is **not a prediction of the current finite theory.**

**Why the tempting shortcut fails.** Identifying the three levels of one block with
three generations is blocked twice: (i) those levels are one sector's
closure/mean/aperture, not a replication; and (ii) even if forced, the predicted
`Δm²` ratio is `1` (arithmetic, `spec_spacing_ratio`), whereas the observed neutrino
`Δm²` splittings are strongly hierarchical (`Δm²₂₁/Δm²₃₁ ≈ 0.03`). The shortcut is
immediately falsified.

---

## 3. What CAN be predicted — the honest positive (kernel lemma delivered)

Within a single carrier the three squared-mass levels are an **arithmetic
progression** `lam−kappa, lam, lam+kappa`. This yields one sharp dimensionless
prediction, delivered as Mathlib-only lemmas from `B`'s spectrum:

* `specMid_eq_mean` — the central level is the arithmetic mean of the outer two
  (scale-free).
* `spec_equal_spacing` — the two gaps are equal.
* **`spec_spacing_ratio`** — for `kappa ≠ 0`, the dimensionless spacing ratio
  `(m²_mid − m²_lo)/(m²_hi − m²_mid) = 1` **exactly**.
* `spec_spacing_ratio_scale_invariant` — rescaling both couplings leaves the ratio
  `= 1`, so it is independent of the unknown overall scale.

**Sharpest honest claim.** *Within one carrier, the three squared-mass levels are
equally spaced: the dimensionless spacing ratio is `1`.*

**Kill condition.** Measure the two squared-mass gaps within a single carrier's
sector; if their ratio differs from `1` (beyond error), the structural model of that
carrier is falsified.

**Contrast with the neutrino ratio.** `spec_spacing_ratio` is a within-carrier,
scale-invariant relation and is predicted. The neutrino `m₂/m₃` is a *cross-generation*
relation requiring three carriers and a scale between them — outside what the data
fixes (§2).

---

## 4. No-go honesty — the precise missing ingredient

**The neutrino mass ratio is NOT predictable by the current finite structural
theory.** The missing ingredient is precise and twofold:

1. a **generation (family-replication) index** `g ∈ {1,2,3}` selecting three
   distinct carriers as the three mass eigenstates — absent from the current data
   (which has only a within-block 3-level index); and

2. a **cross-carrier scale map** relating the couplings/normalizations of distinct
   carriers (a Yukawa-like texture) — undetermined by the structural data
   (`spectrum_scale_underdetermined`), hence necessarily an external input.

Until both are supplied *and derived*, the neutrino ratio is an honest boundary of
the program, not a pending calculation. What the program can honestly claim is the
within-carrier equal-spacing prediction of §3.
