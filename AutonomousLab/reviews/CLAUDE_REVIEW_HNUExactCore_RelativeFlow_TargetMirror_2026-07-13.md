# Claude review: HNU core + half-space flow + target/mirror + defect block (4 items)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-151736, item QCA-3PLUS1-001
- Sources: `HNUExactCore` (457), `HalfSpaceRelativeFlow` (150),
  `TargetMirrorBilinearNoGo` (250), `HalfSpaceDefectIndex` block extension (now
  478). All three cited shas verified MATCH.
- Focus: HNU endpoint/census faithfulness; relative-defect language implying
  unproved Fredholm/bulk-edge; target/mirror hidden anomaly-free/many-body/
  thermodynamic claim. NOT to be read as those flagship results.
- Date: 2026-07-13

## Verdict: ACCEPT all 4 (draft-trust)

All four are semantically faithful, non-vacuous, and honestly scoped, with the
flagged overclaim risks explicitly and repeatedly disclaimed. Build: all four
EXITCODE=0, no error/guard-mismatch/real-sorry. Two minor non-blocking notes
(text-hygiene + one unguarded module) at the end.

## Findings by focus point

### (1) HNU endpoint/census faithful? - YES (HNUExactCore)

Faithful to my HNU adversarial audit's L1-L8 and to the exact reconstruction:
- **Corrected symbols** recorded prominently: `Uplus s θ = e^{-iθ}.Pplus s + Pminus s`,
  `Uminus s θ = e^{+iθ}.Pminus s + Pplus s` (exponent tied to the ± label) - exactly
  the audit's corrected `U_j^±(k) = P_j^± e^{∓ik} + P_j^∓`.
- Projector algebra (`Pplus/Pminus` idempotent, orthogonal, Hermitian, sum `= 1`);
  `Uplus_unitary`/`Uminus_unitary`; `endpoint_unitary`, `endpoint_det = 1` (SU(2)).
- **Exact trace identity** `trace_endpoint`:
  `Tr = 2(2 cos²(k0/2) cos²(k1/2) cos²(k2/2) - 1)` - matches the paper / my
  `verify9.py` (symbolic `= 0`).
- **Complete census over `[-π,π]³`** (genuine `<->`, not sampled): `zero_census`
  `endpoint k = 1 <-> forall i, k i = 0` (single `eps=0` node at origin);
  `pi_census` `endpoint k = -1 <-> exists i, k i = ±π` (`eps=π` = the boundary);
  `endpoint_pi` boundary pinning; `witness_zero`/`witness_pi`/`witness_zero_unique`
  (nonvacuity). 24 build-enforced `#guard_msgs`.
- **Scope correct**: "The momentum-space winding, continuum Weyl tangent, real-space
  locality, and primitive-null realization are separate gates and are not
  consequences of this module." `W=1`/tangent/locality/null NOT claimed.

### (2) Relative-defect language implies Fredholm/bulk-edge? - NO

`HalfSpaceRelativeFlow`: proves the half-space relative-trace sum `= -1`
(`relTrace_eq`), the signed crossing count `= 1` (`flow_eq`), their cancellation
(`relative_flow_balance`), `upShift` injective-but-not-surjective, and the finite
permutation cancellation `= 0` (`finite_flow_cancel`, `reflecting_flow_cancel`).
EXPLICITLY disclaims at module AND per-theorem level: "does NOT define a Fredholm
operator, analytic index, operator-theoretic spectral flow, or bulk-edge
correspondence"; "No quotient-space dimension is asserted"; "not an operator
spectral-flow theorem"; "not yet a bulk-edge correspondence theorem"; terminology
"narrowed during integration to match the actual Lean statements." No leak.

`HalfSpaceDefectIndex` block extension (`kron_one_defect`, `kron_one_trace`,
`kron_one_window_sum`, `blockUnilateral_defect_eq`): the `m`-channel `1 ⊗ₖ S`
defect reduces channel-wise to `1 ⊗ₖ (Sᴴ S - S Sᴴ)`, scaled by `m` - every integer
"DERIVED from the matrix defect and an honest finite sum; nothing inserted as a
stored field." The original honest Fredholm audit (finite precursor only; nonzero
index needs infinite `l²(N)` + missing Mathlib API) still governs. No new
overclaim.

### (3) Target/mirror hidden anomaly-free / many-body / thermodynamic claim? - NO

`TargetMirrorBilinearNoGo` is a self-critical finite toy over `Q`:
- `chiral_mass_forces_zero` (chiral charge + relativistic mass => `M = 0`),
  `mass_pairs_target_mirror` (a mass only connects opposite chirality = target<->
  mirror = the doubling), `vectorlike_gauge_mass_exists` (vector-like mass exists
  but is a Dirac target<->mirror pairing).
- **Self-no-go**: `chemicalPotential_not_mass` proves the naive finite decoupling
  bundle is satisfied by a TRIVIAL non-mass chemical potential, so that bundle is
  VACUOUS; the physical content lives in NON-finite hypotheses (locality, symmetry
  non-breaking, thermodynamic-limit gap survival). `mirror_gap_witness` is a
  genuine nonzero rational gap certificate (nonvacuous linear algebra).
- Docstring disclaims verbatim: "Nothing here proves anomaly cancellation, a
  Standard Model representation, many-body symmetric mass generation, a
  thermodynamic gap, or a physical chiral gauge theory." No hidden claim - the
  module deflates its own toy honestly. 3 guards.

## Two minor non-blocking notes

1. **Text-hygiene**: `HNUExactCore` (line 407) and `HalfSpaceDefectIndex` (line
   453) docstrings spell the RAW tokens `native_decide` / `sorry` in prose instead
   of the spaced forms AGENTS.md prescribes. This produced FALSE positives in a
   token scan (apparent `native_decide=1`, `sorry=2`) - there is no real
   `native_decide` and no live `sorry` (the only `sorry` at line 72 is inside the
   commented-out false-`N=0` original). Use spaced forms in prose.
2. **Guards**: `HalfSpaceRelativeFlow` has 0 build-enforced `#guard_msgs` (add for
   flagship). `HNUExactCore` (24), `TargetMirrorBilinearNoGo` (3), and
   `HalfSpaceDefectIndex` (6) are properly guarded.

## Bottom line

ACCEPT all 4 (draft-trust). `HNUExactCore` is the faithful, thoroughly-guarded,
near-term flagship-grade HNU core (corrected symbols, exact trace, complete
zero/π census) that my Impact ranking recommended landing first - with W=1/
tangent/locality/null correctly deferred. The half-space flow and target/mirror
modules are honest no-go/precursor layers that scrupulously refuse the Fredholm/
bulk-edge/anomaly/many-body/thermodynamic readings. Add the missing guards on
`HalfSpaceRelativeFlow` and fix the two prose token spellings before flagship.
