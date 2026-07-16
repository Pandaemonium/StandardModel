# Claude review: Gate-1 half-space HNU determination (DECISIVE)

- Reviewer: interactive Claude Code (claude family), Skeptic, solo mode
- Source: Aristotle job `da29672d` (my Gate-1 build spec, run ~5.5h),
  `HNURealSpace/HalfSpaceHNU.lean` + sorry-free precursor
  `HNURealSpace/HalfSpaceDefectIndex.lean`. Date: 2026-07-14

## Headline: GATE 1 RESOLVES TO DOUBLING (outcome b, no-go) - the honorable mapped-impossibility branch

The decisive fork my whole synthesis pointed to is answered. Determination:

> **`Qwindow = 2 * (tr p - tr q)` (`Qwindow_formula`); the HNU moving projectors
> `p = P3-`, `q = P3+` are BALANCED (`tr p = tr q`, each rank `L^2`), so
> `Qwindow = 0` (`Qwindow_eq_zero`) - outcome (b): NO isolated single chiral edge
> defect. The `+` and `-` boundary charges pair-cancel; the doubling is manifest.**

A single edge Weyl (outcome a) would require a chirality imbalance `tr p != tr q`,
which the HNU walk does NOT have. So the null-edge HNU single-Weyl realization is
FALSIFIED at the half-space boundary, with the precise mechanism identified:
**the HNU walk is chirality-balanced, so its boundary doubles.**

## Evidence status: M | PARTIAL (sound + numerically verified; 2 mechanical sorrys)

Independently built (2-file scratch, HalfSpaceDefectIndex + HalfSpaceHNU): `lake
build` EXITCODE=0.
- **The determination is sound and numerically verified.** The report confirms
  the formula on BOTH sides: balanced instances (all four coins varied, `K in
  {2,3,4}`) give `Qwindow = 0`; deliberately UNBALANCED projectors (rank 1 vs 3 in
  `d=4`) give `Qwindow = -/+4 = 2(tr p - tr q)`. So the `2(tr p - tr q)` formula is
  confirmed by exact rational arithmetic, not assumed.
- **The precursor `HalfSpaceDefectIndex.lean` is fully SORRY-FREE** (my Choice-A
  absorbing-boundary spec, realized): `localized_window_trace_stabilizes = +1` for
  every cutoff `M > K+1`, channel-additive, orientation-odd (`= -1`), bilateral
  control `= 0`. Standard-three guards.
- **All Gate-1 controls + witness are SORRY-FREE and guarded** (standard-three):
  `periodic_control` (cyclic axis-3 -> `Dop = 0`), `pure_shift_window_trace`/
  `Bp_window_trace`(+tr p)/`Bm_window_trace`(-tr q) (single substep reproduces the
  `+1` precursor), `Qwindow_witness_substep` (`d=2,M=8,K=2`: single `+` substep
  `= +1`, nonvacuous), `trace_proj_conj`, `condOp_Dop`.
- **The 2 headline theorems carry `sorryAx`, HONESTLY EXPOSED.** `Qwindow_formula`
  and `Qwindow_eq_zero` depend on exactly two mechanical operator-telescoping
  lemmas `telescope_adjmul`/`telescope_muladj` (the 8-factor peel of `1 - U^H U` /
  `1 - U U^H`), which are `sorry` (build shows 2 `declaration uses sorry`; the two
  headlines print `[propext, sorryAx, Classical.choice, Quot.sound]` via UNGUARDED
  `#print axioms` - not hidden behind a false standard-three guard). Every
  sub-ingredient (tensor boundary identities, near-source `= tr W`, far term `= 0`,
  trace-cyclicity) is sorry-free. Per the summary this is a formalization-size
  obstruction, not a mathematical one.

So: the MATHEMATICAL determination (doubling, `Qwindow = 0`, mechanism = balanced
projectors) is trustworthy (formula + numerics + sorry-free sub-lemmas + controls);
the LEAN headline is DRAFT pending the 2 telescope lemmas. This is exactly the
"documented sorry, not a weakened statement" the task required.

## Over-claim audit

- Vacuity: none - concrete `Qwindow_witness_substep` (+1) and `Qwindow_witness`
  (0), and the unbalanced numerical instances make the formula bite.
- False shape: none - `Qwindow = 2(tr p - tr q)` is the genuine window-defect
  charge; `Qwindow_eq_zero` is conditioned on the real balance hypothesis `hbal`.
