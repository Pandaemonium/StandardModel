# Claude review: antiperiodic no-go + pi complement + minus-eigenspace census

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-182552, item QCA-3PLUS1-001
- Sources (aristotle-output, standalone namespaces, bare imports):
  (1) `RequestProject/AntiperiodicHNU.lean` (322, sha 626cbb01 MATCH) +
      `ASSESSMENT_ANTIPERIODIC.md`;
  (2) `HNUTransversePiComposite.lean` (236);
  (3) `HNUSU2MinusEigenvectorCensus.lean` (181).
- Build note: these are standalone-namespace modules with BARE imports
  (`import HNUExactCore`, `import FloquetTransverseComposite.Core`), so I did NOT
  repo-build them (the repo has `PhysicsSM.Draft.NullEdge.HNUExactCore`, not a
  top-level `HNUExactCore`). Codex confirms they build clean in the aristotle env
  with standard-three `#guard_msgs`; this is a SEMANTIC + duplication review, and
  a repo build is the integration step (port to `PhysicsSM` namespace). No live
  edits made.
- Cross-cut: the `native_decide` token in (1)/(2) is PROSE ("no native_decide"),
  not real code (recommend spaced `n a t i v e _ d e c i d e` per AGENTS.md).
- Date: 2026-07-13

## (1) Antiperiodic no-go - APPROVE (scoped ROUTE RELOCATION, not a universal no-go)

Q: "does the antiperiodic result really prove route relocation rather than a
universal no-go?" - YES, and it is careful to say so.
- The `T^2 = -I` antiperiodic twist genuinely FIXES the null-dilation's held-branch
  defect: two auxiliary moves decode to a pi phase (not the cancelling `e^{-i kappa}
  e^{i kappa}=1`), so the held branch moves on every fine tick
  (`anti_tick_moves_Q`, `anti_tick_unitary`).
- BUT the decoded substep becomes `coarse d k * (P - Q)` (sector reflection `S`,
  `anti_decoded_eq_coarse_reflect`). Through the 8-substep schedule the eight
  inserted reflections (`-s1,-s3,-s2,s3,s1,-s3,s2,s3`) do NOT cancel despite even
  count: `prodS_eq_neg_one = -I`, because the interleaved Paulis genuinely
  noncommute (`selector_noncommute : not Commute (Pplus s1) (Pplus s3)`). Hence
  `twEndpoint_zero : twEndpoint 0 = -1` vs `endpoint_zero : endpoint 0 = 1`.
- So the twist RELOCATES the single zero-sector Weyl node to a pi point - it
  CHANGES the decoded endpoint, not a universal impossibility. The escape is
  explicitly closed: `reflection_double_restores` (pairing reflections restores
  the non-null coarse substep, destroying the wanted pi). Finite witness
  `twEndpoint 0 = -1 != 1`.
- Scope respected: "No claim of 3+1 completion ... the topological winding
  identification is explicitly marked as imported." This is the honest successor
  to the null-dilation no-go (dilation HELD the branch; antiperiodic MOVES it but
  relocates the node) - a route-specific relocation result. Non-vacuous, correctly
  bounded. APPROVE.

## (2) HNUTransversePiComposite (`Vpi = -I`) - APPROVE (spectral complement precursor only)

Q: "is `Vpi = -I` only a spectral complement with no all-moving/local claim?" -
YES, stated scrupulously.
- `Vpi = -1` (minus identity on the complement spin sector): `Vpi_isUnitary`,
  `Vpi_mulVec` (every vector a `-1` eigenvector), `Vpi_plus_one_eigen_zero` (no
  `+1` eigenvector). It fills the abstract `FloquetTransverseComposite` complement
  slot ("the slot a pi-gap compensator would occupy") with a concrete pi phase.
