# Red-team report: D-PROJ-L2

- Claim: `projectAt_tendsto_strong_L2` -- the normalized finite cell-average
  projections on the Gate D refining/exhausting schedule converge strongly in
  squared `L2(R^3)` error to every complex `L2` field.
- Builder: codex (research_scientist, NE-CONTINUUM)
- Skeptic: claude (cross-family; Claude-family reviewing a Codex-family build)
- Date: 2026-07-12
- Decls audited: `ChangingMomentumCellProjectionStrongL2.projectAt_tendsto_strong_L2`,
  `...CompactCore.compact_lipschitz_projectAt_tendsto_sq_error_zero`,
  and the dependency chain (`projectFinite`, `projectAt`, `cellAverage`,
  `memLp_exists_compact_smooth_lipschitz_sq_approx`,
  `projectFinite_pointwise_error_on_cell`, `projectAt_sq_error_le_of_approx`).

## Verdict: CO-SIGN (confirm) as grade M, SRL 5, kernel-clean.

The theorem means exactly what it says and the proof is non-vacuous.

## Semantic checks performed

1. **Statement faithfulness.** `Tendsto (fun N => ∫ ‖projectAt N f x - f x‖^2)
   atTop (nhds 0)` for every `f` with `MemLp f 2 volume` is precisely "strong
   convergence in squared L2 error, for all L2 fields." Universally quantified;
   no hidden restriction. PASS.
2. **`projectAt` is a genuine normalized projection, not vacuous.**
   `projectAt N f = projectFinite (physicalSpacing N) (scheduledModes N) f`,
   `projectFinite = Σ_k indicator(cell k)(cellAverage k f)`. Normalization is
   real: `projectFinite_const_one_on_cell` proves the projection of the
   constant `1` is exactly `1` on every selected cell (a true average, not an
   unnormalized or lossy sample), and `projectFinite_congr_ae` gives
   a.e.-invariance (representative-safe, required for L2 classes). PASS.
3. **Refining mesh is genuine.** `physicalSpacing N = 1/(N+1) -> 0`. PASS.
4. **Density lemma is honest and complete.**
   `memLp_exists_compact_smooth_lipschitz_sq_approx` delivers all six needed
   properties (compact support, `ContDiff ℝ ⊤`, `0 ≤ L`, global Lipschitz,
   `MemLp g 2`, and `∫‖f-g‖^2 ≤ ε`) on a landed C_c^∞ L2-density theorem. PASS.
5. **Analytic core is real.** `projectFinite_pointwise_error_on_cell` proves the
   per-cell error `≤ L*h` from the cell diameter and
   `norm_setIntegral_le_of_norm_le_const`; the compact core squeezes
   `error ≤ V*(L*physicalSpacing N)^2 -> 0` with the active-cell volume
   eventually bounded. Genuine approximation content, not telescoping. PASS.
6. **Footprint.** `#print axioms` = `[propext, Classical.choice, Quot.sound]`
   on both headline decls, build-enforced by in-file guard blocks. Standard-3
   on the final theorem guarantees no `sorry`/`native_decide` anywhere in the
   transitive chain. PASS.

## Over-claim audit (all ten modes)

- vacuity: NO (normalization + density + refining mesh all genuine).
- hollow telescoping: NO (real Lipschitz/volume/density content).
- docstring outruns kernel: NO -- docstrings are MORE conservative than the
  kernel (they explicitly disclaim walk-coefficient identification, inverse
  Fourier transport, and the position-space Dirac PDE limit).
- false shape: NO (statement = intended mathematics).
- convention drift: N/A (pure L2 statement).
- source laundering: N/A (self-contained; density lemma from a landed in-repo
  theorem).
- **finite-to-continuum slippage: NO, and this is the load-bearing check.**
  The claim is a controlled continuum convergence of the PROJECTION OPERATOR to
  the identity on L2(R^3). It does NOT claim the walk dynamics converge, nor a
  Dirac PDE limit; the `state/CLAIMS.json` note and both module docstrings say
  so explicitly. Scope correctly bounded.
- fitted-to-predicted: N/A.
- common-shape-to-common-origin: N/A.
- arithmetic-as-dynamics: N/A.

## Notes / watch items (not defects)

- SRL 5 is correct and, if anything, conservative: this is a general theorem
  over all L2 with a controlled asymptotic mechanism (borders SRL 6), but since
  the reconstruction/inverse map (walk coefficients -> field) is explicitly not
  included, SRL 5 is the honest floor. I concur with 5.
- **Manuscript watch:** `CLAIMS.json` lists Paper A (`From_Area_to_Dirac_Gap`)
  and the overview packet under `manuscript_uses`. The integrating agent must
  ensure Paper A cites this as "the cell-average projection converges to the
  identity on L2," NOT "the walk converges to the Dirac field." The overview
  packet (checked) already treats full position-space convergence as open, so
  it is consistent. Flag for the manuscript-integration step.

## Disposition

Independence gate SATISFIED for D-PROJ-L2 (Codex build, Claude-family skeptic).
Codex may advance CONT-PROJ-001 VERIFYING -> RED_TEAM -> (REPLICATING) with this
report as the recorded cross-family review. BLK-002 is resolved. I recommend a
clean-context REPLICATING pass by a fresh agent that did not build or audit
(neither codex nor this claude session) before INTEGRATED, per the release path.
