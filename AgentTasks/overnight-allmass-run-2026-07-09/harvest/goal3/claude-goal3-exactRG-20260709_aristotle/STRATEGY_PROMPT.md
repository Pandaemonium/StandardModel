# Goal III — Relativity is born at the fixed point (exact rational RG)

## Context (you are blind to the wider repo; seeds are in `seeds/`)

A finite "null-edge" program models a 1D chain carrier whose sites carry two
couplings: an **aperture** `lam` (on-site mass-like term) and a **closure**
`kap` (nearest-neighbour edge term). The claim to convert from oracle-grade to
kernel-grade: **Lorentz/relativistic structure is not an input; it emerges as
the fixed point of an EXACT rational RG (real-space decimation), with no limits
and no floating point.** Everything below is finite rational/complex matrix
algebra.

The seed files (clean-room port them; Mathlib only, do NOT assume they are
importable — copy the definitions you need into `RequestProject/Main.lean`):

- `seeds/RGSchurMassWitness.lean` (namespace `...RGSchurMass`): the decimation
  primitive. `nullL`, `nullN` are the `2x2` null edges (`nullL^2=0`, `nullN^2=0`,
  `nullL*nullN + nullN*nullL = 1`). `chain_schurComplement_eq` and
  `effective_offdiag_eq_neg_edgeProd` give the two-site Schur complement (integrate
  out the middle site). `collinear_schurComplement_eq_zero (t)` is the CURRENT
  **one-coupling** collinear negative control (a collinear pair decimates to zero
  effective edge).
- `seeds/ContinuumLimit.lean` (namespace `...ContinuumLimit`): the Dirac quantum
  walk `Ustep k θ = Ushift k * Ucoin θ` on `Fin 2`, with `dirac_mass_shell` the
  pinned dispersion and `Ustep_hasDerivAt_generator` its generator.
- `seeds/SubluminalBound.lean`: the group-velocity bound `v_g <= 1`, equality iff
  massless, from the pinned dispersion `cos ω = cos k cos θ`.
- `seeds/MassPhaseDiagram.lean`: the `3x3` mass block `B(lam,kap)` with spectrum
  `{lam-kap, lam, lam+kap}`; the massless/critical line is `|kap| = |lam|`.
- `seeds/FiniteRGFlow.lean`: abstract RG-orbit machinery (`orbit`, `StepPreserves`,
  `invariant_orbit`, `ObservableInvariant`, `observable_invariant_orbit`).

## Targets (a chain; land the cheapest killable rung first, report kills loudly)

Define an explicit **two-coupling decimation map** `R : Q x Q -> Q x Q`,
`R(lam, kap) = (lam', kap')`, from the two-site Schur complement of the chain
carrier parametrized by `(lam, kap)` (aperture on-site, closure edge). Give it in
CLOSED RATIONAL FORM. Then:

1. **(b) Massless-line invariance [CHEAPEST — do FIRST].** Prove the massless
   (critical) line is `R`-invariant: `R` maps `{|kap| = |lam|}` into itself
   (upgrade `collinear_schurComplement_eq_zero` from the one-coupling control to
   the full two-coupling statement). **MANDATORY non-degeneracy fixture:** exhibit
   `R` at a concrete NON-critical rational point with `R(lam,kap) != (lam,kap)`
   (e.g. show `R(1, 1/2)` is a specific rational pair `!= (1, 1/2)`) — so `R` is a
   genuine nontrivial flow, not the identity. State this witness IN the theorem.
2. **(a) The recursion.** `R` is a well-defined rational map (the middle-site
   inverse exists off a codimension-1 locus you state explicitly).
3. **(d) Conical dispersion `z=1`.** On the critical line the pinned dispersion is
   conical `ω = ±k` (one line from `ContinuumLimit`/`SubluminalBound`), giving
   dynamical exponent `z = 1`.
4. **(c) Correlation exponent `nu = 1`.** The linearization `dR` at a critical
   fixed point has mass-direction eigenvalue **exactly `2`** (`= b^{1/nu}` with
   rescale `b = 2`), hence `nu = 1` as exact arithmetic; `xi ~ (lam - kap)^{-1}`.

## Kill conditions (a kill is a publishable result — state it as a theorem)

- The critical line is NOT `R`-invariant (the continuum program dies at the root —
  the most valuable negative).
- The linearized mass eigenvalue is `!= 2`.
- `R` is the identity on all of `Q x Q` (degenerate — the non-degeneracy fixture
  in target 1 guards against a vacuous "invariance").

## Constraints (hard)

Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`. Mathlib only.
Footprint exactly `[propext, Classical.choice, Quot.sound]`, verified in-file with
a `#guard_msgs (whitespace := lax) in #print axioms <thm>` block on EVERY headline
theorem (not a bare `#print axioms`). Deliver `RequestProject/Main.lean` (put your
work in a clear namespace, e.g. `Goal3ExactRG`) + `ARISTOTLE_SUMMARY.md` stating:
the closed form of `R`, which rungs landed, the non-degeneracy witness value, and
an honest note on any codimension-1 locus excluded.
