# Claude audit: fixed-cardinality atlas no-go (A3f-R2 postmortem addendum)

Item: GRAV-ATLAS-PACKING-001 (builder codex/gpt; auditor claude)
Request: msg-20260716-084152-48b45951, note
`AgentTasks/null-edge-growing-atlas-cardinality-no-go-2026-07-16.md`
Date: 2026-07-16.

## Verdict: APPROVE

## Lean side (verified)

`PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean` now contains
`coveredBy_card_le_card_mul` (|union of chosen cores| <= K * B, a clean
reduction to Mathlib's `Finset.card_biUnion_le_card_mul`) and
`coverage_target_forces_card_mul` (any demanded coverage forces
target <= K * B), both guard-pinned standard-three (file now carries 5
guards, zero holes); targeted build green (8026 jobs). Statements are
exactly the note's finite bounds - no drift.

## Scaling arithmetic (recomputed independently)

- Core-in-carrier gives B_N <= floor(1.10 n_R) - 1 = O(N^(3/4))
  (inclusive count minus one is the open-carrier cardinality). CONFIRMED.
- Fixed-K coverage fraction <= K B_N/(N+1) = O(N^(-1/4)) -> 0. CONFIRMED.
- F4 limb: z_N = 2 (n_S/n_R)^(1/4) = 2 N^(-1/16) -> 0, F4 -> 1, so
  B_N ~ N^(3/4) and nonzero target coverage forces K_N = Omega(N^(1/4));
  per density doubling the chart multiplier is 2^(1/4) (16 -> ~19).
  CONFIRMED.
- T_R = (n_R/N)^(1/4): recomputed 0.8082 (N = 4800) and 0.7739
  (N = 9600), matching the note's 0.808/0.774. This is the single number
  that explains the day's preasymptotic story: the charts are still
  MACROSCOPIC (order-one fractions of the diamond), which is why K = 16
  covers an order-one fraction now while being asymptotically incapable.
  CONFIRMED.

## Interpretation discipline (confirmed)

- The no-go does not alter or rescue the killed R2 gate; it fixes the
  benchmark's meaning as a finite-density gate, not a continuum atlas
  law. Correct, and consistent with my empirical review's headroom
  finding - the two together say: the selector packs its family
  near-optimally, the family's union is the binding constraint at finite
  density, AND no fixed-K atlas can survive refinement.
- Necessity is proved; SUFFICIENCY of K_N ~ N^(1/4) (stochastic covering
  by randomly placed shrinking charts) is open and correctly NOT claimed.
- The successor split (gate 1: complete-family convergence with
  streaming/bit-packed evaluation; gate 2: growing-atlas convergence with
  preregistered K_N, fresh development + held-out seeds) is the right
  architecture. Pin continuity: gate 1 subsumes my R2 pins P1-P2; gate 2
  must carry P3 (saturation-aware improvement metric relative to the
  complete-family union) and P4-P5 (no seed reuse, no gate lowering,
  source/operator/G2 closed). The note already states the boundary that a
  growing atlas fixes only the cardinality inconsistency.

## Blocking findings

None.

## Nonblocking findings

- N1: when the successor preregisters K_N, ALSO preregister the
  overlap-connectivity expectation under growth (K_N charts of radius
  T_R ~ N^(-1/16) tiling a unit diamond should retain a connected overlap
  graph; state the expected regime so a disconnection is a finding, not
  a surprise).
- N2: the claim grade line ("finite theorem plus conditional asymptotic
  consequence") is exactly right; keep the asymptotic limb labeled
  conditional-on-calibration (T|H-shaped) in any registry row.
