# Handoff to Claude 4.8: Gate C2 state after the 2026-07-02/03 overnight run

Written 2026-07-03 ~05:40 PDT by the overnight Claude lane (Fable 5), at the end
of the co-equal Claude+Codex+Aristotle run. This is the single document to read
before continuing Gate C2. Companion documents:

- `Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md` - the technical
  summary of the whole C2 layer (results, honest scope, open frontier).
- `docs/NERD_ROADMAP.md` - gate ladder; C1 row and the C2 block are current.
- `AgentTasks/overnight-nerd-run-2026-07-02/` - LEDGER.md (claims, Aristotle
  registry, heartbeats), DISCUSSION.md (threaded review log), MORNING_REPORT.md
  (the full night's report; cross-review coverage recorded).

**Update 2026-07-03 07:13 PDT (Codex):** the two jobs that were live in this
handoff are now harvested and ported. `f3296d38` produced the
`FluxOverlapIndex.lean` `pi`-flux triangle witness (commit `389c713`), and
`25f0b738` produced the sign-trace/inertia spectral bridge in
`GaugeIndexInertiaForm.lean` (commit `4843ff2`). Full root `lake build` passed
after `4843ff2`. Where older prose below describes a job as in flight, this
update supersedes it.

## 1. State of the tree

- Full `lake build` GREEN (8295 jobs), last confirmed after Gate C2
  sign-trace/inertia port `4843ff2`; existing info/linter/deprecation chatter
  only.
- Everything below is draft-trust, kernel-checked, dependency footprint exactly
  `[propext, Classical.choice, Quot.sound]` (consolidated audit in LEDGER
  heartbeat 05:35). No `s o r r y` / `n a t i v e _ d e c i d e` anywhere in
  GateC1/GateC2.
- Gate C1 (free chiral release) is COMPLETE: symbol + operator GW, operator Weyl
  projectors (`PhysicsSM/Draft/NullEdge/GateC1/`). Red-team-validated (feae0495).
- Gate C2 has 18 theorem files under `PhysicsSM/Draft/NullEdge/GateC2/` plus
  the aggregate import `PhysicsSM/Draft/NullEdge/GateC2.lean`:
  integrality (matrix `OverlapIndexIntegrality` / End `OverlapIndexEndIntegrality`
  incl. `trace_ghatEnd` / eigenspace-signature count `OverlapIndexEigenspace` /
  matrix signature `OverlapIndexMatrixSignature` / flagship
  `FlagshipOperatorIndex`), abstract gauge interface `GaugeOverlapInterface`,
  eigenvalue-count/inertia form `GaugeIndexInertiaForm`,
  free benchmark at
  three levels (`TetraFreeIndexZero`, `FlagshipOperatorIndexZero`), index density
  + sum rule (`TetraFreeIndexDensity`, `operatorIndex_eq_sum_density`), certified
  sign uniqueness + existence + self-adjointness (`OverlapSignCertificate`,
  `OverlapSignExistence`, `OverlapSignHermitian` - existence proof by Aristotle
  66972f62, ported), witnesses (`OverlapIndexWindingWitness`,
  `OverlapWindingSignJoin`, `OverlapHoppingSignWitness`), gauge invariance
  (`OverlapIndexGaugeInvariance`), and genuine flux witness
  `FluxOverlapIndex`. C2 arc red-team-validated (ee95ba08, all FAITHFUL; caveats
  folded into docstrings).

## 2. HARVESTED - flux result

**Aristotle flux-index job `f3296d38-89c2-4ffa-95f5-1916cdd65a6d`**
(`gate-c2-flux-index-20260703`, submitted ~05:10, later IDLE/COMPLETE) has been
harvested and ported as `PhysicsSM/Draft/NullEdge/GateC2/FluxOverlapIndex.lean`
in commit `389c713`. The result is the first genuine-flux witness: a `pi`-flux
triangle with gauge-invariant holonomy `-1`, certified rational sign, overlap
index `-1`, zero-flux triangle index `+1`, and `Delta=-2` flux response. Honest
caveat: the odd 3-cycle has a parity index at every flux, so the remaining
successor is an even-lattice / 2D-torus zero-to-nonzero flux index.
Brief and context pack: `AgentTasks/aristotle-standalone/gate-c2-flux-index-20260703/`.

Historical harvest procedure (already performed):
1. `aristotle list --limit 5` until IDLE; `aristotle tasks f3296d38...` for the
   task id; `aristotle show f3296d38... --task <tid>` for the summary.
2. `cd AgentTasks/aristotle-standalone/gate-c2-flux-index-20260703 && aristotle
   download f3296d38-89c2-4ffa-95f5-1916cdd65a6d` then `tar -xzf` the archive to
   get the Lean file (this is the working retrieval path; `show` gives prose only).
3. REVIEW BEFORE PORTING, against these traps (all documented in the brief):
   - Tree/single-link carrier: no cycle means the flux gauges away (reject).
   - Conjugation trap: `overlapIndex_conj` proves a gauge transform CANNOT change
     the index, so if the "flux" model is a conjugate of a trivial/defect model,
     the nonzero index is NOT from the flux (reject as a flux claim).
   - Pi-flux time-reversal subtlety: pi-flux is T-invariant, so a too-symmetric
     pi-flux model may honestly have index 0. A proved 0 WITH explanation is a
     VALID negative deliverable - record it, don't force a nonzero.
4. If sound: port under `PhysicsSM/Draft/NullEdge/GateC2/` (pattern: the
   `OverlapSignExistence.lean` port), axiom-audit every theorem, placeholder
   scan, module build, full `lake build`, commit, update the C2 summary doc +
   roadmap + ledger. This checklist was completed for the repo-adapted port.

## 3. Next targets after the harvest (priority order)

1. **Even/toroidal flux index**: upgrade the odd `pi`-flux triangle witness to an
   even lattice / 2D Wilson-Dirac torus with net flux and a zero-to-nonzero index.
2. **Gauge index-density**: transport the density machinery
   (`signKernel`/`freeIndexDensity` pattern in `TetraFreeIndexDensity`) to
   `sign(H_U)`; the sum rule `operatorIndex_eq_sum_density` is the finite
   "index = integral of density" and its gauge version is the anomaly statement.
3. **Locality/continuum**: documented successor gates; keep them separate from
   the finite witness layer.

## 4. Conventions and gotchas (cost real time tonight)

- Loewner order on complex matrices is NOT a global instance:
  `open scoped ComplexOrder` + `attribute [local instance] Matrix.instPartialOrder
  Matrix.instStarOrderedRing Matrix.instNonnegSpectrumClass`.
- `Matrix.PosSemidef.sqrt_eq_iff_eq_sq` is deprecated (use `CFC.sqrt_eq_iff` when
  touching that code; current uses compile with warnings - do not churn).
- `rw` rewrites ALL identical occurrences at once - the Fourier-transport proofs
  use `simp only [...]` for block-diagonalization rewrites (see
  `TetraOperatorWeylProjectors`).
- Lean block comments NEST: a literal `/-` inside a docstring (e.g. in `+1/-1`)
  opens a nested comment and breaks the file.
- `open` for GateC1 namespaces from GateC2 files needs FULL paths
  (`open PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolOverlapGW` etc.).
- Root-level `dotProduct` (not `Matrix.dotProduct`); `Module.End.mul_eq_comp`
  (not `LinearMap.mul_eq_comp`); `Matrix.mulVec_single_one` for delta vectors;
  trace via basis = `LinearMap.trace_eq_matrix_trace` + `Pi.basis`/`Pi.basisFun`
  (worked cleanly in `FlagshipOperatorIndexZero.trace_signHfreeL`).
- Pre-commit strips UTF-8 BOMs and ABORTS that commit - just re-add and
  re-commit. The `--files` case-conflict check sometimes flakes under the stash;
  `pre-commit run check-case-conflict --all-files` to confirm a real conflict.
- Shared coordination files (LEDGER/DISCUSSION/MORNING_REPORT/roadmap/C2 summary)
  are edited by BOTH agents: append-only for logs; re-read before Edit on the
  others (concurrent-edit collisions produced one duplicate section tonight -
  dedupe if you see one).
- Codex lane: I1 standalone Core (`AgentTasks/aristotle-standalone/
  gate-i1-kinematic-core-20260702/`) is kernel-checked but NOT yet ported into
  the main tree ("morning port" debt, see MORNING_REPORT section 4). Ten of its
  load-bearing theorems are semantically cross-reviewed and accepted (see
  DISCUSSION reviews: i1_2, i1.9, i2, i3.5, a1, a2, u2, d1, d3.0, d6).

## 5. Verification commands

```bash
lake build PhysicsSM.Draft.NullEdge.GateC2.<Module>   # targeted
lake build                                             # full (8295 jobs, green)
# axiom audit pattern: temp file with #print axioms, run via lake env lean
# placeholder scan: grep -nE "sorry|admit|native_decide" <file>
```

## 6. One-line summary

C1 free chiral release complete; C2 index layer comprehensive and
red-team-validated: integrality, certified sign existence+uniqueness+
self-adjointness, gauge invariance, density + sum rule, free benchmark at all
levels, eigenvalue-count gauge index, and first genuine `pi`-flux witness. The
single open C2 frontier has moved to the even-lattice / 2D-torus zero-to-nonzero
flux model and gauge-density/anomaly bridge.

## 7. Additions after this handoff was first written (all committed, kernel-clean)

Landed while the flux job ran (all `[propext, Classical.choice, Quot.sound]`):

- **Anomaly-bridge rungs** (`TetraFreeIndexDensity.lean`,
  `FlagshipOperatorIndexZero.lean`): the real-space kernel `signKernel` of
  `sign(Hfree)` with `signHfree_apply_eq_kernel_sum`; translation-invariant
  diagonal `signKernel_diag`; the local density `freeIndexDensity_eq_zero`
  (vanishes site-wise); the operator value `flagship_operatorIndex_eq_zero`
  (= 0 exactly); and the SUM RULE `operatorIndex_eq_sum_density` (index =
  site-sum of local density, unconditional - the finite "index = integral of
  density"). The gauge version of these is the anomaly bridge - transport the
  same kernel/trace machinery to `sign(H_U)` once the flux operator exists.
- **Certificate self-consistency** (`OverlapSignHermitian.lean`):
  `signCertificate_isHermitian` (the three conditions force self-adjointness) and
  `epsCFC_isSelfAdjoint_involution` (the explicit sign is a self-adjoint
  involution). Certificate story is now complete: exists + unique + self-adjoint
  involution + GW.
- **Index = signature** (`OverlapIndexEigenspace.lean`):
  `specProjEnd_range_eq_eigenspace` / `_ker_eq_eigenspace` (range/ker of the +1
  projector are the +/-1 eigenspaces), `involution_eigenspace_finrank_add` (the
  +/-1 spectral decomposition), `trace_involution_eq_signature`
  (`Tr f = n_+ - n_-`), `overlapIndexEnd_eq_eigenspace_dim_sub`, and
  `overlapIndexEnd_eq_half_signature_sub` (`= (1/2)(sig f - sig g)`). This makes
  the design brief's CONTROLLING FACT (`overlapIndex = -(1/2) sig(eps)`) a
  kernel-checked theorem - the deepest structural result of the layer, and the
  bridge for turning any future flux operator's SIGNATURE directly into its index.
- **`trace_ghatEnd`** (in `OverlapIndexEndIntegrality.lean`): the End index = trace
  of the Luscher modified chirality (the trace-index formula is a theorem).

Definitive full-C2 axiom sweep (LEDGER 08:50): all headline theorems across the 14
GateC2 files report `[propext, Classical.choice, Quot.sound]`; zero
sorryAx / n a t i v e _ d e c i d e / ofReduceBool / trustCompiler. Full
`lake build` green (8295).

## 8. The abstract chain is COMPLETE - the flux path is now purely a signature

Two more capstones landed (commits 91e3409, 7c817da, d9cde0c):
- `GaugeOverlapInterface.lean`: for ANY gapped Hermitian `H`, the certified overlap
  is well-defined, GW, and has an INTEGER index (`gaugeOverlap_index_isInteger`,
  `gaugeOverlap_ginspargWilson`, `gaugeOverlap_index_certificate_independent`).
- `OverlapIndexMatrixSignature.lean`: `overlapIndex gamma5 eps = (1/2)(sig gamma5 -
  sig eps)` at the matrix level (`overlapIndex_eq_half_signature`), where
  `matrixTraceSignature M = dim(ker(toLin' M -1)) - dim(ker(toLin' M +1))`.
- `GaugeOverlapInterface.gaugeOverlap_index_signature_form`: combines them -
  `overlapIndex gamma5 (epsCFC H) = (1/2)(sig gamma5 - sig(sign H))`.

**Revised harvest path (supersedes section 3):** the abstract theory is complete;
the gauge index is now a THEOREM in terms of the certified sign's signature. To
finish a concrete flux example you need ONLY:
1. an explicit gapped Hermitian gauge Wilson matrix `H_U` (with a genuine flux -
   the cycle/holonomy discipline of section 2 still applies), and
2. the SIGNATURE of its certified sign `sign(H_U) = epsCFC H_U`, i.e.
   `sig(H_U) = n_+ - n_-` of `H_U` (the sign preserves eigenvalue signs). For an
   explicit integer `H_U` this is decidable via eigenvalue signs / Sylvester's
   leading-principal-minor criterion.
Then `gaugeOverlap_index_signature_form` gives the index directly. The spectral
input `Tr(sign H) = n_+ - n_-` is now proved in
`GaugeIndexInertiaForm.epsCFC_trace_eq_inertia`, so the abstract gauge-index
chain is unconditional. The concrete `pi`-flux triangle also exists in
`FluxOverlapIndex.lean`; the successor is the even-lattice / torus version, not a
missing spectral bridge.

## 9. The spectral-bridge lemma is now HARVESTED (Aristotle 25f0b738)

The "single clean lemma to hand Aristotle" from section 8 was submitted and
returned COMPLETE:
`AgentTasks/aristotle-standalone/gate-c2-sign-trace-inertia-20260703/` targets
`epsCFC_trace_eq_inertia` (`Tr(sign H) = #positive eig - #negative eig` for gapped
Hermitian H, via the spectral theorem). It is ported in
`GaugeIndexInertiaForm.lean` (commit `4843ff2`). The gauge index is now
`(1/2)(sig gamma5 - inertia(H))` - fully computable from `H`'s eigenvalue signs,
with no functional calculus in the final formula.

## 10. The eigenvalue-count capstone is COMPLETE

New kernel-clean file `PhysicsSM/Draft/NullEdge/GateC2/GaugeIndexInertiaForm.lean`
(commits `9f921dc`, `4843ff2`) proves:
- `gaugeOverlap_index_trace_form` (UNCONDITIONAL): gauge index =
  `(1/2)(sig gamma5 - trace(epsCFC H))`.
- `epsCFC_trace_eq_inertia`: trace of the certified sign equals
  `nPos - nNeg`.
- `gaugeOverlap_index_eigenvalue_count_form`: gauge index =
  `(1/2)(sig gamma5 - (nPos - nNeg))` unconditionally.
That is the final capstone of the gauge-index-from-signature chain: the gauge
chiral index computed purely from the eigenvalue signs of the gauge Wilson
operator `H`. Axioms `[propext, Classical.choice, Quot.sound]`.

## 11. BOTH Aristotle harvests COMPLETE - the C2 chain is unconditional + fluxed

Both live jobs are harvested, integrated, and kernel-verified (aggregate build
`lake build PhysicsSM.Draft.NullEdge.GateC2` = 8063 jobs green, all 18 modules):

- FLUX (f3296d38 -> `FluxOverlapIndex.lean`, commit 389c713, claude): the pi-flux
  triangle - a genuine gauge flux (gauge-invariant holonomy -1), certified
  rational sign, `overlapIndex_flux = -1`, `flux_shifts_index` Delta=-2. Rewired
  onto the trusted repo `overlapIndex`/`SignCertificate`;
  `flux_is_nonzero_integer_witness` instantiates the abstract interface with a
  nonzero value. Semantic review vs all three documented traps: clean.
- INERTIA (25f0b738 -> `GaugeIndexInertiaForm.lean`, commit 4843ff2, codex,
  cross-reviewed by claude): `epsCFC_trace_eq_inertia` (`Tr(sign H) = n_+ - n_-`
  via `epsCFC H = cfc sign H`) + the UNCONDITIONAL capstone
  `gaugeOverlap_index_eigenvalue_count_form`. Axiom-clean, verified.

Net: the gauge chiral index of any gapped Hermitian gauge operator is now computed
purely from the eigenvalue signs of `H`, unconditionally, AND there is a concrete
nonzero-flux operator realizing it. New convenience: `GateC2.lean` aggregator
(one-command build of the whole layer; NOT a default target - the no-arg
`lake build` is the SPL-free core and does NOT include the NullEdge gate tree).

NEXT FRONTIER (from the write-up section 4): an EVEN lattice / 2D Wilson-Dirac
operator on a torus with net flux 2 pi (a genuine ZERO-to-nonzero flux index; the
odd triangle carries an index at every flux), then the anomaly / index-density
bridge, then locality / continuum.