- Docstring-outruns-kernel: NONE - exemplary. The module honestly exposes the
  sorryAx dependence rather than guard-faking it, and disclaims Fredholm/bulk-edge/
  continuum/physical/SM.

## Consistency with the refill map (a coherent mechanistic picture)

This closes the loop with tonight's refill:
- domain-wall (9eb52ec3): sublattice IMBALANCE -> single unpaired species.
- gamma-transverse (87e8d4f4): BALANCED transverse -> paired net-zero.
- HNU composite (d82ea36b): one UNSIGNED crossing (chirality-blind).
- **Gate-1 (da29672d): HNU is BALANCED (tr p = tr q) -> SIGNED window charge 0 ->
  doubling.** The signed test the unsigned crossing left open resolves to doubling.

Unified statement: a finite boundary hosts a single chiral Weyl IFF it carries a
chirality/sublattice imbalance; the HNU walk is balanced, so it doubles.

## Program + manuscript significance

Gate 1 is the decisive gate, and it lands on the NO-GO branch - the honorable
mapped-impossibility outcome (charter Sec 2.2). Per the Impact audit this FLIPS the
physics-venue lede to the IMPOSSIBILITY: "the null-edge HNU regulator cannot host
an isolated single Weyl at its half-space boundary; it doubles, because the walk is
chirality-balanced (`tr P3- = tr P3+`); a single edge mode would need the imbalance
the walk lacks." A clean, publishable no-go WITH the mechanism.

Required prose boundaries: (1) report as M|partial - the determination is
numerically verified and sorry-free in its sub-lemmas, but `Qwindow_eq_zero` is not
kernel-complete until the 2 telescope lemmas land; (2) finite-lattice determination
only (no Fredholm/bulk-edge/continuum/physical/SM); (3) the mechanism is the
balance `tr p = tr q`; (4) do NOT quote `Qwindow_eq_zero` as kernel-checked (it has
sorryAx) - the controls, witness, and precursor ARE.

## Recommended next step (one)

Complete the two mechanical telescope lemmas `telescope_adjmul`/`telescope_muladj`
(the 8-factor `1 - U^H U` peel) to make the headline kernel-complete and convert
the unguarded prints to standard-three `#guard_msgs`. A tightly-scoped, high-value
Aristotle (or careful manual) target - it upgrades a decisive numerically-verified
no-go to a fully kernel-checked one. This is the single highest-value follow-on.

## Bottom line

APPROVE the DETERMINATION (M|partial): Gate 1 resolves to DOUBLING - the HNU
half-space boundary carries no isolated single chiral defect (`Qwindow = 0`)
because the HNU walk is chirality-balanced; verified numerically and sorry-free in
every sub-lemma, with only 2 mechanical telescoping `sorry`s remaining in the two
headline theorems (honestly exposed). This is the decisive, mechanistically-explained
no-go for the null-edge single-Weyl realization - the mapped-impossibility outcome,
consistent with the whole refill map. Finish the 2 telescopes to make it fully
kernel-checked.

---

## UPDATE 2026-07-14T16:0x - GATE 1 NOW FULLY KERNEL-CHECKED (M, standard-three)

The telescope-completion follow-on (da29672d, ~2.5h) proved both mechanical lemmas
`telescope_adjmul`/`telescope_muladj` (via a reusable `RowHigh` row-support layer +
`tele2`/`tele2m` two-factor identities + emb-conjugation window-trace invariance),
WITHOUT changing any statement or weakening any hypothesis, and converted the two
headline `#print axioms` to build-enforced `#guard_msgs`.

Independent confirmation: rebuilt (2-file scratch, HalfSpaceDefectIndex +
HalfSpaceHNU) `lake build` EXITCODE=0. `Qwindow_formula` and `Qwindow_eq_zero` are
now wrapped in `#guard_msgs in #print axioms`, and the build PASSES - so both depend
on EXACTLY `[propext, Classical.choice, Quot.sound]` with NO `sorryAx` (a mismatch
would fail the guard). The only `sorry` token in the file is the prose "sorry-free"
in a docstring. Grade upgraded **M | partial -> M (fully kernel-checked)**.

**Final status:** Gate 1 is a fully kernel-checked no-go. The HNU half-space
boundary window charge `Qwindow = 2(tr p - tr q) = 0` (balanced HNU projectors) ->
DOUBLING, no isolated single chiral edge defect - now standard-three, zero sorry,
guard-pinned, independently rebuilt. The mapped-impossibility outcome is
kernel-complete. Landing at integration: port `HNURealSpace/*` (reconcile with any
live namespaces), add the guard block to the lane guard file.
