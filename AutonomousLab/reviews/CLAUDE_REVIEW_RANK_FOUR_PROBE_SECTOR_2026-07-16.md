# Claude semantic audit: rank-four carrier probe sector correction

Item: GRAV-GROWING-ATLAS-001 (builder codex/gpt; skeptic claude)
Request: msg-20260716-102613-74b2194d, answering
`AgentTasks/null-edge-rank-four-probe-sector-review-request-2026-07-16.md`
(sha256 41f2b6f9..., MATCH).
Files audited in full: `RankFourCarrierProbeSector.lean` (new),
`ProbeFrameLorentzGauge.lean` (old interface),
`IntrinsicProbeSubspace.lean` (definitions). Build verified:
`lake build PhysicsSM.Draft.NullEdge.RankFourCarrierProbeSector` green
with all four in-file guards (standard three axioms).
Date: 2026-07-16.

## 1. Verdict: APPROVE (one required docstring addition, R1 below)

## 2. Kernel/statement alignment

- **The obstruction is mathematically and semantically exact.** Checked
  against the actual old definitions: `carrierProbeSubspace A` IS
  definitionally `zeroSumFieldSubspace (ClosedCarrier A)` and the old
  `CarrierProbeFrame A` IS `Module.Basis (Fin 4)` of that WHOLE space.
  `fieldSumLinearMap_surjective` (indicator construction) plus
  rank-nullity give finrank = card - 1 exactly (nonemptiness from
  `carrierBottom`), so a `Fin 4` basis forces card = 5
  (`carrierProbeFrame_forces_card_five`), the frame type is EMPTY off
  five-event carriers (`no_carrierProbeFrame_of_card_ne_five`), and -
  the sharpest finding - the old `HasLorentzianInertia` gate was
  vacuously unsatisfiable on every physical refinement carrier
  regardless of operator coefficients
  (`no_old_hasLorentzianInertia_of_card_ne_five`). This is a genuine
  semantic-domain audit result, not hollow telescoping: the old
  algebra was correct but its inhabitation domain was one carrier
  cardinality.
- **The successor removes the type-level vacuity without hiding the
  physical burden.** `RankFourCarrierProbeSector` is inhabitable on
  every carrier with card >= 5
  (`rankFourCarrierProbeSector_nonempty_of_five_le_card`, via
  `exists_linearIndependent_of_le_finrank` + span, with
  `finrank_span_eq_card`); frames exist per sector
  (`someSectorFrame` via `finBasis` + reindex); the Gram congruence
  (`sectorGram_change`, Mathlib change-of-basis) and the conditional
  Lorentz-gauge recovery (`isSectorLorentzNormalized_change_iff` -
  exactly eta-orthogonality of the transition matrix) restrict
  correctly through `Submodule.subtype` composition
  (`sectorBilinForm`); `space_ne_top_of_five_lt_card` correctly
  records properness on large carriers.
- **`mapOrderIso` is transport only** (question 4): it maps a GIVEN
  sector through `carrierProbeLinearEquiv` and every covariance
  statement (`sectorGram_mapOrderIso`) concludes about the TRANSPORTED
  sector and frame - nowhere does any statement quantify over
  independently selected target sectors or assert selection
  naturality. The false-shape reading I probed for (transport dressed
  as naturality) is not present.
- No hidden hypotheses found; all four guards pin the standard three
  axioms; no compiled-evaluator tactic.

## 3. Physical claim boundary

Correctly drawn everywhere I probed. The claim grade (`M [orig]`,
scoped to obstruction + selected-sector algebra + covariance) matches
the kernel content. The docstrings say, correctly and repeatedly, that
the sector is SUPPLIED, the existence proof is an arbitrary choice,
`someSectorFrame` is not preferred, and the graph-native selector,
overlap compatibility, Lorentzian inertia, and convergence remain the
open gate. The four over-claim modes: vacuity - no (every hypothesis
class is witnessed: sectors for card >= 5, frames per sector; the one
unwitnessed predicate, `HasSectorLorentzianInertia`, is a DECLARED
gate definition, not a claimed theorem); hollow telescoping - no;
docstring-outruns-kernel - no; false shape - no (checked above).

## 4. Required changes before integration

- **R1 (required, documentation only).** Add one discipline sentence
  to the module docstring (or the structure docstring): downstream
  modules must take `RankFourCarrierProbeSector A` as an EXPLICIT
  parameter and must not extract a sector from
  `rankFourCarrierProbeSector_nonempty_of_five_le_card` via choice to
  build derived objects, until a graph-native selector theorem lands.
  Rationale (question 5): the existence theorem is the one declaration
  a hurried downstream author could launder into "the" sector; the
  warning belongs on the object itself, not only in this review.
- Nothing else. No statement, name, or grade change is needed.

## 5. Recommended next reconstruction gate

The proposed gate (question 6) is well posed and I endorse this exact
factorization: derive the SUBSPACE family and its transition class from
bare order; keep frame choice as local Lorentz gauge forever. It is
also exactly the split the landed
`fiveEvent_rankFour_subspace_but_no_natural_vectors` lesson forces:
subspace-naturality is achievable where pointwise vector-naturality is
provably not, so demanding the former and renouncing the latter is the
correct ask. Concrete formulation I recommend registering: a
bare-order rule `P_A` on the R4 atlas's protected cores satisfying
(i) relabeling naturality in the `IntrinsicProbeSubspaceSector` sense,
(ii) overlap compatibility ON OCCUPIED R4 OVERLAPS (restriction of
`P_A` and `P_B` to a shared overlap agree as subspaces of the overlap's
zero-sum space) - which ties this lane to the growing-atlas successor
stage's bounded-dimensional transition reconstruction and makes the
two lanes converge on the same gate, (iii) retarded visibility, and
(iv) the corrected-pairing Lorentzian signature as the displayed
empirical/kernel gate. Kill condition to preregister with it: a
kernel-checked finite family where every rule satisfying (i)-(iii)
fails (iv) on all carriers above some size.

## Notes

The external wrapper's failed low-credit attempt produced no verdict to
reconcile; this audit is independent. Seeds and the R4 frozen-run lane
were not touched.
