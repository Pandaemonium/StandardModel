# Claude review: AnomalyIndexLedger + Finite3450QuarticResonance

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-163719, item QCA-3PLUS1-001
- Sources: `AnomalyIndexLedger.lean` (314, sha 4ec2fb5b MATCH),
  `Finite3450QuarticResonance.lean` (605, sha 83ef0d4b MATCH), harvest audit
  `CODEX_ANOMALY_SMG_HARVEST_AUDIT_2026-07-13.md` (sha d1183e99 MATCH)
- Date: 2026-07-13

## Verdict: APPROVE

Both modules are faithful, arithmetically correct, non-vacuous, and scrupulously
scoped, with the critical `full_hamiltonian_has_zero_mode` correctly blocking any
full mirror-gap/SMG reading. Both build EXITCODE=0 (kernel-clean: 0 sorry/
native_decide/axiom); their key theorems are centrally guarded (proper
`#guard_msgs`) in `OvernightTheoryAxiomGuard`. No repair required.

## AnomalyIndexLedger

- **Hypercharge convention - CORRECT.** `Q = T3 + Y/2`, all-left-handed:
  `yQ=1/3, yL=-1, yU=-4/3, yD=2/3, yE=2`. Verified against the charges
  (`Q_up = 1/2+1/6 = 2/3`, `u^c` has `Y=-4/3`, etc.). Faithful.
- **Weight/moment arithmetic - CORRECT (verified by hand).** `smLedger` weights
  `6,2,3,3,1` sum to `count = 15` (LH Weyl count of one generation);
  `firstMoment = Sum Y = 6(1/3)+2(-1)+3(-4/3)+3(2/3)+1(2) = 0`;
  `cubicMoment = Sum Y³ = 0`; `su2_moment = 3yQ+yL = 0`, `su3_moment = 2yQ+yU+yD
  = 0`. All SM anomaly conditions hold exactly.
- **No-implication theorem MEANINGFUL.**
  `anomaly_moments_do_not_force_zero_count`: the charge-weighted moments vanish
  yet `count = 15 != 0`. Genuine content: the unweighted count is the 0-th
  moment, invisible to every charge weighting, so anomaly cancellation does NOT
  force the oriented boundary count to vanish (the missing datum is
  orientation/mirror). Not trivial - a real separation.
- **One-entry minimality correctly limited to the aggregate integer-weight API.**
  `sm_single_aug_classification`: any single appended entry cancelling the count
  while preserving the first moment must be charge-neutral with `weight = -15`.
  The docstring is explicit: "one `Channel` may carry any integer weight ...
  `sink.weight = -15` packages fifteen elementary opposite-oriented units into
  one ledger entry. The theorem is minimal only in list-entry count under this
  aggregate API." Correctly scoped - not a claim that 15 units collapse to one
  physical channel.

## Finite3450QuarticResonance

- **3-4-5-0 convention / anomaly (semantic gate 1) - FAITHFUL.** Charges
  `3,4,5,0`; chirality L(+1)={3,4}, R(-1)={5,0}; `gauge_anomaly_free`
  `Sum chi q² = 9+16-25-0 = 0`; `gravitational_anomaly_free` `Sum chi = 0`
  (`#L=#R`). Correctly notes no `U(1)`-invariant quadratic mirror mass exists
  (charges don't coincide across chiralities), so the mechanism must be
  many-body; the neutral quartic uses `3+5 = 4+4`.
- **Jordan-Wigner / charge conservation.** `cre`/`ann` are JW operators with CAR
  signs; `Ham = cre 0 cre 3 ann 1 ann 2 + h.c.` `Ham_charge_conserving`
  (`[Ham,Qop]=0`) follows from `Q_cre`/`Q_ann` and the `3+5=4+4` balance.
  `Ham_witness` `Ham|4,4> = -|3,5>`. Build EXITCODE=0 confirms the operator
  semantics elaborate.
- **Bilinear no-go API.** `Ham_not_bilinear` (`Ham` is not any `Sum c_ij cre_i
  ann_j`) and `Ham_not_diagonal` reject the one-particle-mass and
  chemical-potential vacuity controls - genuinely many-body.
- **Exact two-state gap.** `mirror_gap_SOS`: for `psi` in `span{|4,4>,|3,5>}`,
  `||Ham psi||² = ||psi||²`, so the mirror spectrum is exactly `{+1,-1}`, a
  sharp rational gap `1` (with `Ham_eig_plus/minus`). Correct SOS identity.
- **`full_hamiltonian_has_zero_mode` BLOCKS the full mirror-gap/SMG reading -
  CONFIRMED (the decisive check).** It exhibits a nonzero zero mode of the full
  32-dim `Ham` (the vacuum `Pi.single emptyset 1`, `Ham_vacuum_annihilated` +
  `vacuum_state_ne_zero`); and `Ham_target_annihilated` shows EVERY
  single-particle state is a zero mode, `Ham_target_decoupled` that they do not
  connect to the resonance subspace. So the sharp gap lives ONLY on the 2-dim
  pair subspace and the full operator is massively degenerate at zero - no full
  SMG gap. The Audit section states this verbatim: "not a gap of the full
  Fock-space operator ... emphatically not a proof of a thermodynamic-limit
  mirror-decoupling theorem ... a precise linear-algebra fact, not a physical
  mirror-decoupling statement." Anomaly-freedom is explicitly INPUT data, not
  used to prove the gap; no SSB; locality/volume not analysed.

## Guards + build

- Both modules build `lake env lean ... EXITCODE=0`, no error/guard-mismatch/
  sorry; 0 `sorry`/`native_decide`/`axiom`/`opaque`/`admit`.
- Both are guarded CENTRALLY in `OvernightTheoryAxiomGuard` with proper
  `#guard_msgs (whitespace := lax) in #print axioms` (verified 4408-4435):
  `anomaly_moments_do_not_force_zero_count`, `sm_single_aug_classification`,
  `stabilizedIndex_eq_count`; `Ham_charge_conserving`, `Ham_not_bilinear`,
  `mirror_gap_SOS`, `full_hamiltonian_has_zero_mode` - all pinned to the standard
  three. (`Finite3450QuarticResonance` states its pins live there.) A full
  `OvernightTheoryAxiomGuard` build to confirm every central pin green is the
  standard post-integration step; the modules' own footprint is standard-three,
  so these central pins are satisfied.

## Bottom line

APPROVE. `AnomalyIndexLedger` correctly separates charge-weighted anomaly
cancellation from the unweighted oriented count (a meaningful no-go, honest
aggregate-API minimality), and `Finite3450QuarticResonance` is an honest finite
resonance control whose `full_hamiltonian_has_zero_mode` + Audit section make it
impossible to misread the 2-state gap as symmetric mass generation or a
mirror-decoupling theorem. Both faithful, kernel-clean, centrally guarded.
