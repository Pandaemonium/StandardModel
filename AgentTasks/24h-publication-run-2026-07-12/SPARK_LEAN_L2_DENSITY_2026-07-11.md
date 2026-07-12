# SPARK L2-density note: 2026-07-11

Context file: `ChangingMomentumCellSampling.lean` has convergence for concrete compact-support Lipschitz samplers in squared `L2(ℝ^3)`; next gate is arbitrary complex `L2` input + multiplier composition.

## Scope and constraints
- Repository: `C:\Projects\StandardModel`
- Active run: `AgentTasks/24h-publication-run-2026-07-12`
- Report file target: this file (`SPARK_LEAN_L2_DENSITY_2026-07-11.md`)
- Mathlib toolchain pin in `lakefile.toml`: Lean 4.28.0; mathlib pinned via `lakefile.toml` / manifest.

## Mathlib declarations found (exact names + modules + callable signatures)

### A. Density of compactly supported continuous / smooth functions in `Lp`
1. `MeasureTheory.MemLp.exists_hasCompactSupport_eLpNorm_sub_le`
- Module: `Mathlib/MeasureTheory/Function/ContinuousMapDense.lean`
- Signature gist (from source):
  - For regular/locally compact assumptions, `p ≠ ∞`, and target normed space assumptions, any `hf : MemLp f p μ` can be approximated by a continuous function with compact support `g` with `eLpNorm (f - g) p < ε`.
- Source lines in local mathlib: around 135–187.

2. `MeasureTheory.MemLp.exists_boundedContinuous_eLpNorm_sub_le`
- Module: same file
- Signature gist:
  - Bounded continuous approximation of `f` in `eLpNorm` with error `< ε`.
- Source lines: around 323–332.

3. `ContinuousMap.toLp_denseRange`
- Module: `Mathlib/MeasureTheory/Function/ContinuousMapDense.lean`
- Signature gist:
  - `continuousMap` inclusion into `Lp` has dense range under finite weakly regular compact-domain hypotheses.
- Source lines: around 360–367.

4. `MeasureTheory.MemLp.exist_eLpNorm_sub_le`
- Module: `Mathlib/Analysis/Normed/Lp/SmoothApprox.lean`
- Signature gist:
  - Finite-dimensional-space `Lp` approximation by compact-support `ContDiff` functions, with explicit `eLpNorm` bound `< ε`.
- Source lines: around 80–95.

5. `HasCompactSupport.exist_eLpNorm_sub_le_of_continuous`
- Module: `Mathlib/Analysis/Normed/Lp/SmoothApprox.lean`
- Signature gist:
  - If a target function is continuous with compact support and has finite `eLpNorm`, then it is approximated in `eLpNorm` by smooth compact-support functions.
- Source lines: around 37–70.

6. `MeasureTheory.Lp.dense_hasCompactSupport_contDiff`
- Module: `Mathlib/Analysis/Normed/Lp/SmoothApprox.lean`
- Signature gist:
  - Dense theorem in `Lp`: compact-support smooth functions are dense in `MemLp` spaces (for compatible assumptions).
- Source lines: around 97–111.

### B. `snorm` / `Lp` triangle-interface lemmas (for decomposition error bounds)
1. `MeasureTheory.eLpNorm_add_le`
- Module: `Mathlib/MeasureTheory/Function/LpSeminorm/TriangleInequality.lean`
- Signature gist:
  - `‖f + g‖[μ,p] ≤ ‖f‖[μ,p] + ‖g‖[μ,p]` (with measurability + `1 ≤ p`).

2. `MeasureTheory.eLpNorm_sub_le`
- Module: same
- Signature gist:
  - analogous bound for subtraction.

3. `MeasureTheory.eLpNorm_sub_le'`
- Module: same
- Signature with `LpAddConst` constant-term lifting.

4. `MeasureTheory.eLpNorm_add_le'`, `MeasureTheory.eLpNorm'_add_le`
- Module: same
- Constants/versions for `snorm`-style formulations and/or seminorm coercions.

### C. Fourier / Plancherel interfaces
1. `MeasureTheory.Lp.fourierTransformₗᵢ`
- Module: `Mathlib/Analysis/Fourier/LpSpace.lean`
- Signature gist:
  - `Lp`-valued Fourier transform constructor (linear isometry infrastructure, notation `fourierTransformₗᵢ`).

