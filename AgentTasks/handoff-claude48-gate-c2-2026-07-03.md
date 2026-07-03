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

## 1. State of the tree

- Full `lake build` GREEN (8295 jobs), last confirmed after code cleanup
  `7af42f7`; later final-sweep commits were docs/ledger/handoff-only.
- Everything below is draft-trust, kernel-checked, dependency footprint exactly
  `[propext, Classical.choice, Quot.sound]` (consolidated audit in LEDGER
  heartbeat 05:35). No `s o r r y` / `n a t i v e _ d e c i d e` anywhere in
  GateC1/GateC2.
- Gate C1 (free chiral release) is COMPLETE: symbol + operator GW, operator Weyl
  projectors (`PhysicsSM/Draft/NullEdge/GateC1/`). Red-team-validated (feae0495).
- Gate C2 has 16 theorem files under `PhysicsSM/Draft/NullEdge/GateC2/`:
  integrality (matrix `OverlapIndexIntegrality` / End `OverlapIndexEndIntegrality`
  incl. `trace_ghatEnd` / eigenspace-signature count `OverlapIndexEigenspace` /
  matrix signature `OverlapIndexMatrixSignature` / flagship
  `FlagshipOperatorIndex`), abstract gauge interface `GaugeOverlapInterface`,
  free benchmark at
  three levels (`TetraFreeIndexZero`, `FlagshipOperatorIndexZero`), index density
  + sum rule (`TetraFreeIndexDensity`, `operatorIndex_eq_sum_density`), certified
  sign uniqueness + existence + self-adjointness (`OverlapSignCertificate`,
  `OverlapSignExistence`, `OverlapSignHermitian` - existence proof by Aristotle
  66972f62, ported), witnesses (`OverlapIndexWindingWitness`,
  `OverlapWindingSignJoin`, `OverlapHoppingSignWitness`), gauge invariance
  (`OverlapIndexGaugeInvariance`). C2 arc red-team-validated (ee95ba08, all
  FAITHFUL; caveats folded into docstrings).

## 2. IN FLIGHT - harvest this first

**Aristotle flux-index job `f3296d38-89c2-4ffa-95f5-1916cdd65a6d`**
(`gate-c2-flux-index-20260703`, submitted ~05:10, still RUNNING at handoff).
The ambitious frontier construction: smallest finite lattice with a genuine
nonzero flux (cycle + holonomy; brief recommends pi-flux = real -1 links, no
surds) + gapped Hermitian `H_U` + certified sign + kernel-checked index value.
Brief and context pack: `AgentTasks/aristotle-standalone/gate-c2-flux-index-20260703/`.

Harvest procedure:
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
   roadmap + ledger.

## 3. Next targets after the harvest (priority order)

1. **Gauge index-density**: once a gauge `H_U` exists, transport the density
   machinery (`signKernel`/`freeIndexDensity` pattern in `TetraFreeIndexDensity`)
   to `sign(H_U)`; the sum rule `operatorIndex_eq_sum_density` is the finite
   "index = integral of density" and its gauge version is the anomaly statement.
2. **Sylvester/inertia route for explicit indices**: for a concrete gapped integer
   `H_U`, `n_-` = sign variations in the leading principal minors. Mathlib
   probably lacks Jacobi/Sylvester inertia - consider a focused Aristotle job if
   an explicit spectrum is unavailable.
3. Locality/continuum are documented later gates - do not scope-creep into them.

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

C1 free chiral release complete; C2 index layer comprehensive (integrality,
certified sign existence+uniqueness+self-adjointness, gauge invariance, density +
sum rule, free benchmark at all levels) and red-team-validated; the single open frontier is the
genuine nonzero-flux operator, with Aristotle job f3296d38 in flight on exactly
that - harvest it first.

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
Then `gaugeOverlap_index_signature_form` gives the index directly. The one piece
still needing spectral input is `sig(sign H_U) = sig(H_U)` (that CFC-sign preserves
the eigenvalue-sign counts) - if the flux job (f3296d38) did not establish it, that
is the single clean lemma to hand Aristotle next. Everything else is done.

## 9. The spectral-bridge lemma is now SUBMITTED (Aristotle 25f0b738)

The "single clean lemma to hand Aristotle" from section 8 has been submitted:
`AgentTasks/aristotle-standalone/gate-c2-sign-trace-inertia-20260703/` targets
`epsCFC_trace_eq_inertia` (`Tr(sign H) = #positive eig - #negative eig` for gapped
Hermitian H, via the spectral theorem). Harvest job 25f0b738 the same way as the
flux job. If it lands, port `epsCFC_trace_eq_inertia`, then the gauge index is
`(1/2)(sig gamma5 - inertia(H))` - fully computable from `H`'s eigenvalue signs,
NO functional calculus in the final formula. TWO Aristotle jobs are now in flight
(flux f3296d38 = concrete construction; inertia 25f0b738 = general spectral
bridge); harvest whichever returns. Neither is required for the abstract chain,
which is complete and kernel-checked.

## 10. The eigenvalue-count capstone is STAGED (one-line discharge on inertia harvest)

New kernel-clean file `PhysicsSM/Draft/NullEdge/GateC2/GaugeIndexInertiaForm.lean`
(commit 9f921dc) proves:
- `gaugeOverlap_index_trace_form` (UNCONDITIONAL): gauge index =
  `(1/2)(sig gamma5 - trace(epsCFC H))`.
- `gaugeOverlap_index_inertia_form` (conditional on
  `hinertia : (epsCFC H).trace = nPos - nNeg`): index =
  `(1/2)(sig gamma5 - (nPos - nNeg))`.
When the Aristotle inertia lemma (25f0b738, `epsCFC_trace_eq_inertia`) lands and
is ported, `hinertia` is dischargeable directly, upgrading
`gaugeOverlap_index_inertia_form` to an UNCONDITIONAL eigenvalue-count index.
That is the final capstone of the gauge-index-from-signature chain: the gauge
chiral index computed purely from the eigenvalue signs of the gauge Wilson
operator `H`. Axioms `[propext, Classical.choice, Quot.sound]`.
