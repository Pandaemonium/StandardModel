# Visionary synthesis: the highest-leverage cross-program move

- Activation: `role-20260713-064739-aa90632b`
- Role: Visionary (`visionary`), model `claude`
- Date: 2026-07-13

## The one number that frames everything

The claim registry holds 37 kernel-checked claims: 36 graded **M**
(machine-verified, program-internal) and exactly **1 T** (source-verified). The
lab is an excellent rung-factory with almost no grade-elevation loop. Per the
charter's rejection of a "the framework is suggestive" outcome, the
highest-leverage move is not another M-rung; it is converting the best existing
M-cluster into something the outside world recognizes.

## Cross-program state (what actually landed)

- **CONT-FOURIER (continuum ladder)** -- now the deepest coherent chain:
  exact-flow Lipschitz -> strong L2 orbit continuity -> position-space Fourier
  conjugation -> pointwise generator -> time-group law -> Fourier partial-
  derivative symbol -> temperate growth -> **Schwartz one-parameter group** ->
  **exact Fourier->Dirac symbol capstone**. All cross-family reviewed, kernel-clean.
  The honest ceiling today: bounded Schwartz-multiplier evolution + the spatial
  symbol identity. The generator/Stone step and the position-space Dirac PDE are
  deliberately deferred.
- **INFO/DYN (quantum information + modular)** -- general non-commuting quantum
  Klein inequality (CFC-free), its equality/uniqueness scalar core, phase-covariant
  modular selection, arbitrary-phase qubit max-entropy capstone, a finite
  quantum-information library (Pinsker, SSA, DPI, max-entropy, Gibbs variational).
- **L0-DIST (Lorentz-in-distribution)** -- a complete equivariance-gate cluster:
  decoration kill -> finite Poisson-config invariance -> marked/equivariant
  invariance -> deterministic invariance-iff-equivariance classification. This is
  clean impossibility-frontier scaffolding.
- **GAUGE-YM** -- mapped no-go (per-fibre unsound, unrooted recurrence killed by
  counterexample) + the repaired rooted route's R0 rung.

## Three ranked opportunities

### 1 (RECOMMENDED, surest ROI): Elevate the quantum Klein inequality to Mathlib

The general non-commuting quantum Klein inequality + the CFC-free spectral
matrix logarithm (`logHermitian`) + the entropy trace identity are kernel-clean
and fill a genuine Mathlib v4.28 gap (no `Matrix.log`, no matrix entropy, no
operator convexity). This is the ONLY near-term path from M to external
recognition, it is already proved, and DQ-008 has pre-registered the decision.

- **Assumptions:** the doubly-stochastic reduction is Mathlib-portable; a
  maintainer accepts the CFC-free construction; no existing API already covers it.
- **Kill test:** if a focused Mathlib-style refactor (drop the heavy
  `maxHeartbeats` step, remove unused-simp lints, rename to Mathlib conventions)
  reveals the CFC-free `logHermitian` duplicates existing spectral API, OR the
  doubly-stochastic reduction does not survive de-projectification into a
  general-position lemma, park the PR and keep the result as repo infrastructure.
- **Queue reservation:** one Aristotle/authoring task -- "Klein inequality
  Mathlib-port skeleton": restate `qKlein_nonneg` + `logHermitian` against bare
  Mathlib with Mathlib naming, isolate the two load-bearing lemmas, confirm no
  duplicate API. NOT a physics claim; external submission remains Director-only.

### 2 (highest ceiling, moonshot): CONT-FOURIER -> Stone generator -> position Dirac PDE

If the F3 Schwartz one-parameter group extends to a strongly continuous unitary
group on L2 with a self-adjoint generator (Stone), and the Fourier->Dirac symbol
capstone identifies that generator with the free Dirac operator, the ladder
becomes a genuine "finite exact flow -> continuum Dirac evolution" reconstruction
-- a headline, and a T|H candidate.

- **Assumptions:** the bounded Schwartz multiplier promotes to a unitary L2 group;
  the unbounded generator domain is tractable in Mathlib v4.28.
- **Kill test:** if Stone/self-adjoint-generator on L2 is not reached within THREE
  focused Aristotle attempts (generator domain is the known hard wall), freeze the
  ladder as "bounded Schwartz-multiplier evolution + spatial symbol identity" and
  do not let any prose imply a completed PDE reconstruction.
- **Queue reservation:** hold; do not fund until opportunity 1 is dispositioned,
  to avoid two simultaneous moonshots (WIP rule).

### 3 (frontier consolidation): L0-DIST equivariance gate -> a stated Lorentz obstruction

The equivariance-gate cluster is complete enough to connect to a real Lorentz
no-go: the Bombelli-Henson-Sorkin theorem (already in the references,
FULL-TEXT-VERIFIED) says no measurable Lorentz-equivariant map sends a Poisson
sprinkling to a direction. Composing "equivariance is necessary" (our cluster)
with "no equivariant frame decoration exists" (BHS) would state a finite-null
decoration no-go as a T|H result.

- **Kill test:** if the finite cluster cannot be honestly composed with BHS
  without an infinite-volume limit the cluster does not provide, record it as an
  explicit gap and keep the cluster as finite scaffolding only.

## The single call

**Fund opportunity 1 (Klein -> Mathlib) now; hold 2 and 3.** It is the only move
that directly closes the M-vs-T gap, it is low-risk (already proved), and it
gives the lab its first externally-legible output. Everything else is another
excellent rung until that loop exists. This escalates DQ-008 from "authorize
preparing" to "prepare the port skeleton and bring the go/no-go to the Director."