2. `MeasureTheory.Lp.norm_fourier_eq`
- Module: same
- Signature gist:
  - `‖fourierTransformₗᵢ f‖₂ = ‖f‖₂` under `ℝ` finite-dimensional source assumptions, complex target, and `p=2` framework.

3. `MeasureTheory.Lp.inner_fourier_eq`
- Module: same
- Signature gist:
  - inner-product/Plancherel identity for Fourier transform in `L2`.

4. `SchwartzMap.norm_fourier_toL2_eq`
- Module: `Mathlib/Analysis/Distribution/SchwartzSpace/Fourier`
- Signature gist:
  - L2 norm equality route for Schwartz maps; potentially useful if multiplier bridge is easier via Schwartz core.

## External package hits (public Lean packages)
1. `Physlib.QuantumMechanics.DDimensions.SpaceDHilbertSpace.SchwartzSubmodule.dense`
- Package: `Physlib` (HEPLean PhysLean)
- Source link: `Physlib/QuantumMechanics/DDimensions/SpaceDHilbertSpace/SchwartzSubmodule.lean`
- Relation: prior-art dense Schwartz-in-`L2` theorem style, but not a local dependency of this repo at present.

## Version and dependency notes
- Mathlib declarations above align with the current pinned mathlib commit used by this repo (v4.28-era, observed source link base `843d7890...`).
- `Physlib` is not in local `lake-manifest` as an imported dependency today; use only as conceptual comparison unless the run explicitly adds it.

## Minimal typechecking successor theorem (recommended)

A practical next theorem that should typecheck with least perturbation is:

- First stage: use `MeasureTheory.MemLp.exists_hasCompactSupport_eLpNorm_sub_le` for `ℝ^3` to produce `g` with
  - `HasCompactSupport g`
  - (preferably) Lipschitz regularization or smooth `g` if a sampler hypothesis needs it (bridge via `MeasureTheory.MemLp.exist_eLpNorm_sub_le` / `HasCompactSupport.exist_eLpNorm_sub_le_of_continuous`)
  - `eLpNorm (f - g) 2 < ε`.

- Then prove:
  - existing `ChangingMomentumCellSampling` theorem: `sampleFinite_tendsto_sq_error_zero` (compact-support Lipschitz theorem) on `g`
  - multiplier-bridge compatibility using `ContinuumL2MultiplierBridge.lean`/`CompactSupportL2WalkBridge.lean`.

- Close by triangle bounds:
  - `MeasureTheory.eLpNorm_sub_le` and `MeasureTheory.eLpNorm_add_le` to split `error(f) ≤ error(g) + C * ‖f-g‖₂` and push `ε`-control through `tendsto` algebra.

Suggested statement shape:

```lean
-- placeholder names for operators are intentionally minimal and should be filled from local APIs
 theorem sampleFinite_tendsto_sq_error_zero_of_memLp
   [NormedRing ...] [MeasurableSpace ...] ...
   {f : Momentum3 → ℂ}
   (hf : AEStronglyMeasurable f) (hf2 : MemLp f 2 volume)
   (hmult : MemLp multiplier 2 volume)
   : Tendsto (fun N => sample_l2_error (f ⋆ₗ multiplier) N) atTop (𝓝 0) :=
 by
  -- 1) pick compact-support approximant `g`
  rcases hf2.exists_hasCompactSupport_eLpNorm_sub_le hε with ⟨g, hg_memLp, hg_compact, hg_err⟩
  -- 2) apply existing compact-support theorem to `g`
  -- 3) transport to `f` via eLpNorm sub/add inequalities
```

## Exact commands to rerun in follow-up
- `lake env lean PhysicsSM/Draft/NullEdge/ChangingMomentumCellSampling.lean`
- `lake env lean PhysicsSM/Draft/NullEdge/ContinuumL2MultiplierBridge.lean`
- `lake env lean PhysicsSM/Draft/NullEdge/CompactSupportL2WalkBridge.lean`

## Risks / semantic alignment checkpoints
1. Confirm exact theorem statement in the existing compact-support sampler needs `Continuous` vs `Lipschitz` vs a stronger differentiability class.
2. If the sampler uses a strict function type (`α → ℂ` vs `α →ᵐ[μ] ℂ`), convert approximation lemma output accordingly.
3. The theorem `exists_hasCompactSupport_eLpNorm_sub_le` gives compact support + continuous approximation in `eLpNorm`; verify if `toLp` coercions/`aeEq` normalization are required before direct reuse.
4. For multiplier composition, confirm whether `smul`/`mul` pointwise vs composition map is used so that triangle bounds hit the right side branch.