- The docstring's "Hard semantic boundaries": "a finite momentum-space SPECTRAL
  composite ... does NOT prove real-space locality of the complement update,
  primitive-null microscopic support, an HNU winding number, bulk-edge
  correspondence, anomaly inflow, or a physical domain wall. The constant
  `Vpi = -1` is an explicit pi-sector SPECTRAL control, NOT yet an all-moving
  local compensator ... makes no claim of microscopic dynamics." Exactly the
  requested boundary. The selected-sector `+1` census bridges via
  `su2_fixed_vector_eq_one`. APPROVE as a spectral precursor.

## (3) HNUSU2MinusEigenvectorCensus - APPROVE (genuinely refines `pi_census`) + reuse fix

Q: "does the `-1` eigenvector census genuinely refine `pi_census`?" - YES.
- `endpoint_neg_one_eigenvector_iff`: on the closed cube, `exists v != 0,
  endpoint k *v = -v  <->  exists i, k i = ±pi`, via `su2_neg_one_eigenvector_iff`
  (the `-1` rigidity) composed with `pi_census`. This upgrades `pi_census`
  (operator equality `endpoint k = -1`) to the eigenvector level (a genuine
  pi-quasienergy eigenSTATE) - the exact `-1` analog of the approved `+1`
  `HNUSU2FixedVectorCensus`. `su2_eq_neg_one_of_neg_one_eigenvector` REUSES
  `su2_trace_neg_two` from `HNUExactCore` (good). Useful strengthening, same as
  the `+1` case (honest nuance: the endpoint iff is logically equivalent to
  `pi_census` for the SU(2) class; the value is the reusable `-1` rigidity + the
  eigenvector form).

## Duplicated SU(2) lemmas to reuse, not copy (the requested cross-check)

At REPO INTEGRATION (porting these standalone modules to `PhysicsSM`), factor the
shared SU(2) rigidity rather than carrying parallel copies:
- The `+1` census (`HNUSU2FixedVectorCensus.su2_fixed_vector_eq_one`, via
  `det_sub_one_fin_two` + `exists_mulVec_eq_zero_iff`) and the `-1` census
  (`su2_eq_neg_one_of_neg_one_eigenvector`, via a brute-force
  `trace_neg_two_of_neg_one_eigenvector` proved by `simp +decide`/`grind`) are the
  SAME rigidity pattern for `lambda = +-1`. Recommend a single shared helper
  `det_sub_smul_fin_two : (M - c*1).det = M.det - c*M.trace + c^2` (or a unified
  `su2_lambda_eigenvector_rigidity`) used by both, replacing the `-1` census's
  ad-hoc `+decide`/`grind` proof with the cleaner determinant route.
- `HNUTransversePiComposite` USES `su2_fixed_vector_eq_one` but (as a standalone)
  imports only `HNUExactCore`/`FloquetTransverseComposite.Core`. On integration it
  should `import` the `+1` census module and reuse that lemma, not re-derive/copy
  it.
These are reuse/hygiene items for integration, not correctness defects.

## Over-claim checks (all three)

- Vacuity: none - `twEndpoint 0 = -1` witness (1); `Vpi` non-vacuous census (2);
  origin/boundary witnesses (3).
- Hollow telescoping: none - the antiperiodic `prodS_eq_neg_one` and the `-1`
  rigidity are substantive, not dressed trivialities.
- Docstring-outruns-kernel: none - all three state their spectral/finite/scoped
  boundaries prominently (relocation not resolution; spectral not local;
  fixed-vector census not winding).
- False shape: none - each theorem is its intended statement.

## Verdicts

- (1) AntiperiodicHNU + assessment: **APPROVE** (scoped route-relocation no-go).
- (2) HNUTransversePiComposite: **APPROVE** (spectral pi-complement precursor;
  `Vpi=-I` explicitly non-local, no all-moving claim).
- (3) HNUSU2MinusEigenvectorCensus: **APPROVE** (genuine `pi_census` eigenvector
  refinement); REQUIRED-at-integration reuse fix: share the SU(2) rigidity /
  det-shift helper with the `+1` census instead of the parallel `+decide`/`grind`
  copy, and have `HNUTransversePiComposite` import the `+1` census for
  `su2_fixed_vector_eq_one`.
