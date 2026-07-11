# Grand strategy 1 (Fable lanes, 24h publication run 2026-07-11/12)

REVIEW-ONLY strategy job. No proofs, no source edits. Deliverable:
STRATEGY_MEMO.md ranking targets with exact statements, gates, and kill
conditions.

## Context

A two-agent + proof-fleet team is 24h from a hard audit. The 2026-07-11
overnight run landed (all kernel-checked, Lean 4 + Mathlib):
- Paper C: positional certificate law on a 4-site palindromic walk
  register: fixed-leg compression self-adjoint iff two walls and not a
  fixedSingleton (all 16 sign fields decided); composed through a
  kernel-only involutive-compression engine into full-walk exact +-1
  modes for the 8 protected fields. Exact (not yet formalized) census:
  ALL two-wall fields have modes - blocks (4,4) are exact involutions
  W^2=1; blind singletons are certified by the mirror {0,2} axis chart;
  so the law classifies CERTIFICATE REACH by a two-chart reflection
  atlas. Winding, half-period timeframe pair, and mirror-graded winding
  are proven blind/ill-defined. Transfer matrices at +-1 are exact with
  eigenvalues {1/2, 2} (decay factor exactly 1/2 per site).
- One-particle free phase observable: 4x4 phase-defect spectrum theorem
  (equal moduli load-bearing, zero-mode iff, conjugacy) - kernel-only.
- Sea-level observable: sector-resolved window half-charge exactly -1/2
  per gap sector at L=8 (exact oracle; Lean job still running).
- E lane: exact declared-set CAR support, scheduled propagation,
  pairwise-disjoint layer-depth cone, determinant-minor lift
  functoriality, pair kick with 4/5-vs-1 discriminator; interaction is
  SUPPLIED, not derived (open in the field too - Thirring QCA lit).

## My lanes this run

1. Paper C: formalize the two-chart mechanism; stability or exact
   splitting law; relation to the CGGSVWZ real-space index
   (arXiv:1611.04439, Fredholm left/right indices, gentle-perturbation
   stability); replace compiled fixture checks with kernel proofs where
   feasible.
2. Paper E: derive the pair update from a finite Hermitian generator or
   action; free/interacting layer composition with exact or quantitative
   Trotter law; a phase-sensitive dynamical consequence (bound state,
   scattering phase, threshold) beyond the assigned-mass model.
3. Paper A prose freeze (specialist venue) - not your concern beyond
   flagging which theorems deserve abstract billing.

## Questions (ranked)

Q1. For C stability: given a FINITE 8-dim register with the exact data
above, what is the strongest honest stability statement a kernel proof
can reach in ~6-12 hours of fleet time? Candidates: (a) invariance of
the certificate under sign-pattern-preserving smooth deformations of the
coin angle (theta family, cos/sin symbolic) - the compression stays
self-adjoint for ALL theta, modes persist; (b) rank/continuity argument
for eigenvalue pinning under Gamma-and-R-respecting perturbations with a
gap hypothesis; (c) exact splitting law: quantify mode displacement when
the perturbation breaks R (we already know hybridization splitting ~
0.6 * 2^-sep numerically). Rank by value-per-effort, give exact Lean
statement shapes, and name the analytic API each needs (eigenvalue
continuity? Matrix.IsHermitian spectral apparatus? none?).
Q2. For the CGGSVWZ relation: their index needs infinite half-chains
(Fredholm). For a FINITE ring, is the honest statement a comparison
(our discriminator = their index evaluated on the infinite extension of
each bulk) or a no-claim? Give the exact sentence a referee would
accept, or say "comparison only, no theorem" - do not manufacture one.
Q3. For E dynamics: the pair kick K(z) = z a_i^dag a_j^dag a_l a_k +
conj z (...) is Hermitian, even, 4-mode. What is the minimal
kernel-checkable "derivation" story: exp(-i alpha K) as the exact gate
(finite-dim exponential via nilpotency? K^3 in the 4-mode sector?),
Trotter composition with the free minor-lift, and ONE computable
phase-sensitive dynamical quantity (two-particle bound state energy on a
small ring? transmission phase?). Give exact statement shapes and what
to precompute with a sympy oracle first.
Q4. Name the top 3 over-claim risks in this program for a hostile
referee and the exact prophylactic sentence for each.

Budget guidance: memo only; cite which of the named repo results each
recommendation builds on; flag anything that needs a source check.
